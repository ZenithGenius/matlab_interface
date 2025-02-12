import os
import glob
from flask_cors import CORS
from matlab_interface import MatlabInterface
from flask import Flask, request, jsonify, send_from_directory

app = Flask(__name__)
CORS(app)

matlab = MatlabInterface()

method_mapping = {
    # '0_0': matlab.run_0_0,  # Example mapping for method ID '0_0'
    # '0_1': matlab.run_0_1,  # Example mapping for method ID '0_1'
    # '0_2': matlab.run_0_2,  # Example mapping for method ID '0_2'
    # '1_0': matlab.run_euler, # Example mapping for method ID '1_0'
    # '1_1': matlab.run_crank_nicholson, # Example mapping for method ID '1_1'
    # '1_2': matlab.run_iterative_methods, # Example mapping for method ID '1_2'
    # '2_0': matlab.run_laplace, # Example mapping for method ID '2_0'
    '2_1': matlab.run_poisson, # Example mapping for method ID '2_1'
    # '2_2': matlab.run_helmholtz, # Example mapping for method ID '2_2'
    # Add mappings for all other method IDs
    '0_0': matlab.run_phil2,
    '0_1': matlab.run_hallen,
    '0_2': matlab.run_residus2,
    '1_0': matlab.run_general2,

}

method_name_mapping = {
    '0_0': 'phil2',
    '0_1': 'hallen',
    '0_2': 'residus2',
    '1_0': 'general2',
    '2_1': 'poisson',
    # Add other mappings as needed
}

def get_latest_result(method_id, file_type='txt'):
    """Get the most recent result file for a given method."""
    # Convert method ID to actual function name
    method_name = method_name_mapping.get(method_id, method_id)
    base_path = f'results/{method_name.lower()}'
    
    if file_type == 'txt':
        pattern = f'{base_path}/{method_name.lower()}_results*.{file_type}'
    elif file_type == 'png':
        # Specific naming convention for image files
        pattern = f'{base_path}/{method_name.lower()}_plot.png'
    
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
            return jsonify({'success': False, 'error': 'No method ID provided'})

        if method_id not in method_mapping:
            return jsonify({'success': False, 'error': 'Invalid method ID'})

        # Execute the method
        method_to_call = method_mapping[method_id]
        print(f"Executing method for ID: {method_id}")
        method_to_call()
        print(f"Method execution completed")

        # Look for the most recent result file
        result_file = get_latest_result(method_id, 'txt')
        if result_file:
            with open(result_file, 'r') as f:
                results = f.read()
            print(f"Found and read results from: {result_file}")
            return jsonify({'success': True, 'data': results, 'type': 'text'})

        # If no text file, look for image
        image_file = get_latest_result(method_id, 'png')
        if image_file:
            relative_path = image_file.replace('results/', '', 1)
            print(f"Found image file, serving: {relative_path}")
            return jsonify({'success': True, 'data': f"/{relative_path}", 'type': 'image'})

        print("No results found for either text or image files")
        return jsonify({'success': False, 'error': 'No results found'})

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

@app.route('/calculate', methods=['POST'])
def calculate():
    try:
        data = request.get_json()
        input_value = data.get('input', 0)
        print(f"Received input for calculation: {input_value}")
        result = matlab.run_calculation(float(input_value))
        print(f"Sending result back to client: {result}")
        return jsonify({'success': True, 'data': result})
    except Exception as e:
        print(f"Error in /calculate endpoint: {str(e)}")
        return jsonify({'success': False, 'error': str(e)})

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