## About This Project

Bash script to automate the process of creating new dev website under Linux environment. The script will automatically do the following :
- Create non-ssl entry for the `website.domain` virtual host under apache.
- Create ssl entry for the `website.domain` virtual host under apache.
- Auto edit `/etc/hots` and append the entry for : `127.0.0.1      website.domain`.
- Create directories for SSL certificates under `~/$MY_CERTIFICATES_PATH/$WEBSITE`.
- Generate self-signed ssl certificates.
- Add self-signed certificates to `ca-certificates` database.
- Update local ca certificates database.
- Add ssl certificate to Google Chrome's trusted root authority using `certutils`.
- Enable non-ssl and ssl virtual hosts under apache.
- Restart apache.

## Current Status

WIP (Work In Progress)!

## License

Open-sourced software licensed under the [MIT license](http://opensource.org/licenses/MIT).