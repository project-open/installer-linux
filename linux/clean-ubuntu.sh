#!/usr/bin/bash
########################################################################
#
# Run this script on a Ubuntu server to remove a lot of
# clutter from the filesystem to get a smaller image for
# compression in the installer.
########################################################################


# Cleanup history files 
rm /root/.bash_history 
rm /web/projop/.bash_history 
rm /web/projop/.psql_history

# Cleanup ]po[ log files
cd /web/projop/log; rm *
# Limit the journal size
journalctl --vacuum-size=10M


# Cleanup swap file
swapoff -a
rm /swap.img
dd if=/dev/zero of=/swap.img bs=1M count=2048
mkswap /swap.img
swapon -a

# Cleanup APT files
apt clean; apt autoclean
apt install deborphan
deborphan | xargs sudo apt-get -y remove --purge
apt-get remove --purge -y software-properties-common
apt clean; apt autoclean

# Remove the Trash
rm -rf /home/*/.local/share/Trash/*/**
rm -rf /root/.local/share/Trash/*/**
# Cleanup /tmp and /var/tmp
cd /tmp; rm -f *
cd /var/tmp; rm -f *

# Remove Man
rm -rf /usr/share/man/?? 
rm -rf /usr/share/man/??_*

# Remove /var/spool
cd /var/spool
du -sk *

# Cleanup /var/log
cd /var/log; rm *
rm -rf /var/log/apt/*
rm -rf /var/log/dist-upgrade/* 
rm -rf /var/log/installer/* 
rm -rf /var/log/nginx/* 
rm -rf /var/log/postgresql/* 
rm -rf /var/log/sysstat/* 
rm -rf /var/log/unattended-upgrades/* 
systemctl restart rsyslog.service

# Erase the disk with zeros
dd if=/dev/zero of=/zero bs=1M
rm /zero

