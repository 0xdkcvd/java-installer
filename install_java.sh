#!/bin/bash

# Set variables
arch=$(uname -m)
getPwd=${PWD}

if [ "$arch" == "x86_64" ]; then
  arch=x64
fi

# Install required packages
command -v wget >/dev/null 2>&1 || { echo >&2 "Wget is not found on this machine, Installing wget ... "; sudo apt install -y wget;}
command -v tar >/dev/null 2>&1 || { echo >&2 "Tar is not found on this machine, Installing tar ... "; sudo apt install -y tar;}

# Java versions list
javaList=(
  "https://download.oracle.com/java/19/archive/jdk-19_linux-${arch}_bin.tar.gz"
  "https://download.oracle.com/java/20/archive/jdk-20_linux-${arch}_bin.tar.gz"
  "https://download.oracle.com/java/21/archive/jdk-21_linux-${arch}_bin.tar.gz"
  "https://download.oracle.com/java/22/archive/jdk-22_linux-${arch}_bin.tar.gz"
  "https://download.oracle.com/java/23/archive/jdk-23_linux-${arch}_bin.tar.gz"
  "https://download.java.net/java/early_access/jdk24/27/GPL/openjdk-24-ea+27_linux-${arch}_bin.tar.gz"
)

jdkList=("jdk-19" "jdk-20" "jdk-21" "jdk-22" "jdk-23" "jdk-24")

# Function to check if Java is installed
function check_java_installed() {
  if command -v java &> /dev/null; then
    java -version | grep -oP 'java version "\K[^"]+' | head -n 1
  else
    echo "Java tidak terdeteksi di sistem Anda"
  fi
}

# Function to uninstall Java
function uninstall_java() {
  if command -v java &> /dev/null; then
    sudo apt-get purge -y openjdk*
    sudo apt-get autoremove -y
    sudo rm -rf /usr/lib/jvm/*
    sudo rm -rf /usr/local/java
    echo "Java telah dihapus dari sistem Anda"
  else
    echo "Java tidak terinstal di sistem Anda"
  fi
}

# Function to install the latest JDK
function install_java() {
  echo "Versi Java yang terinstal saat ini: "
  check_java_installed
  
  read -p "Apakah Anda ingin menghapus versi Java yang ada? (y/n): " uninstallOpt
  if [[ "$uninstallOpt" == "y" ]]; then
    uninstall_java
  fi

  echo "List Supported Java Version: "
  for ((i=0; i<${#jdkList[@]}; i++)); do
    echo "$((i+1)). Java JDK ${jdkList[i]}"
  done

  read -p "Choose Java version (1 to ${#jdkList[@]}): " cJava

  until [[ "$cJava" =~ ^[0-9]+$ ]] && [ "$cJava" -ge 1 ] && [ "$cJava" -le ${#jdkList[@]} ]; do
    echo "Invalid option. Please select a number between 1 and ${#jdkList[@]}."
    read -p "Choose Java version (1 to ${#jdkList[@]}): " cJava
  done

  javaVer=${javaList[cJava-1]}
  jdkVer=${jdkList[cJava-1]}

  # Download and install the selected Java version
  echo "Downloading Java ${jdkVer}..."
  wget -O javalts.tar.gz ${javaVer}

  # Create directory and extract the tarball
  sudo mkdir -p /usr/local/java
  sudo mv javalts.tar.gz /usr/local/java
  cd /usr/local/java
  sudo tar zxvf javalts.tar.gz
  sudo rm -rf javalts.tar.gz

  # Set alternatives for Java
  sudo update-alternatives --install "/usr/bin/java" "java" "/usr/local/java/${jdkVer}/bin/java" 1

  # Verify installation
  java -version
  echo "Java ${jdkVer} has been installed successfully!"
}

# Run the installation
install_java
