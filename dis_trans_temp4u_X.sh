#!/bin/bash
echo
echo "run 'mst start' and 'mst status -v' to identify and map mlx5_$i to slot enumeration"
echo "then adjust the for loop as necessary"
while true; do
	date | tee -a /home/test/logs/trans_temp.txt
        echo  "AOC Slots 1-8, 12, Inlet"
	for i in 0 2 3 4 5 6 7 8 1; do
		mlxlink -d mlx5_${i} -m | grep -i temp | tee -a /home/test/logs/trans_temp.txt
	done
		ipmitool sdr|grep -i inlet | tee -a /home/test/logs/trans_temp.txt
		echo ""
	sleep 10
done

