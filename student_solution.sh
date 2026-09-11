#!/bin/bash

# SELinux Access Denial Practical
# Student Name:
# Register Number:

echo "===== SELinux Status ====="
sestatus
getenforce

echo "===== Creating Web Directory ====="
mkdir -p /var/www/html/testdir
echo "===== Creating HTML File ====="
echo "<h1>SELinux Test Page</h1>" > /var/www/html/testdir/index.html

echo "===== Setting Linux Permissions ====="
chmod 755 /var/www/html/testdir
chmod 644 /var/www/html/testdir/index.html

echo "===== Checking Initial Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Assigning Wrong SELinux Context ====="
chcon -t user_home_t /var/www/html/testdir/index.html
echo "===== Checking Wrong Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Checking AVC Denials ====="
# Attempting to access file to generate an AVC denial entry
curl http://localhost/testdir/index.html 2>/dev/null
ausearch -m avc -ts recent 2>/dev/null || grep "avc:  denied" /var/log/audit/audit.log | tail -n 5
echo "===== Correcting SELinux Context ====="
restorecon -v /var/www/html/testdir/index.html

echo "===== Checking Correct Context ====="
ls -Z /var/www/html/testdir/index.html

echo "===== Practical Completed ====="
