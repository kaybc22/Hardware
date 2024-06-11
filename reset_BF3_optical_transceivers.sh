#!/bin/bash
echo
echo "run 'mst start' and 'mst status -v' to identify and map mlx5_$i to slot enumeration for specifivity"
echo "or just identify maximum mlx5_$i enumeration and adjust the seq parameter to run on all optical transceivers"
for i in $(seq 0 13); do
	echo mlx5_$i
	mlxreg -d mlx5_$i --set "admin_status=0xe,ase=1" --reg_name PMAOS --index "module=0,slot_index=0" -y
	sleep 3s
	mlxreg -d mlx5_$i --set "admin_status=0x1,ase=1" --reg_name PMAOS --index "module=0,slot_index=0" -y
	sleep 3s
	#it takes more than 3s for the transceiver to come up
	#mlxlink -d mlx5_$i -m | grep -i temp
	echo
done
echo "wait 15-30 seconds and then check if optical transceiver reset was successful using the display temp script"
