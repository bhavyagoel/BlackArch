#
# Regular cron jobs for the core-utils package
#
0 4	* * *	root	[ -x /usr/bin/core-utils_maintenance ] && /usr/bin/core-utils_maintenance
