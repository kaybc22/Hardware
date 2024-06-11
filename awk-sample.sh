#!/bin/bash

printf "$1 is file log that...."
printf "Please choose the..."

case $option in 
  power|p)
     echo "Begin comparing power"
     cat $1 | grep  Power | awk '{ if ($4 > 70000) print $4}'
     ;;
  Temp|t)
      echo "Begin comparing temperautre"
      cat $1 | grep -i gputemp | awk '{ if ($2 > 75) print $2 }' 
      cat $1 | grep -i gputemp | awk '{if ( $2 > 85) print $2 }' | wc -l
     ;;
   7)
      echo "Begin comparing temperautre"
      cat $1 | awk -F, '{ print $3}'     #'{if ( $3 > 30) print $3 }' Test7
     ;;
   *)
      printf "Quit program!!!\n"
esac


#cat thermal_test_050724_184114_part_0.log | grep "mW" | awk '{print $9}'
#cat thermal_test_050724_184114_part_0.log | grep "mW" | awk '{ if ($9 > 700000) print $0 }' | tee >(wc -l)
#cat thermal_test_050724_184114_part_0.log | grep "TLimit" | awk '{ if ($7 > 25) print $0 }' | tee >(wc -l)

#"TLimit" 3 - 32