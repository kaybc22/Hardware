#cat $1 | grep  Power | awk '{ if ($4 > 70000) print $4}'
#cat $1 | grep -i gputemp | awk '{ if ($2 > 75) print $2 }' 
#cat $1 | grep -i gputemp | awk '{if ( $2 > 85) print $2 }' | wc -l
#cat $1 | awk -F, '{ print $3}'     #'{if ( $3 > 30) print $3 }' Test7

cat $1 | grep -v N/A | grep -i current | awk '{ if ($5 > 80) print $5}'  #check temp PXe
