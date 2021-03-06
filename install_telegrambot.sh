#!/bin/bash

#############################################################################
# Version 0.8.4-ALPHA (24-11-2018)
#############################################################################

#############################################################################
# Copyright 2018 Sebas Veeke. Licenced under a Creative Commons Attribution-
# NonCommercial-ShareAlike 4.0 International License.
#
# See https://creativecommons.org/licenses/by-nc-sa/4.0/
#
# Contact:
# > e-mail      mail@sebasveeke.nl
# > GitHub      sveeke
#############################################################################

#############################################################################
# TELEGRAM VARIABLES
#############################################################################

# During normal installation, only one pair of token and chat ID will be
# asked and used. If you want to use multiple Telegram Bots for the
# different roles, add the tokens and chat IDs in the below variables.
# Please note that you have to set them *all* (even the ones you don't use)
# for them to work.

# General settings
AUTO_UPGRADE='no' # Default 'no'

# Metrics function
METRICS_ENABLED='yes' # Default 'yes'
METRICS_TOKEN='token'
METRICS_CHAT='id'

# Alert function
ALERT_ENABLED='yes' # Default 'yes'
ALERT_TOKEN='token'
ALERT_CHAT='id'

# Updates function
UPDATES_ENABLED='yes' # Default 'yes'
UPDATES_TOKEN='token'
UPDATES_CHAT='id'

# Login function
LOGIN_ENABLED='no' # Default 'no'
LOGIN_TOKEN='token'
LOGIN_CHAT='id'

# Outage function
OUTAGE_ENABLED='no' # Default 'no'
OUTAGE_TOKEN='token'
OUTAGE_CHAT='id'

#############################################################################
# INTRODUCTION
#############################################################################

echo
echo
echo
echo '   _______   _                                _           _   '
echo '  |__   __| | |    Created by Sebas Veeke    | |         | |  '
echo '     | | ___| | ___  __ _ _ __ __ _ _ __ ___ | |__   ___ | |_ '
echo '     | |/ _ \ |/ _ \/ _` |  __/ _` |  _ ` _ \|  _ \ / _ \| __|'
echo '     | |  __/ |  __/ (_| | | | (_| | | | | | | |_) | (_) | |_ '
echo '     |_|\___|_|\___|\__, |_|  \__,_|_| |_| |_|_.__/ \___/ \__|'
echo '                     __/ |                                    '
echo '                    |___/                                     '
echo
echo '  This script will install telegrambot on your server. You need'
echo '  the Telegram access token and chat ID during the installation.'
echo
echo '  Press ctrl + c during the installation to abort.'

sleep 3

#############################################################################
# CHECKING REQUIREMENTS
#############################################################################

echo
echo
echo "*** CHECKING REQUIREMENTS ***"

# Checking whether the script runs as root
echo -n "[?] Script is running as root..."
if [ "$EUID" -ne 0 ]; then
    echo -e "\\t\\t\\t\\t[NO]"
    echo
    echo "********************************************"
	echo "This script should run with root privileges."
	echo "********************************************"
    echo
	exit 1
fi
echo -e "\\t\\t\\t\\t[YES]"

# Checking whether supported operating system is installed
echo -n "[?] OS is supported..."
# Source /etc/os-release to use variables
if [ -f /etc/os-release ]; then
    . /etc/os-release

    # Put distro name and version in variables
    OPERATING_SYSTEM="$NAME"
    OPERATING_SYSTEM_VERSION="$VERSION_ID"

    # Check all supported combinations of OS and version
    if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 7" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 8" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 27" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 28" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 29" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 8" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 9" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 10" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 14.04" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 16.04" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.04" ] || \
    [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.10" ]; then
        echo -e "\\t\\t\\t\\t\\t\\t[YES]"

    else
        echo -e "\\t\\t\\t\\t\\t\\t[NO]"
        echo
        echo "***************************************"
        echo "This operating system is not supported."
        echo "***************************************"
        echo
        exit 1
    fi

