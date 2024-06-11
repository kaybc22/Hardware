#!/usr/bin/bash

function Check_BF3_mode() {
for i in $(mst status -v | awk '/BlueField3/ {print$2}' | grep -v '\.1$')
do mlxconfig -d $i -e q INTERNAL_CPU_OFFLOAD_ENGINE INTERNAL_CPU_MODEL
done
}

function DPU_mode() {
for i in $(mst status -v | awk '/BlueField3/ {print$2}' | grep -v '\.1$')
do echo "y" | mlxconfig -d $i s INTERNAL_CPU_OFFLOAD_ENGINE=0
done
}

function NIC_mode() {
for i in $(mst status -v | awk '/BlueField3/ {print$2}' | grep -v '\.1$')
do echo "y" | mlxconfig -d $i s INTERNAL_CPU_OFFLOAD_ENGINE=1
done
}

function IB_mode() {
for i in $(mst status -v | awk '/BlueField3/ {print$2}' | grep -v '\.1$')
do echo "y" | mlxconfig -d $i s LINK_TYPE_P1=1
done
}

function ETH_mode() {
for i in $(mst status -v | awk '/BlueField3/ {print$2}' | grep -v '\.1$')
do echo "y" | mlxconfig -d $i s LINK_TYPE_P1=2
done
}


while true; do
    echo "Select an option:"
    echo -e "\033[33m1. Check BF3 Mode...\033[0m"
    echo "2. Change to DPU mode"
    echo "3. Change to NIC mode"
    echo -e "\033[33m4. Change Link Layer to IB mode\033[0m"
    echo "5. Change Link Layer to ETH mode"
    echo "6. Exit"

    # Read user input
    read -p "Enter your choice: " choice

    # Execute the selected function
    case $choice in
        1) Check_BF3_mode ;;
        2) DPU_mode ;;
        3) NIC_mode ;;
        4) IB_mode ;;
        5) ETH_mode ;;
        6) echo "Exiting..." ;  break ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done		