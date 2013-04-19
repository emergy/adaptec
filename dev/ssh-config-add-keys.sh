#!/bin/sh

echo "Host github.com" >> ~/.ssh/config
echo "    IdentityFile `pwd`/keys/id_rsa" >> .ssh/config
