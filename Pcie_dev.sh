#!/bin/bash

#lspci  | egrep -i "nvidia|mella|Non-Volatile|ether|micro"
#for i in $(ls /dev/ | grep -i nvme | grep -E 'nvme[0-9]+$'); do echo /dev/${i}n1; nvme id-ctrl /dev/${i}n1| grep -va subnqn | grep sn; done
#ls -l --color /dev/disk/by-path/ | grep -v '\-part' | sort -k11 | awk '{ print $9 $10 $11}'
#ls /dev/ | grep -i nvme | grep -E 'nvme[0-9]+$'

#Identify LED Control: To turn on the identify LED (usually a blinking light on the drive), use:
# sudo dd if=/dev/nvmeX of=/dev/null

declare -A serial_numbers

# Populate the array with serial numbers from the first command
while read -r device sn; do
  if [[ $device == /dev/nvme* ]]; then
    key=$(basename $device)
    serial_numbers[$key]=$sn
  fi
done < <(for i in $(ls /dev/ | grep -i nvme | grep -E 'nvme[0-9]+$'); do echo /dev/${i}n1; nvme id-ctrl /dev/${i}n1 | grep -i sn; done)

# Now read the device paths and print them with the serial numbers
ls -l --color /dev/disk/by-path/ | grep -v '\-part' | sort -k11 | awk '{ print $9 $10 $11}' | while read -r path; do
  device=$(readlink -f /dev/disk/by-path/$path)
  key=$(basename $device)
  echo "$path : ${serial_numbers[$key]}"
done
