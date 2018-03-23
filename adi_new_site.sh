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

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)WEBSITE = $(tput setaf 2)$WEBSITE" | indent
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)WEBSITE_DOMAIN = $(tput setaf 2)$WEBSITE_DOMAIN" | indent
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)EMAIL = $(tput setaf 2)$EMAIL" | indent
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)MY_CERTIFICATES_PATH = $(tput setaf 2)$MY_CERTIFICATES_PATH" | indent
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)WEBSITE_PROJECTS_PATH = $(tput setaf 2)$WEBSITE_PROJECTS_PATH\n" | indent

# Create NON-SSL entry for website.domain virtual host under apache - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Creating $(tput setaf 5)Non-SSL $(tput setaf 3)virtual host under Apache :\n"

sudo echo "<VirtualHost *:80>
    ServerAdmin $EMAIL
    ServerName $WEBSITE.$WEBSITE_DOMAIN
    ServerAlias www.$WEBSITE.$WEBSITE_DOMAIN
    DocumentRoot \"$WEBSITE_PROJECTS_PATH/$WEBSITE/public\"
    <Directory $WEBSITE_PROJECTS_PATH/$WEBSITE/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
</VirtualHost>" >> /etc/apache2/sites-available/"$WEBSITE"-"$WEBSITE_DOMAIN".conf

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)Non-SSL virtual host created at : $(tput setaf 2)/etc/apache2/sites-available/$(tput setaf 5)"$WEBSITE"-"$WEBSITE_DOMAIN".conf\n" | indent

# Create SSL entry for website.domain virtual host under apache - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Creating $(tput setaf 5)SSL $(tput setaf 3)virtual host under Apache :\n"


sudo echo "<IfModule mod_ssl.c>
    <VirtualHost $WEBSITE.$WEBSITE_DOMAIN:443>

    ServerAdmin $EMAIL
    ServerName $WEBSITE.$WEBSITE_DOMAIN
    ServerAlias www.$WEBSITE.$WEBSITE_DOMAIN
    DocumentRoot \"$WEBSITE_PROJECTS_PATH/$WEBSITE/public\"
    <Directory $WEBSITE_PROJECTS_PATH/$WEBSITE/public>
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        allow from all
    </Directory>
        ErrorLog ${APACHE_LOG_DIR}/error.log
        CustomLog ${APACHE_LOG_DIR}/access.log combined

        SSLEngine on

        SSLCertificateFile  $MY_CERTIFICATES_PATH/$WEBSITE/$WEBSITE.crt
        SSLCertificateKeyFile $MY_CERTIFICATES_PATH/$WEBSITE/$WEBSITE.key

        <FilesMatch \"\.(cgi|shtml|phtml|php)$\">
                SSLOptions +StdEnvVars
        </FilesMatch>

        <Directory /usr/lib/cgi-bin>
                SSLOptions +StdEnvVars
        </Directory>
    </VirtualHost>
</IfModule>" >> /etc/apache2/sites-available/"$WEBSITE"-"$WEBSITE_DOMAIN"-ssl.conf


echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)SSL virtual host created at : $(tput setaf 2)/etc/apache2/sites-available/$(tput setaf 5)$WEBSITE-$WEBSITE_DOMAIN-ssl.conf\n" | indent

# Append hosts file entry at the bottom - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Editing $(tput setaf 5)/etc/hosts $(tput setaf 3)file :\n"

sudo cat >> /etc/hosts <<EOF
127.0.0.1   $WEBSITE.$WEBSITE_DOMAIN
EOF

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)Added entry to hosts file : $(tput setaf 2)127.0.0.1   $WEBSITE.$WEBSITE_DOMAIN\n" | indent

# Create directories for SSL certificates - Aditya Hajare <aditya43@gmail.com>

sudo mkdir -m 777 $MY_CERTIFICATES_PATH/$WEBSITE/
sudo chown -R root:aditya $MY_CERTIFICATES_PATH/$WEBSITE/

# Generate self signed SSL certificates - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Generating self-signed SSL certificates :\n"