else
    echo -e "\\t\\t\\t\\t\\t\\t[NO]"
    echo
    echo "***************************************"
    echo "This operating system is not supported."
    echo "***************************************"
    echo
    exit 1
fi

# Checking internet connection
echo -n "[?] Connected to the internet..."
if ping -q -c 1 -W 1 google.com >/dev/null; then
    echo -e "\\t\\t\\t\\t[YES]"

else
    echo -e "\\t\\t\\t\\t[NO]"
    echo
    echo "***********************************"
    echo "Access to the internet is required."
    echo "***********************************"
    echo
    exit 1
fi

#############################################################################
# UPDATE OPERATING SYSTEM
#############################################################################

echo
echo "*** UPDATING OPERATING SYSTEM ***"
# Update CentOS 7
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 7" ]; then
    echo "[+] Downloading packages from repositories and upgrade..."
    yum -y -q update
fi

# Update CentOS 8+ and Fedora
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 8" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 27" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 28" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 29" ]; then
    echo "[+] Downloading packages from repositories and upgrade..."
    dnf -y -q update
fi

# Update Debian and Ubuntu
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 8" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 9" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 10" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 14.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 16.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.10" ]; then
    echo "[+] Downloading package list from repositories..."
    apt-get -qq update

    echo "[+] Downloading and upgrading packages..."
    apt-get -y -qq upgrade
fi

sleep 1

#############################################################################
# INSTALL NEW SOFTWARE
#############################################################################

# The following packages are needed for the bots to work.
# - wget              Used for installation and updates
# - curl              Used for sending the bot content to the Telegram API
# - bc                Used for doing calculations in scripts
# - aptitude          Provides the upgradable package list on Debian/Ubuntu

echo
echo "*** INSTALLING DEPENDENCIES ***"
echo "[+] Installing dependencies..."

# Install dependencies on CentOS 7
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 7" ]; then
    yum -y -q install wget bc
fi

# Install dependencies on CentOS 8+ and Fedora
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "CentOS Linux 8" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 27" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 28" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Fedora 29" ]; then
    dnf -y -q install wget bc
fi

# Install dependencies on Debian and Ubuntu
if [ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 8" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 9" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Debian GNU/Linux 10" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 14.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 16.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.04" ] || \
[ "$OPERATING_SYSTEM $OPERATING_SYSTEM_VERSION" == "Ubuntu 18.10" ]; then
    apt-get -y -qq install aptitude bc curl
fi

#############################################################################
# CONFIGURATION
#############################################################################

echo
echo "*** CONFIGURATION ***"

