from matlab_interface import MatlabInterface

def test_poisson():
    matlab = MatlabInterface()
    try:
        matlab.run_poisson()
        print(f"Poisson Test Result Saved")
    except Exception as e:
        print(f"Poisson Test Failed: {str(e)}")
    finally:
        del matlab

def test_phil2():
    matlab = MatlabInterface()
    try:
        matlab.run_phil2()
        print("Phil2 Test Executed Successfully")
    except Exception as e:
        print(f"Phil2 Test Failed: {str(e)}")
    finally:
        del matlab

def test_hallen():
    matlab = MatlabInterface()
    try:
        matlab.run_hallen()
        print(f"Hallen Test Executed Successfully")
    except Exception as e:
        print(f"Hallen Test Failed: {str(e)}")
    finally:
        del matlab

def test_residus2():
    matlab = MatlabInterface()
    try:
        matlab.run_residus2()
        print("Residus2 Test Executed Successfully")
    except Exception as e:
        print(f"Residus2 Test Failed: {str(e)}")
    finally:
        del matlab

def test_general2():
    matlab = MatlabInterface()
    try:
        matlab.run_general2()
        print("General2 Test Executed Successfully")
    except Exception as e:
        print(f"General2 Test Failed: {str(e)}")
    finally:
        del matlab

if __name__ == "__main__":
    print("Testing Poisson Function")
    test_poisson()
    print("\nTesting Phil2 Function")
    test_phil2()
    print("\nTesting Hallen Function")
    test_hallen()
    print("\nTesting Residus2 Function")
    test_residus2()
    print("\nTesting General2 Function")
    test_general2() 