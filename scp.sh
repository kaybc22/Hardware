#!/bin/bash

for i in 172.31.35.127 172.31.48.38
do 
sshpass -p "ubuntu" scp /root/gpu_burn/bandwidthTest ubuntu@$i:/home/ubuntu/
#sshpass -p "ubuntu" ssh ubuntu@$i 'ls ' 
done

