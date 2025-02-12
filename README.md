# Electromagnetic Numerical Analysis Interface

## Overview

This project integrates a Python Flask backend with a React TypeScript frontend, leveraging MATLAB (on Windows) or Octave (on Linux/macOS) for numerical computations. This README provides comprehensive instructions for setting up, installing, and running the application, covering both frontend and backend components across different operating systems.

## Technologies Used

*   **Frontend:** React, TypeScript, Vite, Tailwind CSS
*   **Backend:** Python, Flask, Flask-CORS
*   **MATLAB:** For numerical computations
*   **Other:** pnpm, npm

## Backend Setup

### Prerequisites

*   Python 3.7+ (Installation instructions below)
*   MATLAB (on Windows, with specific version requirements, see below)
*   Octave (on Linux/macOS)

#### Python Installation

1.  **Download Python:** Go to the [official Python website](https://www.python.org/downloads/) and download the appropriate installer for your operating system.
2.  **Install Python:** Run the installer and follow the instructions. Make sure to check the box that adds Python to your system's PATH environment variable.
3.  **Verify Installation:** Open a new command prompt or terminal and run:

    ```bash
    python --version
    ```

    This should display the installed Python version.

### Installation

1.  **Create a virtual environment:**

    ```bash
    python3 -m venv venv
    source venv/bin/activate  # On Linux/macOS
    venv\Scripts\activate  # On Windows
    ```

2.  **Install dependencies:**

    ```bash
    pip install -r backend/requirements.txt
    ```

### MATLAB Setup

1.  **Install MATLAB:** Ensure you have MATLAB installed. This project may require a specific version of MATLAB due to compatibility issues with the `matlabengine` Python package. It is recommended to use MATLAB version 2020b or later.

2.  **Install the MATLAB Engine API for Python (Windows):**

    *   Navigate to your MATLAB installation directory.
    *   Run the following command:

        ```bash
        python setup.py install
        ```

        Replace `python` with the specific Python interpreter you are using in your virtual environment (e.g., `python3.7`).

    *   **Verify Installation:** In your Python environment, run:

        ```python
        import matlab.engine
        ```

        If this command executes without errors, the MATLAB Engine API is installed correctly.

3.  **Install Octave and Octave packages (Linux/macOS):**

    *   Install Octave using your distribution's package manager (e.g., `apt`, `yum`, `brew`).
    *   Install the `oct2py` Python package:

        ```bash
        pip install oct2py
        ```

### MATLAB/Octave Configuration

1.  **Set MATLAB/Octave Path:** Ensure that the MATLAB scripts directory is added to the MATLAB/Octave path. This is handled automatically by the `matlab_interface.py` file.

### Running the Backend

## Getting Started with Git

Git is a distributed version control system that allows you to track changes to your code, collaborate with others, and revert to previous versions if needed.

**Prerequisites:**

*   **Git:** You need to have Git installed on your system. You can download it from the [official Git website](https://git-scm.com/downloads). For Windows users, Git Bash is recommended as it provides a Unix-like environment for using Git.

**Cloning the Repository:**

To obtain a local copy of the project repository, use the following command in your terminal or Git Bash:

```bash
git clone https://github.com/ZenithGenius/matlab_interface.git
```

This command will create a directory named `matlab_interface` in your current location, containing all the project files and the Git history.

**Further Learning:**

*   [Git Documentation](https://git-scm.com/doc)
*   [GitHub Guides](https://guides.github.com/)

The `matlab_interface.py` file automatically selects the appropriate engine (MATLAB or Octave) based on the operating system.

1.  **Install Dependencies:** Install the necessary Python packages using pip:

    ```bash
    pip install -r requirements.txt
    ```

2.  **Run the Flask server:**

    ```bash
    python backend/app.py
    ```

    The server will start on port 5000 (or the port specified in the `app.py` file).

## Frontend Setup

### Prerequisites

*   Node.js 18+ (Installation instructions below)
*   pnpm (or npm/yarn) (Installation instructions below)

#### Node.js Installation

1.  **Download Node.js:** Go to the [official Node.js website](https://nodejs.org/en/download/) and download the appropriate installer for your operating system.
2.  **Install Node.js:** Run the installer and follow the instructions.

#### pnpm Installation

```bash
npm install -g pnpm
```

### Installation

1.  **Install dependencies:**

    ```bash
    pnpm install # or npm install or yarn install
    ```

### Running the Frontend

2.  **Start the development server:**

    ```bash
    pnpm run dev # or npm run dev or yarn run dev
    ```

    The frontend development server will start on a specified port (usually 3000 or 5173).

### .gitignore Files

The `.gitignore` files in both the `frontend` and `backend` directories specify the files and directories that should be excluded from version control (e.g., `node_modules`, `venv`, temporary files).

## Code Documentation

### Backend

#### `app.py`

This file contains the Flask application that serves as the backend API. It handles requests, executes MATLAB scripts, and returns the results.

*   `/execute` endpoint: Executes a specified MATLAB script based on the `method` parameter in the request body.
*   `/results/<path:filename>` endpoint: Serves result files (images or text) generated by the MATLAB scripts.
*   `/calculate` endpoint: Executes a simple MATLAB calculation and returns the result.
*   `/get-matlab-code/<method_id>` endpoint: Retrieves the MATLAB code for a given method ID.

#### Running Tests (`test_matlab_interface.py`)

To ensure the MATLAB interface is working correctly, run the tests in `test_matlab_interface.py`:

```bash
python backend/test_matlab_interface.py
```

This will execute a series of tests that call the MATLAB scripts and verify that they are running correctly.

#### Results Directory (`results/`)

The `results` directory stores the output files generated by the MATLAB scripts. Each script has its own subdirectory, and the result files are named according to the method ID and a timestamp. Image files are named `<method_name>_plot.png`.

#### `matlab_interface.py`

This file defines the `MatlabInterface` class, which is responsible for interacting with the MATLAB engine.

*   `__init__`: Initializes the MATLAB or Octave engine based on the operating system.
*   `run_calculation`: Executes a simple MATLAB calculation.
*   `run_poisson`, `run_phil2`, `run_hallen`, `run_residus2`, `run_general2`: Execute specific MATLAB scripts.
*   `__del__`: Closes the MATLAB or Octave engine when the object is destroyed.

#### MATLAB Scripts (`matlab_scripts/`)

This directory contains the MATLAB scripts that perform the numerical computations. Each script corresponds to a specific method ID.

*   `poisson.m`: Solves the Poisson equation using finite difference methods.
*   `phil2.m`: Implements a specific numerical method (details may be found within the script).
*   `hallen.m`: Implements Hallen's equation for antenna analysis.
*   `residus2.m`: Implements another numerical method (details may be found within the script).
*   `general2.m`: Implements a general numerical method (details may be found within the script).

### Frontend

#### `src/App.tsx`

This file is the main component of the React application. It handles user interactions, makes API calls to the backend, and displays the results.

#### `src/index.css`

This file contains the CSS styles for the application, using Tailwind CSS.

## Usage Instructions

### Running the Application

1.  **Start the backend server:** Follow the instructions in the "Backend Setup" section to start the Flask server.
2.  **Start the frontend development server:** Follow the instructions in the "Frontend Setup" section to start the Vite development server.
3.  **Access the application:** Open your web browser and navigate to the address where the frontend development server is running (e.g., `http://localhost:3000`).

### Example API Calls

*   **Execute a MATLAB script:**

    ```
    POST /execute
    Content-Type: application/json

    {
      "method": "2_1"
    }
    ```

    This will execute the `run_poisson` MATLAB script and return the results.

*   **Get MATLAB code:**

    ```
    GET /get-matlab-code/2_1
    ```

    This will return the MATLAB code for the `run_poisson` method.

### Frontend Interactions

The frontend provides a user interface for selecting and executing MATLAB scripts. It displays the results in either text or image format.

## Troubleshooting

### MATLAB Engine API Issues

*   **"ImportError: No module named matlab.engine"**: This error indicates that the MATLAB Engine API for Python is not installed correctly. Double-check the installation steps in the "MATLAB Setup" section. Ensure that you are using the correct Python interpreter and that the MATLAB installation directory is in your system's PATH.
*   **MATLAB crashes or freezes**: This can be due to various issues, such as memory limitations or errors in the MATLAB scripts. Try increasing the memory allocated to MATLAB or debugging the scripts.

### Frontend Issues

*   **"Module not found"**: This error indicates that a required frontend dependency is missing. Run `pnpm install` (or `npm install` or `yarn install`) to install the dependencies.
*   **"Cannot connect to backend"**: This error indicates that the frontend is unable to communicate with the backend server. Ensure that the backend server is running and that the frontend is configured to point to the correct API endpoint.
*   **Blank page or unexpected behavior**: Check the browser's developer console for JavaScript errors. These errors can provide clues about what is going wrong in the frontend code.

### CORS Issues

If you encounter Cross-Origin Resource Sharing (CORS) issues, ensure that the Flask backend is configured to allow requests from the frontend origin. The `flask-cors` package is used to handle CORS. You can configure the allowed origins in the `app.py` file:

```python
CORS(app, resources={r"/*": {"origins": "*"}}) # Allow all origins (for development)
```

### Octave Issues

*   **"oct2py.core.OctaveError: ... not found on load path"**: This error indicates that Octave cannot find the MATLAB scripts. Ensure that Octave is correctly installed and that the `matlab_scripts` directory is in Octave's load path. The `matlab_interface.py` attempts to add this path automatically.
*   **Octave crashes or freezes**: This can be due to various issues, such as memory limitations or errors in the Octave scripts. Try increasing the memory allocated to Octave or debugging the scripts.
