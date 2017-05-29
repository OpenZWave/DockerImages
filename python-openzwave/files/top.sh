#!/bin/bash
/usr/bin/supervisord -c /etc/supervisor/supervisord.conf
nice -n 19 top -b
