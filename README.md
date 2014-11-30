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

2. Add that key to the Github account that's storing the code.

3. Install any necessary dependencies: Virtualbox, Vagrant.
