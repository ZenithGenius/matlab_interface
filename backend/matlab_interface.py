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
    
    def run_residus(self):
        try:
            print("Running Residus script")
            self.eng.residus(nargout=0)  # Specify that no output is expected
            print("Residus script executed successfully")
        except Exception as e:
            print(f"Error during Residus computation: {str(e)}")
            raise Exception(f"Residus computation failed: {str(e)}")
    
    def run_residusx(self):
        try:
            print("Running ResidusX script")
            self.eng.residusx(nargout=0)  # Specify that no output is expected
            print("ResidusX script executed successfully")
        except Exception as e:
            print(f"Error during ResidusX computation: {str(e)}")
            raise Exception(f"ResidusX computation failed: {str(e)}")

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
    
    def run_maillage(self):
        try:
            print("Running Maillage script")
            self.eng.maillage(nargout=0)  # Specify that no output is expected
            print("Maillage script executed successfully")
        except Exception as e:
            print(f"Error during Maillage computation: {str(e)}")
            raise Exception(f"Maillage computation failed: {str(e)}")

    def run_maillageauto(self, nx, ny, a, b):
        try:
            print("Running MaillageAuto script")
            self.eng.maillageauto(float(nx), float(ny), float(a), float(b), nargout=0)  # Pass arguments to the script
            print("MaillageAuto script executed successfully")
        except Exception as e:
            print(f"Error during MaillageAuto computation: {str(e)}")
            raise Exception(f"MaillageAuto computation failed: {str(e)}")
        
    def run_imedance_ligne_microruban(self):
        try:
            print("Running Impedance Ligne Microban script")
            self.eng.imedance_ligne_microruban(nargout=0)  # Pass arguments to the script
            print("Impedance Ligne Microban script executed successfully")
        except Exception as e:
            print(f"Error during Impedance Ligne Microban computation: {str(e)}")
            raise Exception(f"Impedance Ligne Microban computation failed: {str(e)}")
        
    def run_relaxation(self):
        try:
            print("Running relaxation script")
            self.eng.relaxation(nargout=0)  # Pass arguments to the script
            print("Relaxation script executed successfully")
        except Exception as e:
            print(f"Error during relaxation computation: {str(e)}")
            raise Exception(f"Relaxation computation failed: {str(e)}")
        
    def run_surelaxation(self, e, w):
        try:
            print("Running surelaxation script")
            self.eng.surelaxation(e, w, nargout=0)  # Pass arguments to the script
            print("Surelaxation script executed successfully")
        except Exception as e:
            print(f"Error during surelaxation computation: {str(e)}")
            raise Exception(f"Surelaxation computation failed: {str(e)}")
        
    def run_code3(self):
        try:
            print("Running code3 script")
            self.eng.code3(nargout=0)  # Pass arguments to the script
            print("Code3 script executed successfully")
        except Exception as e:
            print(f"Error during Code3 computation: {str(e)}")
            raise Exception(f"Code3 computation failed: {str(e)}")
        
    def run_shield_microstrip_line(self):
        try:
            print("Running shield microstrip line script")
            self.eng.shield_microstrip_line(nargout=0)  # Pass arguments to the script
            print("Shield microstrip line script executed successfully")
        except Exception as e:
            print(f"Error during Code3 computation: {str(e)}")
            raise Exception(f"Shield microstrip line computation failed: {str(e)}")
        
    def run_application876(self):
        try:
            print("Running pplication876 script")
            self.eng.application876(nargout=0)  # Pass arguments to the script
            print("Application876 script executed successfully")
        except Exception as e:
            print(f"Error during Application876 computation: {str(e)}")
            raise Exception(f"Application876 computation failed: {str(e)}")

    def run_application196(self):
        try:
            print("Running pplication619 script")
            self.eng.application196(nargout=0)  # Pass arguments to the script
            print("Application196 script executed successfully")
        except Exception as e:
            print(f"Error during Application196 computation: {str(e)}")
            raise Exception(f"Application196 computation failed: {str(e)}")

    def run_comparaison(self):
        try:
            print("Running comparaison script")
            self.eng.comparaison(nargout=0)  # Pass arguments to the script
            print("Comparaison script executed successfully")
        except Exception as e:
            print(f"Error during comparaison computation: {str(e)}")
            raise Exception(f"Comparaison computation failed: {str(e)}")

    def run_ligneruban(self):
        try:
            print("Running ligne ruban script")
            self.eng.ligneruban(nargout=0)  # Pass arguments to the script
            print("Ligne ruban script executed successfully")
        except Exception as e:
            print(f"Error during ligne ruban computation: {str(e)}")
            raise Exception(f"Ligne ruban computation failed: {str(e)}")

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