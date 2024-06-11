#!/bin/bash

function Check_BF3_mode() {
    echo "Running Function 1"
    /opt/testing/utls/Check_BF3_mode.sh
}

function run_bf3_30m() {
/opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/network_diag_ubuntu2204 -j /opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/8U_8DPU_thermal_30m.json -o /opt/testing/nvqual/Network_NVQual_2.6.0-1/
}

function run_bf3_NIC_30m() {
/opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/network_diag_ubuntu2204 -j /opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/8U_thermal_8DPU_30m.json -o /opt/testing/nvqual/Network_NVQual_2.6.0-1/
}

function run_GPU_BF3() {
cd /opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/
/opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/network_diag_ubuntu2204 -j /opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/8U_thermal_8DPU_30m.json -o /opt/testing/nvqual/Network_NVQual_2.6.0-1/ &
/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 1
}

function No_Bus_ID() {
#No Bus ID
     for i in $(mst status -v | awk '/BlueField3|ConnectX7/ {print$2 ":" $3}'); do
     # echo $i
     echo "$i ${i#*:}"
     #sudo mlxlink -d $i | egrep "State|Recommendation"
     sudo mlxlink -d "${i%%:*}" | egrep "State|Recommendation"
     done
}


function With_Bus_ID() {
#List of devices
   devices=("BlueField3" "ConnectX7")
   for device_id in "${devices[@]}"; do
          devices_info=$(mst status -v | awk '/'"$device_id"'/ {print $2, $3}')
          List_devices=$(mst status -v | awk '/'"$device_id"'/ {print $2}') 
          devices_state=$(sudo mlxlink -d "$List_devices" | egrep -o "State|Recommendation")
          echo  "Device Info: $devices_info"
          echo  $devices_state
  done
}


#the test 2 run after network stop - expect the test 2 run after test1 stop
function nvqual_host_ori() {
/opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/network_diag_ubuntu2204 -j /opt/testing/nvqual/Network_NVQual_2.6.0-1/executables/config4u_thermal_X.json -o /opt/testing/nvqual/Network_NVQual_2.6.0-1/ &
#PID_TEST_1=$!
/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 1 
PID_TEST_2=$!
wait $PID_TEST_2
/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 2 --index all –-loops 1 &
PID_TEST_3=$!
wait $PID_TEST_2
wait $PID_TEST_3
/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 3 --index all –-loops 1
sleep 10
/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 9 --index all –-loops 1

#/opt/testing/nvqual/NVQual_HGX_H100_and_H200_8-GPU_QS_PS_MP_x86_v05/nvqual --test 7 --loops 1 
}

# Display menu
while true; do
    echo -e "\033[31mNoted: Please run -mst start- to Loading MST PCI module...\033[0m"
    echo "Select an option:"
    echo -e "\033[33m1. Check BF3 Mode...\033[0m"
    echo -e "\033[33m2. run NVqual for BF3 in DPU mode for 30m\033[0m"
    echo -e "\033[33m3. run NVqual for BF3 in NIC mode for 30m\033[0m"
    echo -e "\033[33m4. Run thermal test for BF3 and GPU\033[0m"
    echo -e "\033[33m5. Check the NIC cable\033[0m"
    echo "6. Exit"

    # Read user input
    read -p "Enter your choice: " choice

    # Execute the selected function
    case $choice in
        1) Check_BF3_mode ;;
        2) run_bf3_30m ;;
        3) run_bf3_NIC_30m ;;
        4) run_GPU_BF3 ;;
        5) No_Bus_ID ;;
        6) echo "Exiting..." ; break ;;
        *) echo "Invalid choice. Please select a valid option." ;;
    esac
done




#echo -e "\033[35m4. Run thermal test for BF3 and GPU\033[0m"