# Check whether telegrambot.conf exists and act accordingly
if [ ! -f /etc/telegrambot/telegrambot.conf ]; then
    echo "[+] No existing configuration found, creating new one..."

    # Check whether the variables at the beginning of the script were used
    if [ "$METRICS_TOKEN" != "token" ] && \
    [ "$METRICS_CHAT" != "id" ] && \
    [ "$ALERT_TOKEN" != "token" ] && \
    [ "$ALERT_CHAT" != "id" ] && \
    [ "$UPDATES_TOKEN" != "token" ] && \
    [ "$UPDATES_CHAT" != "id" ] && \
    [ "$LOGIN_TOKEN" != "token" ] && \
    [ "$LOGIN_CHAT" != "id" ] && \
    [ "$OUTAGE_TOKEN" != "token" ] && \
    [ "$OUTAGE_CHAT" != "id" ]; then
        echo "[+] Using provided access tokens..."
        echo "[+] Using provided chat IDs"

    else
        # Bot authentication token
        read -r -p "[?] Enter bot token: " PROVIDED_TOKEN

        # Telegram chat ID
        read -r -p "[?] Enter chat ID:   " PROVIDED_CHAT_ID

        # Use provided token and chat ID in corresponding variables
        METRICS_TOKEN="${PROVIDED_TOKEN}"
        METRICS_CHAT="${PROVIDED_CHAT_ID}"
        ALERT_TOKEN="${PROVIDED_TOKEN}"
        ALERT_CHAT="${PROVIDED_CHAT_ID}"
        UPDATES_TOKEN="${PROVIDED_TOKEN}"
        UPDATES_CHAT="${PROVIDED_CHAT_ID}"
        LOGIN_TOKEN="${PROVIDED_TOKEN}"
        LOGIN_CHAT="${PROVIDED_CHAT_ID}"
        OUTAGE_TOKEN="${PROVIDED_TOKEN}"
        OUTAGE_CHAT="${PROVIDED_CHAT_ID}"
    fi

    # Add telegrambot configuration file to /etc/telegrambot/
    echo "[+] Adding configuration file to system..."
    mkdir -m 755 /etc/telegrambot
    wget -q https://raw.githubusercontent.com/sveeke/TelegramBots/master/telegrambot.conf -O /etc/telegrambot/telegrambot.conf
    chmod 640 /etc/telegrambot/telegrambot.conf

    # Add operating system information
    echo "[+] Adding system information..."
    sed -i s%'operating_system_here'%"${OPERATING_SYSTEM}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'operating_system_version_here'%"${OPERATING_SYSTEM_VERSION}"%g /etc/telegrambot/telegrambot.conf
    
    # Add access tokens and chat IDs
    echo "[+] Adding access token and chat ID to bots..."
    sed -i s%'auto_upgrade_here'%"${AUTO_UPGRADE}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'metrics_activate_here'%"${METRICS_ENABLED}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'metrics_token_here'%"${METRICS_TOKEN}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'metrics_id_here'%"${METRICS_CHAT}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'alert_activate_here'%"${ALERT_ENABLED}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'alert_token_here'%"${ALERT_TOKEN}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'alert_id_here'%"${ALERT_CHAT}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'updates_activate_here'%"${UPDATES_ENABLED}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'updates_token_here'%"${UPDATES_TOKEN}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'updates_id_here'%"${UPDATES_CHAT}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'login_activate_here'%"${LOGIN_ENABLED}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'login_token_here'%"${LOGIN_TOKEN}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'login_id_here'%"${LOGIN_CHAT}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'outage_activate_here'%"${OUTAGE_ENABLED}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'outage_token_here'%"${OUTAGE_TOKEN}"%g /etc/telegrambot/telegrambot.conf
    sed -i s%'outage_id_here'%"${OUTAGE_CHAT}"%g /etc/telegrambot/telegrambot.conf

else
    # Notify user that all configuration steps will be skipped
    echo "[i] Existing configuration found, skipping creation..."
    echo "[i] Skipping gathering tokens..."
    echo "[i] Skipping gathering chat IDs..."
    echo "[i] Skipping adding configuration file..."
    echo "[i] Skipping adding tokens and IDs to configuration..."
    echo "[i] Skipping adding cronjobs to system..."
fi

#############################################################################
# BOTS INSTALLATION OR UPDATE
#############################################################################

# Source telegrambot.conf
. /etc/telegrambot/telegrambot.conf

echo
echo "*** INSTALLING BOTS & SCRIPTS ***"

# Install newest version telegrambot
echo "[+] Installing telegrambot"
wget -q https://raw.githubusercontent.com/sveeke/TelegramBots/master/telegrambot.sh -O /usr/local/bin/telegrambot
chmod 700 /usr/local/bin/telegrambot

#############################################################################
# CRON CREATE OR UPDATE
#############################################################################

# Creating or updating cronjobs
/bin/bash /usr/local/bin/telegrambot --config

#############################################################################
# NOTICE
#############################################################################

echo
echo "#############################################################################"
echo "#                         INSTALLATION COMPLETE                             #"
echo "#############################################################################"
echo "#                                                                           #"
echo "#   Just type 'telegrambot' with the desired function and method you want   #"
echo "#   to use. You can change the default bot and script settings in           #"
echo "#   /etc/telegrambot/telegrambot.conf. After changing the config, run       #"
echo "#   'telegrambot --config' to effectuate the changes.                       #"
echo "#                                                                           #"
echo "#   Run 'telegrambot --help' to help you get started                        #"
echo "#                                                                           #"
echo "#############################################################################"
echo
echo

exit 0
