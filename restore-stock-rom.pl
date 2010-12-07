#!/usr/bin/perl

use strict;
use Cwd;

my $adb = "/usr/local/android-sdk-linux_x86/tools/adb";
my $command;
my $error_flag = 0;
my $error_text = "[ERROR]";
my $heimdall = "/usr/local/bin/heimdall";
my $whoami = `whoami`; chomp($whoami);
my $root = getcwd;
my ($parameter, $filename);
my @output;
my %options = ("factoryfs", "$root/factoryfs.rfs",
		"cache", "$root/cache.rfs",
		"dbdata", "$root/dbdata.rfs",
		#"boot", "$root/boot.bin",
		#"secondary", $root/sbl.bin",
		#"param", "$root/param.lfs",
		"kernel", "$root/zImage-ji6-2e",
		"modem", "$root/modem.bin"); 

# We must be root
my($name, $pass, $uid, $gid, $quota, $comment, $gcos, $dir, $shell, $expire) = getpwnam("$whoami");
if ($uid != 0) {
	print "$error_text You must be root to run this utility.\n";
	exit 254;
}

# Verify adb exists
if (!-e "$adb") {
	print "$error_text Cannot find adb.\n";
	exit 254;
}

# Verify heimdall exists
if (!-e "$heimdall") {
	print "$error_text Cannot find heimdall.\n";
	exit 254;
}

# Verify all files exist
while (($parameter, $filename) = each(%options)) {
	printf "Checking $filename.... ";
	if (-e "$filename") {
		printf "OK\n";
	} else {
		printf "Failed\n";
		$error_flag = 1;
	}
}

if ($error_flag > 0) {
	print "$error_text One or more files could not be found.\n";
	exit 254;
} else {
	# I won't touch boot.bin, sbl.bin, or param.lfs now. Dangerous.
	#$command = "$heimdall flash --factoryfs $options{factoryfs} --cache $options{cache} --dbdata $options{dbdata} --boot $options{boot} --secondary $options{secondary} --param $options{param} --kernel $options{kernel} --modem $options{modem}";
	$command = "$heimdall flash --factoryfs $options{factoryfs} --cache $options{cache} --dbdata $options{dbdata} --kernel $options{kernel} --modem $options{modem}";
}

# Start the adb server if necessary
printf "Checking the adb server... ";
system("pidof adb > /dev/null 2>&1");
if ($? == 0) {
	printf "OK\n";
} else {
	system("$adb start-server > /dev/null 2>&1");
	if ($? > 0) {
		print "Failed\n";
		exit 254;
	}
}

printf "$command\n";exit;

# Put the device into download mode
printf "Attempting to put the device into download mode... ";
system("$adb reboot download  > /dev/null 2>&1");
if ($? == 0) {
	printf "OK\n";
	sleep(5);
} else {
	print "Failed\n";
	exit 254;
}

# Flash the stock ROM
printf "Attempting to flash the stock ROM to device...\n";
system("$command");
