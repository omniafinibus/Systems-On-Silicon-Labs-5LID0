# ======= # 
# Imports # 
# ======= # 
import os 
import shutil
import subprocess
from glob import glob

# =========== # 
# Definitions # 
# =========== # 
PERIOD_LBL       = "$PERIOD$"
POWER_1_LBL      = "$POWER_1$"
POWER_2_LBL      = "$POWER_2$"
LEAKAGE_PWR_LBL  = "$LEAKPWR$"
OPTIMIZATION_LBL = "$OPTIMIZATIONS$"

HOME_DIR = "/" + os.path.join("home", "sos23", "sos23023", "lab2", "mMIPS")
SYNTH_DIR = os.path.join(HOME_DIR, "synth")
SYNTH_NAME = "synth.tcl"
CPF_NAME = "prepare_CPF_input.tcl"
SCRIPT_DIR = os.path.join(SYNTH_DIR, "script", SYNTH_NAME)
CPF_DIR = os.path.join(SYNTH_DIR, "script", CPF_NAME)
LOG_DIR = os.path.join(SYNTH_DIR, "logs")

REPORT_DIR = os.path.join(SYNTH_DIR, "report")
RESULTS_POWER_DIR = os.path.join(REPORT_DIR, "mMIPS_system_cpf.power")
RESULTS_AREA_DIR = os.path.join(REPORT_DIR, "mMIPS_system_cpf.area")
RESULTS_TIMING_DIR = os.path.join(REPORT_DIR, "mMIPS_system_cpf.timing")
RESULTS_GATES_DIR = os.path.join(REPORT_DIR, "mMIPS_system_cpf.gates")

AUTO_DIR = os.path.join(HOME_DIR, "auto_tester_script")
RESULT_DIR = os.path.join(AUTO_DIR, "results")
OUTPUT_FILE = os.path.join(RESULT_DIR, "summary.csv")

# ============ # 
# Data Classes # 
# ============ # 
class Configuration:
    def __init__(self, period, leakagePower, dOptimizations, power1, power2):
        self.period = period
        self.leakagePower = leakagePower
        self.dOptimizations = dOptimizations
        self.power1 = power1
        self.power2 = power2
        self.folderName = f"{self.period}_{self.power1}_{self.power2}_{self.leakagePower}_" + "_".join(self.dOptimizations.keys())
        
class Area:
    def __init__(self, instances, area, areaPercentage):
        self.instances = instances
        self.area = area
        self.areaPercentage = areaPercentage

class Results:
    def __init__(self, leakagePower = 0.0, dynamicPower = 0.0, totalPower = 0.0, slack = 0.0):
        self.leakagePower = leakagePower
        self.dynamicPower = dynamicPower
        self.totalPower = totalPower
        self.slack = slack
        self.dArea = dict()
        
    def add_area(self, name:str, instances:str, area:str, areaPercentage):
        if all([is_number(instances), is_number(area), is_number(areaPercentage)]):
            self.dArea[name] = Area(instances, area, areaPercentage)
            return True
        else:
            print(f"[WARNING] Area not added, data in wrong format: {name} {instances} {area} {areaPercentage}")
            return False
            
# ========= # 
# Functions # 
# ========= # 
def is_number(s):
    try:
        float(s)
        return True
    except ValueError:
        return False
        
def get_synth_text(config: Configuration):
    """Create the contents of a config file based on a custom configuration

    :param config: Configuration to read the parameters from
    :type config: Configuration
    :return: Contents of the new config file
    :rtype: str
    """    
    confTemp = os.path.join(AUTO_DIR, "synth_template.tcl")
    print("[INFO]\tOpening file: " + confTemp)
    temp = open(confTemp, "r").read()
    temp = temp.replace(PERIOD_LBL, config.period)
    temp = temp.replace(OPTIMIZATION_LBL, "\n".join([value for value in config.dOptimizations.values()]))
    temp = temp.replace(LEAKAGE_PWR_LBL, config.leakagePower)
    return temp

