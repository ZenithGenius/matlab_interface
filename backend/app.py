import os
import glob
from flask_cors import CORS
from matlab_interface import MatlabInterface
from flask import Flask, request, jsonify, send_from_directory

app = Flask(__name__)
CORS(app)

matlab = MatlabInterface()

method_mapping = {

    '1_2': matlab.run_imedance_ligne_microruban,
    '1_3': matlab.run_relaxation,
    '1_4': matlab.run_surelaxation,
    '1_5': matlab.run_code3,
    '1_6': matlab.run_shield_microstrip_line,
    '2_0': matlab.run_maillage,
    '2_1': matlab.run_poisson,
    '2_2': matlab.run_maillageauto,
    '3_0': matlab.run_residus,
    '3_1': matlab.run_residusx,
    '3_2': matlab.run_application876,
    '3_3': matlab.run_comparaison,
    '3_4': matlab.run_phil2,
    '3_5': matlab.run_ligneruban,
    '3_6': matlab.run_application196,
    '3_7': matlab.run_residus2,
    '3_8': matlab.run_general2,
    '3_9': matlab.run_hallen
}

method_name_mapping = {
    '1_2': 'imedance_ligne_microruban',
    '1_3': 'relaxation',
    '1_4': 'surelaxation',
    '1_5': 'code3',
    '1_6': 'shield_microstrip_line',
    '2_0': 'maillage',
    '2_1': 'poisson',
    '2_2': 'maillageauto',
    '3_0': 'residus',
    '3_1': 'residusx',
    '3_2': 'application876',
    '3_3': 'comparaison',
    '3_4': 'phil2',
    '3_5': 'ligneruban',
    '3_6': 'application196',
    '3_7': 'residus2',
    '3_8': 'general2',
    '3_9': 'hallen'
}

def get_latest_result(method_id, file_type='txt', image_type=None):
    """Get the most recent result file for a given method."""
    # Convert method ID to actual function name
    method_name = method_name_mapping.get(method_id, method_id)
    base_path = f'results/{method_name.lower()}'
    
    if file_type == 'txt':
        pattern = f'{base_path}/{method_name.lower()}_results*.{file_type}'
    elif file_type == 'png':
        # Specific naming convention for image files
        if image_type:
            pattern = f'{base_path}/{method_name.lower()}_plot*_{image_type}.{file_type}'
        else:
            pattern = f'{base_path}/{method_name.lower()}_plot*.{file_type}'
    
    print(f"Searching for files matching pattern: {pattern}")
    files = glob.glob(pattern)
    print(f"Found files: {files}")
    
    if not files and file_type == 'txt':
        # Try without counter in filename for text files
        pattern = f'{base_path}/{method_name.lower()}_results.{file_type}'
        print(f"No files found, trying pattern: {pattern}")
        files = glob.glob(pattern)
        print(f"Found files (second attempt): {files}")
    
    if files:
        latest_file = max(files, key=os.path.getmtime)
        print(f"Latest file found: {latest_file}")
        return latest_file
    
    print(f"No files found for {method_name} with type {file_type}")
    return None

@app.route('/execute', methods=['POST'])
def execute_code():
    try:
        print("Received request to /execute endpoint")
        data = request.get_json()
        print(f"Request data: {data}")

        method_id = data.get('method')
        print(f"Method ID: {method_id}")

        if not method_id:
            return jsonify({'success': False, 'error': 'Aucun identifiant de méthode fourni'})

        if method_id not in method_mapping:
            return jsonify({'success': False, 'error': 'Identifiant de méthode invalide'})

        # Execute the method
        method_to_call = method_mapping[method_id]
        print(f"Executing method for ID: {method_id}")
        if method_id == '2_2':
            nx = data.get('nx')
            ny = data.get('ny')
            a = data.get('a')
            b = data.get('b')
            method_to_call(nx, ny, a, b)
        else:
            method_to_call()
        print(f"Method execution completed")

        # Initialize a list to hold results
        results = []

        # Look for the most recent text result file
        text_file = get_latest_result(method_id, 'txt')
        if text_file:
            with open(text_file, 'r') as f:
                text_results = f.read()
            print(f"Found and read text results from: {text_file}")
            results.append({'type': 'text', 'data': text_results})

        # Look for the most recent png image file
        image_file_Z = get_latest_result(method_id, 'png')
        if image_file_Z:
            relative_path_Z = image_file_Z.replace('results/', '', 1)
            print(f"Found image file Z, serving: {relative_path_Z}")
            results.append({'type': 'image', 'data': f"{relative_path_Z}"})
            
        # Look for the most recent png image file
        image_file_U = get_latest_result(method_id, 'png');
        if image_file_U:
            relative_path_U = image_file_U.replace('results/', '', 1)
            print(f"Found image file U, serving: {relative_path_U}")
            results.append({'type': 'image', 'data': f"{relative_path_U}"})

        # Determine the type of result to return
        if results:
            if len(results) == 1:
                # If there's only one result, return it directly
                return jsonify({'success': True, 'result': results[0]})
            else:
                # If there are multiple results, return them as a list
                return jsonify({'success': True, 'result': {'type': 'multiple', 'data': results}})
        else:
            # If no results were found
            print("No results found for either text or image files")
            return jsonify({'success': False, 'error': 'Aucun résultat trouvé'})

    except Exception as e:
        print(f"Error in /execute endpoint: {str(e)}")
        return jsonify({'success': False, 'error': str(e)})

@app.route('/results/<path:filename>')
def serve_results(filename):
    # Split the path to get the method name and actual filename
    parts = filename.split('/')
    if len(parts) > 1:
        method_name = parts[0]
        return send_from_directory(f'results/{method_name}', parts[-1])
    return send_from_directory('results', filename)

@app.route('/get-matlab-code/<method_id>', methods=['GET'])
def get_matlab_code(method_id):
    try:
        # Convert method ID to actual function name using the existing mapping
        method_name = method_name_mapping.get(method_id)
        if not method_name:
            return jsonify({'success': False, 'error': 'Invalid method ID'})

        # Construct the path to the MATLAB file
        file_path = f'matlab_scripts/{method_name.lower()}.m'
        
        # Check if file exists
        if not os.path.exists(file_path):
            return jsonify({'success': False, 'error': f'MATLAB file not found: {file_path}'})

        # Read the MATLAB code
        with open(file_path, 'r') as file:
            matlab_code = file.read()

        return jsonify({'success': True, 'code': matlab_code})

    except Exception as e:
        print(f"Error reading MATLAB code: {str(e)}")
        return jsonify({'success': False, 'error': str(e)})

if __name__ == '__main__':
    print("Starting Flask server...")
    app.run(debug=True, port=5000) 