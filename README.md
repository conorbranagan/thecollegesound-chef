# The College Sound - Chef Solo Depoloy

## Overview

This contains the necessary cookbooks for deploying The College Sound to a
new server. This is designed to run everything (database, web server, blog) all
on one server. It will be deployed using chef-solo.

## Before the deploy

- Add/update the deploy target name to match what's in your local ~/.ssh/conf

- Add the ssh public key of the new host to the `authorized_keys` template. This
is so the `git clone username@localhost:/srv/...` will work as expected.

- (Optionally) dump the latest DB using the `dump_db.sh` script in the `scripts`
folder and place the dump file `tcs_dump.sql` in the home directory so it can
be loaded into the database.

## After the deploy

- Re-load the Music DB from the latest Discogs dump found at [http://www.discogs.com/data/](http://www.discogs.com/data/)

- !! Make sure stuff works !!

- Point the DNS to the new server.