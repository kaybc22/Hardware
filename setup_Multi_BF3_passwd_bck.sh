#!/bin/bash

# Get the list of rshim devices
devices=$(ls /dev/ | grep -i 'rsh')

# Iterate over each device and run the expect script
for device in $devices; do
    /usr/bin/expect <<EOF
    # Your expect script here, replacing the 'expect_user' part with:
    set user_input "$device"
    set device "/dev/$user_input/console"
    set baud_rate "115200"
    set username "ubuntu"
    set password "Root1234"
    set root_access "sudo su -"
    set root_passwd "passwd"
    set set_root_passwd "Root1234"
    set command "ip a | grep -i 'oob_net'"

    # Start screen
    puts "Starting screen session on $device at baud rate $baud_rate..."
    spawn screen $device -b $baud_rate

    # Expect prompt for username
    expect "login:"
    puts "Sending username..."
    send "$username\r"

    # Expect prompt for password
    expect "Password:"
    puts "Sending password..."
    send "$password\r"

    # Wait for command prompt
    expect "$ "
    puts "Gaining root access..."
    send "$root_access\r"

    # Wait for command output
    expect "# "
    puts "Changing root password..."
    send "$root_passwd\r"

    # Wait for command output
    expect "New password: "
    send "$set_root_passwd\r"

    # Wait for command output
    expect "Retype new password: "
    send "$set_root_passwd\r"

    # Wait for command output
    expect "# "
    puts "Root password changed successfully."

    # Exit screen
    puts "Exiting screen session..."
    send "\x01:" ; # Sends Ctrl-A and :
    send "quit\r"

    # Wait for screen to exit
    expect eof
    puts "Set up ubuntu/Root1234 root/Root1234 completed."

EOF
done

for i in $(screen -ls | grep -i ubuntu | awk '{print $1}'); do screen -X -S $i  quit; done