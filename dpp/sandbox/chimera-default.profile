# File: /etc/firejail/chimera-default.profile

include /etc/firejail/disable-common.inc
include /etc/firejail/disable-passwdmgr.inc
include /etc/firejail/whitelist-common.inc

private
net none
nogroups
noroot
nonewprivs

read-only ${HOME}/Documents
read-only ${HOME}/Pictures
blacklist ${HOME}/Downloads
blacklist /mnt
blacklist /media

caps.drop all
seccomp
