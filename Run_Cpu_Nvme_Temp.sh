#!/bin/bash

# Run the first script in the background
/opt/testing/utls/Stress_CPU_Sys_Temp.sh &

# Run the second script in the background
/opt/testing/utls/Stress_nvme.sh 

# Wait for both scripts to finish
wait

echo "Both scripts have completed."