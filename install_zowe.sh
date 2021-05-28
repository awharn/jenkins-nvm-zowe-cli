#!/bin/bash

# Exit if any commands fail
set -e

# Ensure that a version was passed
if [ -z "$1" ]; then
    echo "No package tag was specified. Installing zowe-v1-lts."
    PKG_TAG=zowe-v1-lts
else 
    PKG_TAG=$1
fi

# Reload the following - recommended for making nvm available to the script
. ~/.nvm/nvm.sh
. ~/.profile
. ~/.bashrc

# Install the requested version, use the version, and set the default
# for any further terminals

npm config set @zowe:registry https://zowe.jfrog.io/zowe/api/npm/npm-local-release/
rm -rf ~/.zowe/plugins
npm install -g @zowe/cli@${PKG_TAG}
zowe plugins install @zowe/zos-ftp-for-zowe-cli@${PKG_TAG} @zowe/cics-for-zowe-cli@${PKG_TAG} @zowe/db2-for-zowe-cli@${PKG_TAG} @zowe/ims-for-zowe-cli@${PKG_TAG} @zowe/mq-for-zowe-cli@${PKG_TAG}

exit 0