def get_CPF_text(config: Configuration):
    """Create the contents of a config file based on a custom configuration

    :param config: Configuration to read the parameters from
    :type config: Configuration
    :return: Contents of the new config file
    :rtype: str
    """    
    confTemp = os.path.join(AUTO_DIR, "cpf_template.tcl")
    print("[INFO]\tOpening file: " + confTemp)
    temp = open(confTemp, "r").read()
    temp = temp.replace(POWER_1_LBL, config.power1)
    temp = temp.replace(POWER_2_LBL, config.power2)
    return temp

def replace_files(config):
    """Change the content of the config file with a new configuration

    :param config: Configuration to use for the file contents
    :type config: Configuration
    """    
    if not os.path.exists(SCRIPT_DIR):
        print("[INFO]\tCreating file: " + SCRIPT_DIR)
    with open(SCRIPT_DIR, "w") as file:
        file.write(get_synth_text(config))
        print("[INFO]\tWrote template to: " + SCRIPT_DIR)
        
    if not os.path.exists(CPF_DIR):
        print("[INFO]\tCreating file: " + CPF_DIR)
    print("[INFO]\tCreating file: " + CPF_DIR)
    with open(CPF_DIR, "w") as file:
        file.write(get_CPF_text(config))
        print("[INFO]\tWrote template to: " + SCRIPT_DIR)

def run_simulation():
    """Run the simulation of the currently saved config
    """    
    os.chdir(SYNTH_DIR)
    command = "make synth"
    print("[INFO]\tRunning command:" + command)
    subprocess.call(command, shell=True)

def save_stats(config:Configuration):
    """Save the current stat results into a result object

    :param fileDir: Directory of file to parse
    :type fileDir: str
    :return: converted data from the results file
    :rtype: Results
    """
    result = Results()
    
    # Read power
    with open(RESULTS_POWER_DIR, "r") as file:
        lLines = file.readlines()
        for line in lLines:
            if line.find("--------------------------------------") != -1:
                # Read next line and split into a list
                lLineToRead = lLines[lLines.index(line)+1].split()
                
                if lLineToRead[0] != "mMIPS_system":
                    print(f"[ERROR] Incorrect power line selected: {lLineToRead}")
                
                # Read leakage power
                if is_number(lLineToRead[3]):
                    result.leakagePower = float(lLineToRead[3])
                else:
                    print(f"[ERROR] Couldn't read leakage power: {lLineToRead[3]}")
                    
                # Read dynamic power
                if is_number(lLineToRead[4]):
                    result.dynamicPower = float(lLineToRead[4])
                else:
                    print(f"[ERROR] Couldn't read dynamic power: {lLineToRead[4]}")
                    
                # Read total power
                if is_number(lLineToRead[5]):
                    result.totalPower = float(lLineToRead[5])
                else:
                    print(f"[ERROR] Couldn't read total power: {lLineToRead[5]}")
                
                break

    # Read slack
    with open(RESULTS_TIMING_DIR, "r") as file:
        lLines = file.readlines()
        for line in lLines:
            if line.find("Timing slack :") != -1:
                # Read next line and split into a list
                lSplitLine = line.split()
                if(is_number(lSplitLine[3][:-2])):
                    result.slack = float(lSplitLine[3][:-2]) * (1e-12 if lSplitLine[3][-2] == 'p' else 1)
                else:
                    print(f"[ERROR] Couldn't read slack: {lSplitLine[3][:-2]} {lSplitLine[3][-2:]}")
                break
            
    # Read total area
    with open(RESULTS_POWER_DIR, "r") as file:
        lLines = file.readlines()
        for line in lLines:
            if line.find("--------------------------------------") != -1:
                # Read next line and split into a list
                lLineToRead = lLines[lLines.index(line)+1].split()
                
                if lLineToRead[0] != "mMIPS_system":
                    print(f"[ERROR] Incorrect area line selected: {lLineToRead}")
                    break
                
                # Read Total area
                if not result.add_area(lLineToRead[0], lLineToRead[1], lLineToRead[2], 100.0):
                    print(f"[ERROR] Couldn't read total are: {lLineToRead}")
                
                break
                    
    with open(RESULTS_GATES_DIR, "r") as file:
        lLines = file.readlines()
        for line in lLines:
            if all([
                line.find("Type") != -1,
                line.find("Instances") != -1,
                line.find("Area") != -1,
                line.find("Area %") != -1
                ]):
                # Read next line and split into a list (Skip divider)
                dataLine = lLines[lLines.index(line)+2]
                while dataLine[0] != '-':
                    lSplitData = dataLine.split()
                    
                    if not result.add_area(lSplitData[0], lSplitData[1], lSplitData[2], lSplitData[3]):
                        print(f"[ERROR] Couldn't read total are: {lSplitData}")
                    dataLine = lLines[lLines.index(dataLine)+1]
                break

    # Move results to their own folder
    
    report = os.path.join(RESULT_DIR, config.folderName, "report")
    script = os.path.join(RESULT_DIR, config.folderName, "script")
    logs = os.path.join(RESULT_DIR, config.folderName, "logs")
    os.makedirs(report)
    os.makedirs(script)
    os.makedirs(logs)
    
    for file in glob(REPORT_DIR, recursive=False):
        shutil.move(file, report+"/")
    shutil.move(SCRIPT_DIR, script)
    shutil.move(CPF_DIR, script)
    shutil.move(LOG_DIR, logs)
    
    return result

