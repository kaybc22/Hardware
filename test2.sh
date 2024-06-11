#!/bin/bash

# Get the list of rshim devices
devices=$(ls /dev/ | grep -i 'rsh')

# Iterate over each device and run the expect script
for device in $devices; do
/usr/bin/expect <<EOF
set user_input "$device"
set device "/dev/$user_input/console"
set baud_rate "115200"
set username "ubuntu"
set password "Root1234"
set root_access "sudo su -"
set root_passwd "passwd"
set set_root_passwd "Root1234"
set command "ip a | grep -i 'oob_net'"

puts "Starting screen session on \$device at baud rate \$baud_rate..."
spawn screen \$device -b \$baud_rate

expect {
    "login:" {
        send "\$username\r"
        exp_continue
    }
    "Password:" {
        send "\$password\r"
        exp_continue
    }
    "\$ " {
        send "\$root_access\r"
        exp_continue
    }
    "password for \$username:" {
        send "\$root_passwd\r"
        exp_continue
    }
    "root@" {
        send "\$command\r"
        exp_continue
    }
}
EOF
done
