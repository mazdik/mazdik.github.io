#!/bin/bash
find /home/user/public_html/.* -type d -print0 | xargs -0 chmod -R 755
find /home/user/public_html/.* -type f -print0 | xargs -0 chmod 644