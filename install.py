import os
import subprocess
import platform

def setup_and_launch():
    """Sets up the project requirements and launches the application."""

    print("Starting setup and launch process...")

    # --- Backend Setup ---
    print("\n--- Setting up backend ---")

    # Create and activate virtual environment
    venv_path = "venv"
    if not os.path.exists(venv_path):
        print("Creating virtual environment...")
        subprocess.run(["python", "-m", "venv", venv_path], check=True)

    # Activate virtual environment
    activate_script = os.path.join(venv_path, "Scripts", "activate") if platform.system() == "Windows" else os.path.join(venv_path, "bin", "activate")
    activate_command = f"source {activate_script}" if platform.system() != "Windows" else activate_script
    print(f"Activating virtual environment using: {activate_command}")

    # Install backend dependencies
    print("Installing backend dependencies...")
    subprocess.run([activate_command + " && pip install -r backend/requirements.txt"], shell=True, check=True)

    # --- MATLAB Engine API Setup (Windows only) ---
    if platform.system() == "Windows":
        print("\n--- Setting up MATLAB Engine API (Windows) ---")
        try:
            # Find MATLAB installation directory (example, adjust as needed)
            matlab_root = None
            for root, dirs, _ in os.walk("C:\\Program Files\\MATLAB"):
                for dir_name in dirs:
                    if dir_name.startswith("R20"):  # Assumes MATLAB directory starts with "R20"
                        matlab_root = os.path.join(root, dir_name)
                        break
                if matlab_root:
                    break

            if matlab_root:
                print(f"MATLAB root directory found: {matlab_root}")

                # Install MATLAB Engine API (adjust path if necessary)
                matlab_engine_api_path = os.path.join(matlab_root, "extern", "engines", "python")
                if os.path.exists(matlab_engine_api_path):
                    print(f"Installing MATLAB Engine API from: {matlab_engine_api_path}")
                    subprocess.run(["python", "setup.py", "install"], cwd=matlab_engine_api_path, check=True)
                else:
                    print("MATLAB Engine API directory not found. Make sure MATLAB is installed correctly.")
            else:
                print("MATLAB installation directory not found.  Please ensure MATLAB is installed in the default location.")

        except Exception as e:
            print(f"Error setting up MATLAB Engine API: {e}")

    # --- Frontend Setup ---
    print("\n--- Setting up frontend ---")

    # Install frontend dependencies
    print("Installing frontend dependencies...")
    frontend_dir = "frontend"
    subprocess.run(["pnpm", "install"], cwd=frontend_dir, check=True)

    # --- Launch Application ---
    print("\n--- Launching application ---")

    # Start backend
    print("Starting backend...")
    backend_command = f"{activate_command} && python backend/app.py"
    subprocess.Popen(backend_command, shell=True)  # Run in background

    # Start frontend
    print("Starting frontend...")
    frontend_command = ["pnpm", "run", "dev"]
    subprocess.Popen(frontend_command, cwd=frontend_dir)  # Run in background

    print("\nSetup and launch complete! The application should be running in your browser.")

if __name__ == "__main__":
    setup_and_launch()