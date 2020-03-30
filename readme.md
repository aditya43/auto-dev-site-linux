## About This Project
Bash script to automate the process of creating new dev website under Linux environment.

<p align="center">
<img src="https://raw.githubusercontent.com/aditya43/auto-dev-site-linux/master/screens/screen.gif" alt="Bash script to automate the process of creating new dev website with SSL certificates and more (Linux).">
</p>

## What It Does?
The script will automatically do the following :
- Create non-ssl entry for the `website.domain` virtual host under apache.
- Create ssl entry for the `website.domain` virtual host under apache.
- Auto edit `/etc/hots` and append the entry for : `127.0.0.1      website.domain`.
- Create directories for SSL certificates under `~/$MY_CERTIFICATES_PATH/$WEBSITE`.
- Generate self-signed ssl certificates.
- Add self-signed certificates to `ca-certificates` database.
- Update local `ca certificates` database.
- Add ssl certificate to Google Chrome's trusted root authority using `certutils`.
- Enable non-ssl and ssl virtual hosts under apache.
- Restart apache.

## Tested On
- Ubuntu 20.x
- Ubuntu 19.x
- Ubuntu 18.x
- Ubuntu 17.x
- Ubuntu 16.x

## Prerequisites
Following is the list of prerequisites :
- Apache.
- Google Chrome.
- `OpenSSL 1.1.0g  2 Nov 2017` or above.
- `certutils`.

## How To
1. Edit `adi_new_site.sh` and set the following variables :
```
WEBSITE="adiinviter"
WEBSITE_DOMAIN="dev"
EMAIL="aditya43@gmail.com"
MY_CERTIFICATES_PATH="/home/aditya/myCA"
WEBSITE_PROJECTS_PATH="/var/www/public_html/laravel"
```
2. Open Terminal.
3. Run `bash /path/to/adi_new_site.sh`.
4. Follow the on-screen instructions.

## Contact
Comments and feedbacks are welcome. [Drop a line to Aditya Hajare](http://www.adiinviter.com/support) via AdiInviter Pro's support form.

## License
This code is free to use under the terms of [MIT license](http://opensource.org/licenses/MIT).
