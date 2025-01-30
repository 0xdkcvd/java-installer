# Install Java Script

This script automates the installation of Java JDK on Linux systems. It provides an option to install either Java JDK 23 or Java JDK 24.

## Features
- Detects system architecture automatically (x86_64 or ARM64)
- Installs required dependencies (wget, tar)
- Allows user selection between Java JDK 23 and Java JDK 24
- Automatically removes existing Java installations before installing the selected version
- Sets the installed Java as the system default

## Prerequisites
Ensure that your system is running a Debian-based Linux distribution (e.g., Ubuntu).

## Installation
1. Clone this repository or download the script.
   ```bash
   git clone https://github.com/0xdkcvd/java-installer
   ```
3. Navigate to the script location (optional):
   ```bash
   cd /path/to/script
   ```
4. Give execute permission:
   ```bash
   chmod +x install_java.sh
   ```
5. Run the script:
   ```bash
   ./install_java.sh
   ```
6. Follow the prompts to select the Java version to install.

## Supported Java Versions
- Java JDK 23
- Java JDK 24 (Early Access)

## Verification
After installation, verify Java by running:
```bash
java -version
```

## Notes
- This script will remove any existing OpenJDK versions before installing the selected Java version.
- The script requires `sudo` privileges to install packages and set up Java.

## License
This script is provided under the MIT License.

## Author
Developed by [https://](https://github.com/0xdkcvd)
