import platform
# import matlab.engine # type: ignore
import oct2py

class MatlabInterface:
    def __init__(self):
        """Initialize MATLAB or Octave engine based on the OS"""
        try:
            if platform.system() == 'Linux' or platform.system() == 'Darwin':  # Unix-based systems
                print("Starting Octave engine...")
                self.eng = oct2py.Oct2Py()
                self.eng.addpath('matlab_scripts')
                print("Octave engine started successfully.")
            else:
                print("Starting MATLAB engine...")
                # self.eng = matlab.engine.start_matlab()
                self.eng.addpath('matlab_scripts')
                print("MATLAB engine started successfully.")
        except Exception as e:
            print(f"Error starting engine: {str(e)}")
            raise Exception(f"Failed to start engine: {str(e)}")

    def run_calculation(self, input_data):
        try:
            print(f"Running MATLAB calculation with input: {input_data}")
            # Call your MATLAB function here
            result = self.eng.example_calculation(input_data)
            print(f"Calculation result: {result}")
            return {'result': float(result)}
        except Exception as e:
            print(f"Error during MATLAB computation: {str(e)}")
            raise Exception(f"MATLAB computation failed: {str(e)}")

    def run_poisson(self):
        try:
            print("Running Poisson script")
            self.eng.poisson(nargout=0)
            print("Poisson script executed successfully")
        except Exception as e:
            print(f"Error during Poisson computation: {str(e)}")
            raise Exception(f"Poisson computation failed: {str(e)}")

    def run_phil2(self):
        try:
            print("Running Phil2 script")
            self.eng.phil2(nargout=0)  # Assuming Phil2 does not return a value
            print("Phil2 script executed successfully")
        except Exception as e:
            print(f"Error during Phil2 execution: {str(e)}")
            raise Exception(f"Phil2 execution failed: {str(e)}")

    def run_hallen(self):
        try:
            print(f"Running Hallen script executed successfully")
            self.eng.hallen(nargout=0)
            print(f"Hallen script executed successfully")
        except Exception as e:
            print(f"Error during Hallen computation: {str(e)}")
            raise Exception(f"Hallen computation failed: {str(e)}")

    def run_residus2(self):
        try:
            print("Running Residus2 script")
            self.eng.residus2(nargout=0)  # Specify that no output is expected
            print("Residus2 script executed successfully")
        except Exception as e:
            print(f"Error during Residus2 computation: {str(e)}")
            raise Exception(f"Residus2 computation failed: {str(e)}")

    def run_general2(self):
        try:
            print("Running General2 script")
            self.eng.general2(nargout=0)  # Specify that no output is expected
            print("General2 script executed successfully")
        except Exception as e:
            print(f"Error during General2 computation: {str(e)}")
            raise Exception(f"General2 computation failed: {str(e)}")

    def __del__(self):
        """Cleanup: Close MATLAB or Octave engine"""
        try:
            if hasattr(self, 'eng'):
                print("Closing engine...")
                if isinstance(self.eng, oct2py.Oct2Py):
                    self.eng.exit()
                else:
                    self.eng.quit()
                print("Engine closed.")
        except Exception:
            print("Error closing engine.")
            pass 