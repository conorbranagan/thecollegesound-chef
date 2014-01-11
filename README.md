# The College Sound - Chef Solo Depoloy

## Overview

This contains the necessary cookbooks for deploying The College Sound to a
new server. This is designed to run everything (database, web server) all
on one server. It will be deployed using chef-solo.

## Vagrant

The entire deploy process can be run locally with Vagrant with just a bit
of simple setup.

1. Generate an ssh-key that will be able to access the remote repo holding
   the code for the web app.

   $ ssh-keygen -t rsa -b 4096 -f ~/.ssh/tcs-chef

2. Add that key to the Bitbucket or Github account that's storing the code.

3. Install any necessary dependencies: Virtualbox, Vagrant.

4. Run `vagrant up` to provision the environment.


## Before production deploy. (TODO: Update some of these steps.)

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