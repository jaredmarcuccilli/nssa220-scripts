#!/bin/bash

# NSSA-221-01 Mini Project 1
# Jared Marcuccilli & Michael Vasile

time=0

# Define VM network adapter
dev=eno16777736

# Get initial Rx/Tx values
read rx < "/sys/class/net/$dev/statistics/rx_bytes"
read tx < "/sys/class/net/$dev/statistics/tx_bytes"

# Spawn each APM
spawn(){
	./APM1 $1 2>/dev/null & p1=$! 
	./APM2 $1 2>/dev/null & p2=$!
	./APM3 $1 2>/dev/null & p3=$!
	./APM4 $1 2>/dev/null & p4=$!
	./APM5 $1 2>/dev/null & p5=$!
	./APM6 $1 2>/dev/null & p6=$!
	echo "APM1 PID: $p1"
	echo "APM2 PID: $p2"
	echo "APM3 PID: $p3"
	echo "APM4 PID: $p4"
	echo "APM5 PID: $p5"
	echo "APM6 PID: $p6"
}

# Kill processes on exit
cleanup(){
	echo "Cleaning up..."
	kill $p1
	kill $p2
	kill $p3
	kill $p4
	kill $p5
	kill $p6
}

# Monitor process-level metrics
process(){
	if [[ $(($time % 5)) == 0 ]]
	then
		echo -e "      %CPU %MEM"
	
		# Get process CPU and Memory usage
		# Print then redirect to file
		process1cpu=$(ps -p $p1 -o %cpu | tail -n +2)
		process1mem=$(ps -p $p1 -o %mem | tail -n +2)
		echo "APM1: $process1cpu $process1mem"
		echo "$time, $process1cpu, $process1mem" >> APM1_metrics.csv

		process2cpu=$(ps -p $p2 -o %cpu | tail -n +2)
		process2mem=$(ps -p $p2 -o %mem | tail -n +2)
		echo "APM2: $process2cpu $process2mem"
		echo "$time, $process2cpu, $process2mem" >> APM2_metrics.csv

		process3cpu=$(ps -p $p3 -o %cpu | tail -n +2)
		process3mem=$(ps -p $p3 -o %mem | tail -n +2)
		echo "APM3: $process3cpu $process3mem"
		echo "$time, $process3cpu, $process3mem" >> APM3_metrics.csv

		process4cpu=$(ps -p $p4 -o %cpu | tail -n +2)
		process4mem=$(ps -p $p4 -o %mem | tail -n +2)
		echo "APM4: $process4cpu $process4mem"
		echo "$time, $process4cpu, $process4mem" >> APM4_metrics.csv

		process5cpu=$(ps -p $p5 -o %cpu | tail -n +2)
		process5mem=$(ps -p $p5 -o %mem | tail -n +2)
		echo "APM5: $process5cpu $process5mem"
		echo "$time, $process5cpu, $process5mem" >> APM5_metrics.csv

		process6cpu=$(ps -p $p6 -o %cpu | tail -n +2)
		process6mem=$(ps -p $p6 -o %mem | tail -n +2)
		echo "APM6: $process6cpu $process6mem"
		echo "$time, $process6cpu, $process6mem" >> APM6_metrics.csv
	fi	
}

# Monitor system-level metrics
system(){
	# Network Utilization
	read rx_update < "/sys/class/net/$dev/statistics/rx_bytes"
	read tx_update < "/sys/class/net/$dev/statistics/tx_bytes"
	
	rx_kb=$(((rx_update - rx) / 125))
	tx_kb=$(((tx_update - tx) / 125))

	rx=$rx_update
	tx=$tx_update
	
	# Disk Access Rate
	kb_read=$(iostat sda | tail -n 2 | awk '{ print $3 }')
	kb_write=$(iostat sda | tail -n 2 | awk '{ print $4 }')

	
	
	# Disk Utilization
	disk_used=$(df -m | sed -n '2p' | awk '{ print $3 }')
	disk_free=$(df -m | sed -n '2p' | awk '{ print $4 }')

	if [[ $(($time % 5)) == 0 ]]
	then
		# Print & Redirect to file
		echo Network Utilization\: Rx $rx_kb kbit\/s \| Tx $tx_kb kbit\/s
		echo Disk Access Rate\: Read $kb_read KB\/s \| Write $kb_write KB\/s
		echo Disk Utilization\: Used $disk_used MB \| Free $disk_free MB
		echo
		echo "$time, $rx_kb, $tx_kb, $kb_write, $disk_free" >> system_metrics.csv
	fi
}

ip=$(ip route get 1 | awk '{ print $3 }' | xargs)
echo "IP: $ip"

spawn "$ip"

# Loop for 900 seconds
while [ $time -lt 900 ]
do
	process
	system
	sleep 1
	time=$((time + 1))
done

trap cleanup EXIT
