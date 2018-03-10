#!/bin/bash

# Function to indent output with 2 spaces - Aditya Hajare <aditya43@gmail.com>

indent() { sed 's/^/  /'; }
banner_indent() { sed 's/^/            /'; }

echo -e "\n$(tput setaf 2)+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+-+-+-+-+-+-+-+-+-+" | banner_indent
echo -e "$(tput setaf 2)+         $(tput setaf 7)Script By : $(tput setaf 2)Aditya Hajare $(tput setaf 5)<aditya43@gmail.com>             $(tput setaf 2)+" | banner_indent
echo -e "$(tput setaf 2)+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+-+-+-+-+-+-+-+-+-+\n" | banner_indent

echo -e "$(tput setaf 3)Setting variables :\n"

WEBSITE="adiinviter"
WEBSITE_DOMAIN="dev"
EMAIL="aditya43@gmail.com"
MY_CERTIFICATES_PATH="/home/aditya/myCA"
WEBSITE_PROJECTS_PATH="/var/www/public_html/laravel"