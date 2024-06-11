#!/bin/bash

function Monitor_System(){
  #DATE=$(date +%Y%m%d%H%M)
  echo -e "\e[32m$(date)\e[0m" >> /opt/testing/nvqual/log/sys_$DATE.log
  echo "......System Temperature......." >> /opt/testing/nvqual/log/sys_$DATE.log
  ipmitool sdr | egrep -i "fan|inlet|aoc" >> /opt/testing/nvqual/log/sys_$DATE.log
  echo "......Power Reading......." >> /opt/testing/nvqual/log/sys_$DATE.log
  ipmitool dcmi power reading | grep power >> /opt/testing/nvqual/log/sys_$DATE.log
}

#DATE=$(date +%Y%m%d%H%M)
#echo "/dev/mst/mt41692_pciconf0" && mlxlink -d /dev/mst/mt41692_pciconf0 -m -c | egrep -i "MAX Power|Temperature|State|Recommendation"
function Monitor_BF3() {
#No Bus ID
     for i in $(mst status -v | awk '/BlueField3|ConnectX7/ {print$2 ":" $3}'); do
     # echo $i
     # echo "$i ${i#*:}"
     #DATE=$(date +%Y%m%d%H%M)
     #date >> /opt/testing/nvqual/test.log
     echo $i >> /opt/testing/nvqual/log/sys_$DATE.log
     #sudo mlxlink -d $i | egrep "State|Recommendation"
     sudo mlxlink -d "${i%%:*}" -m -c 2>/dev/null | egrep -i "MAX Power|Temperature|State|Recommendation" >> /opt/testing/nvqual/log/sys_$DATE.log
     done
}


function time_stop_after(){
SECONDS=0
DURATION=$((120*60)) # 120 minutes converted to seconds
while true; do
  if [ $SECONDS -ge $DURATION ]; then
    echo "Exiting the loop."
    break
  fi
  Monitor_System
  Monitor_BF3
  sleep 10
done
}

function time_stop(){
stop_time="24:59"
while true; do
  #echo -e "\033[1;33m$(date)\033[0m" >> /opt/testing/nvqual/sys.log
  date >> /opt/testing/nvqual/sys.log
  echo "......System Temperature......." >> /opt/testing/nvqual/sys.log
  ipmitool sdr | egrep -i "fan|inlet|aoc" >> /opt/testing/nvqual/sys.log
  echo "......Power Reading......." >> /opt/testing/nvqual/sys.log
  ipmitool dcmi power reading | grep power >> /opt/testing/nvqual/sys.log
  sleep 10

  # Check if the current time is greater or equal to the stop time
  current_time=$(date +%H:%M)
  if [[ "$current_time" > "$stop_time" ]]; then
    echo "It's time to stop the loop."
    break
  fi
done
}

DATE=$(date +%Y%m%d%H%M)
time_stop_after
