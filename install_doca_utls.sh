#!/bin/bash

function Install_utls() {
#read -p "Enter path to Doca-repo(doca-host-repo-ubuntu2204_2.6.0-xxx.deb): " path_to_doca
#sudo dpkg -i "$path_to_doca"
sudo dpkg -i /opt/testing/utls/tools/doca-host-repo-ubuntu2204_2.6.0-0.0.1.2.6.0058.1.24.01.0.3.3.1_amd64.deb
#update and install other Utls
sudo apt-get update
sudo apt install -y doca-ofed mlnx-fw-updater python3-paramiko python3-prettytable python3-matplotlib pv
sleep 1

sudo apt install -y make gcc sshpass numactl ipmitool net-tools unzip dos2unix expect
sudo apt-get remove openvswitch-common=2.17.9-0ubuntu0.22.04.1
sleep 1

sudo apt-get update
sudo apt-get install openvswitch-common=2.17.8-1
sudo apt-get install openvswitch-switch=2.17.8-1
sleep 1

sudo apt install -y doca-networking doca-runtime doca-extra doca-sdk doca-tools 

systemctl status rshim
}


function Install_doca() {
read -p "Please input the path to Doca image (/opt/testing/utls/tools/bf-bundle-2.7.0-33_24.04_ubuntu-22.04_prod.bfb:) " path_to_image
#/opt/testing/utls/tools/bf-bundle-2.7.0-33_24.04_ubuntu-22.04_prod.bfb
/opt/testing/utls/tools/multi-bfb-install --bfb "$path_to_image" --password Root1234
}

function Setup_BF_root_passwd() {
    echo "timeout is 60 second..."
    /opt/testing/utls/setup_BF_root_passwd.sh
}

function Setup_Multi_BF3_passwd() {
    echo "timeout is 60 second..."
    /opt/testing/utls/Setup_Multi_BF3_passwd.sh
}


function Get_BF3_iP() {
    /opt/testing/utls/Get_BF3_Ip.sh
}

# Display menu
while true; do
    echo "Select an option:"
    echo -e "\033[33m1. Install All Utls\033[0m"
    echo "2. Load Doca Frame Work to BF-3"
    echo "3. Setup BF root passwd"
    echo -e "\033[33m4. setup Multi BF root passwd\033[0m"
    echo "5. Get BF3 OOB IP"
    echo "6. Exit"

    # Read user input
    read -p "Enter your choice: " choice

    # Execute the selected function
    case $choice in
        1) Install_utls ;;
        2) Install_doca;;
        3) Setup_BF_root_passwd;;
        4) Setup_Multi_BF3_passwd;;
        5) Get_BF3_iP;;
        6) echo "Exiting..." ; break ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done