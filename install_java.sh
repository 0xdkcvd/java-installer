#!/bin/bash

# Set variables
arch=$(uname -m)
getPwd=${PWD}

if [ $arch == "x86_64" ]; then
  arch=x64
fi

# Install required packages
command -v wget >/dev/null 2>&1 || { echo >&2 "Wget is not found on this machine, Installing wget ... "; sudo apt install -y wget;}
command -v tar >/dev/null 2>&1 || { echo >&2 "Tar is not found on this machine, Installing tar ... "; sudo apt install -y tar;}

# Java versions list
javaList=(
  "https://download.oracle.com/java/23/latest/jdk-23_linux-${arch}_bin.tar.gz"
  "https://download.java.net/java/early_access/jdk24/27/GPL/openjdk-24-ea+27_linux-${arch}_bin.tar.gz"
)

jdkList=("jdk-23.0.2" "jdk-24")

# Function to install the latest JDK
function install_java() {
  echo "List Supported Java Version: "
  echo "1. Java JDK 23"
  echo "2. Java JDK 24"

  read -p "Choose Java version (1 or 2): " cJava

  until [[ "$cJava" == "1" || "$cJava" == "2" ]]; do
    echo "Invalid option. Please select 1 or 2."
    read -p "Choose Java version (1 or 2): " cJava
  done

  if [[ "$cJava" == "1" ]]; then
    javaVer=${javaList[0]}
    jdkVer=${jdkList[0]}
  elif [[ "$cJava" == "2" ]]; then
    javaVer=${javaList[1]}
    jdkVer=${jdkList[1]}
  fi

  # Remove existing Java installations
  sudo apt-get purge -y openjdk* && sudo apt-get autoremove -y
  sudo rm -rf /usr/lib/jvm/*

  # Download and install the selected Java version
  echo "Downloading Java ${jdkVer}..."
  wget -O javalts.tar.gz ${javaVer}

  # Create directory and extract the tarball
  sudo mkdir /usr/local/java
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
