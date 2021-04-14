#!/usr/bin/perl
#==============================
# Tool Name: Resource Monitor
#==============================
# Background: samples usage of CPU, Disk, and Memory in Solaris
#==============================
# Date			Name			Description
# 15Apr2021		Jon Marco Reyes	INITIAL VERSION

$date = `date +"%Y%B%d_%H%M%S"`;
chomp $date;
open (OUTPUT, ">report_$date.log");
print OUTPUT "$date\n";
# CPU Report via sar
print OUTPUT "CPU Report\n";
$sar_result = `sar 1 | tail -1`;
my ($time, $usr, $sys, $wio, $idle) = split(' ', $sar_result);
$cpu_percent_usage = 100 - $idle;

print "time: $time\n";
print OUTPUT "CPU \% usage: $cpu_percent_usage\n";

#Disk Report via df
print OUTPUT "\n\nDisk Report\n";
@volumes = ("rpool", "swap", "fd");
for(@volumes) {
	$df = `df -k $_ | tail -1`;
	print OUTPUT $df;
}

#Free Memory Usage Report via vmstat
print OUTPUT "\n\nMemory Report\n";
$memory_result = `vmstat | tail -1 `;
($r,$b,$w,$swap,$free,$others) = split (' ', $memory_result);
print $memory_result;
print OUTPUT "Free Memory: $free\n";

#Memory Usage via prstat
$prstat_result = `prstat -Z 1 1 | grep global`;
($ZONEID, $NPROC, $SWAP, $RSS, $MEMORY, $TIME, $CPU, $ZONE) = split (" ", $prstat_result);
print OUTPUT "Memory Usage: $MEMORY\n";