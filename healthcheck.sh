#!/bin/bash
 
LOGFILE="healthlog.txt"
 
{
echo ""
echo "System date and time: $(date)"
 
# System Uptime
uptime_formatted=$(awk '{print int($1/3600)" hours "int(($1%3600)/60)" minutes"}' /proc/uptime)
echo "System Uptime: $uptime_formatted"
 
# CPU Load
echo "CPU Load (1, 5, 15 min): $(cut -d ' ' -f 1-3 /proc/loadavg)"
 
# Memory Usage
echo "Memory Usage (MB):"
total_mem=$(grep MemTotal /proc/meminfo | awk '{print $2}')
free_mem=$(grep MemAvailable /proc/meminfo | awk '{print $2}')
total_mem_mb=$((total_mem / 1024))
free_mem_mb=$((free_mem / 1024))
used_mem_mb=$((total_mem_mb - free_mem_mb))
echo "Total: ${total_mem_mb} MB"
echo "Used: ${used_mem_mb} MB"
echo "Free: ${free_mem_mb} MB"
 
# Disk Usage
echo -e "\nDisk Usage:"
df -h
 
# Top 5 Memory Consuming Processes
echo -e "\nTop 5 Memory Consuming Processes:"
wmic process get Name,WorkingSetSize | sort -k2 -n | tail -n 5
 
# Check services (Windows)
echo -e "\nService Status:"
sc query sshd > /dev/null 2>&1 && echo "SSH: Running " || echo "SSH: Not Running "
sc query nginx > /dev/null 2>&1 && echo "Nginx: Running " || echo "Nginx: Not Running "
 
echo "------"
} > "$LOGFILE"
 
 