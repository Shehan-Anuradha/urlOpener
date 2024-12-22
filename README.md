# URL Opener Tool with GUI  

This PowerShell-based application automates the process of opening multiple URLs in a browser, featuring an easy-to-use graphical user interface (GUI).  

## Features  
- **Customizable Settings**:  
  - Set time gaps between URL launches.  
  - Specify the number of URLs to open in a single cluster.  

- **Multi-Browser Support**:  
  - Switch between Chrome and Firefox as the default browser.  

- **Pause and Resume**:  
  - Pause the process after a cluster of URLs.  
  - Resume from where you left off.  

- **Sound Notifications**:  
  - Audio alerts for actions like starting, pausing, and completing the process.  

- **Exit Anytime**:  
  - Safely close the application during execution without interruptions.  

- **Standalone Executable**:  
  - Convert the script into a `.exe` file with a custom icon for convenience.  

## Usage  
1. **Input**:  
   - Provide a list of URLs in a `.txt` file.  
   - The file should have one URL per line.  

2. **Setup**:  
   - Launch the tool and adjust settings (e.g., time gap, number of URLs in a cluster).  

3. **Start**:  
   - Click the "Start" button to begin the automated process.  

4. **Pause/Resume**:  
   - Use the respective buttons to pause and resume as needed.  

5. **Change Browser**:  
   - Switch between supported browsers (Chrome/Firefox) through the GUI.  

## Requirements  
- Windows Operating System.  
- PowerShell 5.0 or higher.  

## How to Build  
To convert the script into a standalone `.exe` file:  
1. Install [PS2EXE](https://github.com/MScholtes/PS2EXE).  
2. Use the following command:  
   ```powershell
   ps2exe -inputFile your-script.ps1 -outputFile URL-Opener.exe -iconFile custom-icon.ico
