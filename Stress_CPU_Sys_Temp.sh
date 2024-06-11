#!/bin/bash

function Stress_CPU() {
cd /opt/testing/nvqual/tools/UNIFIED_SERVER_PTU_V3.8.8_20221014/

/opt/testing/nvqual/tools/UNIFIED_SERVER_PTU_V3.8.8_20221014/ptu -ct 1 -t 4200 -log -logdir /opt/testing/nvqual/log &
/opt/testing/utls/Get_Sys_Temp.sh
}

Stress_CPU 


