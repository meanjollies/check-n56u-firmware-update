# check-n56u-firmware-update

check-n56u-firmware update is a small Ruby script that checks Padavan's rt-n56u repo for the latest release of his firmware. It will send an email notification (SMTP is only supported) if there is a new version. It will attempt to only get info for the N56U via an API call, as Padavan maintains this firmware for multiple models. Padavan's rt-n56u repo on Bitbucket can be found at https://bitbucket.org/padavan/rt-n56u.

If you need an SMTP relay, there are a number of free services that can be found through simple research.

It will create a file under /var/tmp by default that contains the timestamp of the latest download. This is how it determines if there is a new version. If it doesn't already exist, it won't check for the latest firmware update.

### Usage
```$ ./check-n56u-firmware-update.rb```

### Configuration
You must set the following values in the script, otherwise it will fail:
- *@smtp_server*: SMTP server address
- *@smtp_port*: SMTP port
- *@permit_domain*: Domain permitted to send email, usually the one in your email address
- *@smtp_user*: SMTP username
- *@smtp_pass*: SMTP password
- *@rcpt_addr*: Email notifications recipient
- *@from_add*: Email notifications sender

### Todo

License
---
MIT
