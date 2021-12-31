#! /bin/bash

# Define VM network adapter
dev=eno16777736

# Get initial Rx/Tx values
read rx < "/sys/class/net/$dev/statistics/rx_bytes"
read tx < "/sys/class/net/$dev/statistics/tx_bytes"


while sleep 1
do	

	# Network Utilization
	read rx_update < "/sys/class/net/$dev/statistics/rx_bytes"
	read tx_update < "/sys/class/net/$dev/statistics/tx_bytes"
	
	rx_kb=$(((rx_update - rx) / 125))
	tx_kb=$(((tx_update - tx) / 125))
	
	echo Network Utilization\: Rx $rx_kb kbit\/s \| Tx $tx_kb kbit\/s

	rx=$rx_update
	tx=$tx_update
	
	# Disk Access Rate
	kb_read=$(iostat sda | tail -n 2 | awk '{ print $3 }')
	kb_write=$(iostat sda | tail -n 2 | awk '{ print $4 }')

	echo Disk Access Rate\: Read $kb_read kb\/s \| Write $kb_write kb\/s
	
	# Disk Utilization
	disk_used=$(df -h | sed -n '2p' | awk '{ print $3 }')
	disk_free=$(df -h | sed -n '2p' | awk '{ print $4 }')
	
	echo Disk Utilization\: Used $disk_used \| Free $disk_free 
	
	# Blank line for formatting
	echo 
	
done
