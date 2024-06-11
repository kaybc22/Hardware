
free -h

lsblk

ls -l --color /dev/disk/by-path/ | grep -v '\-part' | sort -k11
for i in $(ls -i /dev/nvm*); do smartctl -i $i | egrep -i "serial|model"; done

dmidecode 