# =========== # 
# Get results # 
# =========== # 
lConfigs = [
    # Configuration(str(1e6/10), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/60), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/110), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/160), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/210), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/260), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/310), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/360), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/410), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/460), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/510), "medium", {"syn1": "syn_opt"}, "1.2", "1.2"), # 1
    # Configuration(str(1e6/10), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/60), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/110), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/160), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/210), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/260), "medium", {"syn1": "syn_opt"}, "1.0", "1.2"), # 2
    Configuration(str(1e6/10), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
    Configuration(str(1e6/60), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
    Configuration(str(1e6/110), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
    Configuration(str(1e6/160), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
    Configuration(str(1e6/210), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
    Configuration(str(1e6/260), "medium", {"syn1": "syn_opt"}, "1.2", "1.0"), # 2
]


lResults = list()

if not os.path.isfile(OUTPUT_FILE):
    with open(OUTPUT_FILE, 'w') as file:
        file.write("period,optimizations,VCC1,VCC2,slack,leakagePower,dynamicPower,totalPower,type,instances,area,area %\n")
        
for currentIndex, config in enumerate(lConfigs):
    if config.folderName in glob(RESULT_DIR, recursive = False):
        print("[INFO]\t[" + str(currentIndex + 1) + "\\" + str(len(lConfigs)) + "] Test already completered: " + config.folderName)
        
        
    else:    
        print("[INFO]\t[" + str(currentIndex + 1) + "\\" + str(len(lConfigs)) + "] " + config.folderName)
        replace_files(config)
        run_simulation()
        
        result = save_stats(config)
        
        with open(OUTPUT_FILE, 'a') as file:
            file.write(str(config.period) + ",")
            file.write(str(" ".join(config.dOptimizations.keys())) + ",")
            file.write(str(config.power1) + ",")
            file.write(str(config.power2) + ",")
            file.write(str(result.slack) + ",")
            file.write(str(result.leakagePower) + ",")
            file.write(str(result.dynamicPower) + ",")
            file.write(str(result.totalPower) + ",")
            firstArea = True
            for name, area in result.dArea.items():
                if not firstArea:
                    file.write(",,,,,,,,")
                else: firstArea = False
                file.write(str(name) + ",")
                file.write(str(area.instances) + ",")
                file.write(str(area.area) + ",")
                file.write(str(area.areaPercentage))
                file.write("\n")
                
            if not result.dArea:
                file.write("\n")
