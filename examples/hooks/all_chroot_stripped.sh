#!/bin/sh

## live-build(7) - System Build Scripts
## Copyright (C) 2006-2012 Daniel Baumann <daniel@debian.org>
##
## live-build comes with ABSOLUTELY NO WARRANTY; for details see COPYING.
## This is free software, and you are welcome to redistribute it
## under certain conditions; see COPYING for details.


set -e

# WARNING: Using this hook will result in a stripped system, means,
# it may very well be possible that other packages are depending
# on certain files that get removed here.
# Therefore, this hooks is merely an inspiration for what could be
# removed and not a generic nor recommendet solution to get the
# image filesize down. In any event, using this hook can lead to
# unforseen bugs and breakages in other packages and you should
# be prepared to find and fix it for your own images.

# Removing unused packages
for PACKAGE in apt-utils aptitude man-db manpages info wget dselect
do
	if ! apt-get remove --purge --yes "${PACKAGE}"
	then
		echo "WARNING: ${PACKAGE} isn't installed"
	fi
done

apt-get autoremove --yes || true

# Removing unused files
find . -name *~ | xargs rm -f

rm -rf /usr/include/*
#rm -rf /usr/share/groff/*
rm -rf /usr/share/doc/*
rm -rf /usr/share/locale/*
rm -rf /usr/share/man/*
rm -rf /usr/share/i18n/*
rm -rf /usr/share/info/*
rm -rf /usr/share/lintian/*
rm -rf /usr/share/linda/*
rm -rf /usr/share/zoneinfo/*
rm -rf /var/cache/man/*

# Truncating logs
for FILE in $(find /var/log/ -type f)
do
	: > ${FILE}
done