openssl req \
    -newkey rsa:2048 \
    -x509 \
    -nodes \
    -keyout "$MY_CERTIFICATES_PATH"/"$WEBSITE"/"$WEBSITE".key \
    -new \
    -out "$MY_CERTIFICATES_PATH"/"$WEBSITE"/"$WEBSITE".crt \
    -subj /CN="$WEBSITE"."$WEBSITE_DOMAIN" \
    -reqexts SAN \
    -extensions SAN \
    -config <(cat /usr/lib/ssl/openssl.cnf \
        <(printf "[SAN]\nsubjectAltName=DNS:localhost, DNS:$WEBSITE.$WEBSITE_DOMAIN")) \
    -sha256 \
    -days 3650

echo -e "\n$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)SSL certificate .key file generated at : $(tput setaf 2)$MY_CERTIFICATES_PATH/$WEBSITE/$(tput setaf 5)$WEBSITE.key" | indent
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)SSL certificate .crt file generated at : $(tput setaf 2)$MY_CERTIFICATES_PATH/$WEBSITE/$(tput setaf 5)$WEBSITE.crt\n" | indent

# Copy SSL certificate to ca-certificates database - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Adding self-signed SSL certificates to trusted root:\n"

sudo cp -rf "$MY_CERTIFICATES_PATH"/"$WEBSITE"/"$WEBSITE".crt /usr/local/share/ca-certificates/
sudo cp -rf "$MY_CERTIFICATES_PATH"/"$WEBSITE"/"$WEBSITE".crt /usr/share/ca-certificates

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 5)$WEBSITE.crt $(tput setaf 7)copied to : $(tput setaf 2)/usr/local/share/ca-certificates/\n" | indent

# Update local ca certificates database - Aditya Hajare <aditya43@gmail.com>

sudo dpkg-reconfigure ca-certificates
sudo update-ca-certificates

echo -e "\n$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)$(tput setaf 7)Updating ca-certificates database." | indent

# Add SSL certificate to chrome's trusted root authority - Aditya Hajare <aditya43@gmail.com>

sudo certutil -d sql:"$HOME"/.pki/nssdb -A -t "C,," -n "$WEBSITE" -i "$MY_CERTIFICATES_PATH"/"$WEBSITE"/"$WEBSITE".crt

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)$(tput setaf 7)Adding $(tput setaf 5)$WEBSITE.crt $(tput setaf 7)to Google Chrome's $(tput setaf 2)Trusted Root Authorities $(tput setaf 7)using $(tput setaf 2)certutil nssdb.\n" | indent

# Enable website in Apache - Aditya Hajare <aditya43@gmail.com>

echo -e "$(tput setaf 3)Configuring Apache :\n"
echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)Enabling website : $(tput setaf 2)$WEBSITE-dev.conf\n" | indent

sudo a2ensite "$WEBSITE-dev.conf"

echo -e "$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)Enabling website : $(tput setaf 2)$WEBSITE-$WEBSITE_DOMAIN-ssl.conf\n" | indent

sudo a2ensite "$WEBSITE-$WEBSITE_DOMAIN-ssl.conf"

# Restart Apache - Aditya Hajare <aditya43@gmail.com>

sudo systemctl restart apache2.service

echo -e "\n$(tput setaf 2)\xE2\x9C\x94 $(tput setaf 7)Restarting Apache web server.\n" | indent

echo -e "$(tput setaf 2)\xE2\x9C\x94 Doneski! $(tput setaf 1)\m/(-_-)\m/\n"

echo -e "\n$(tput setaf 2)+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+-+-+-+-+-+-+-+-+-+" | banner_indent
echo -e "$(tput setaf 2)+         $(tput setaf 7)Script By : $(tput setaf 2)Aditya Hajare $(tput setaf 5)<aditya43@gmail.com>             $(tput setaf 2)+" | banner_indent
echo -e "$(tput setaf 2)+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+--+-+-+-+-+-+-+-+-+-+-+\n" | banner_indent