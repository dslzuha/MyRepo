#!/bin/bash

epoch_time=`date +%s`

# Set the target directory where .npmrc will be written by setting the $DIR
# environment variable prior to running this script.
#
# If $DIR is left unset, the script will default to writing an .npmrc in
# the current user's home directory.
#
# Alternatively, $DIR can be set to a specific directory so that the npmrc
# takes effect only for commands run in that directory.

set_write_dir () {
  if [[ -z $DIR ]]; then
    NPMRC_DEST_DIR=$HOME
  elif [[ ! -d $DIR ]]; then
    echo "${DIR} does not exist. You must specify an existing directory for .npmrc to be written."
    exit 1
  else
    NPMRC_DEST_DIR=$DIR
  fi
}

curl_check ()
{
  echo "Checking for curl..."
  if command -v curl > /dev/null; then
    echo "Detected curl..."
  else
    echo "curl could not be found, please install curl and try again"
    exit 1
  fi
}

abort_if_npmrc_exists ()
{
  if [[ ( -e ${NPMRC_DEST_DIR}/.npmrc ) && ( -z "${force_npm}" ) ]]; then
    echo
    echo "WARNING: your system already has an ${NPMRC_DEST_DIR}/.npmrc file"
    echo "         this script will now exit without doing anything!"
    echo
    echo "You can also specify an alternate directory where .npmrc will be written by setting"
    echo "DIR and re-running the script (e.g., DIR=/var/code/project ./script.sh)"
    echo
    echo "If you want to use ${NPMRC_DEST_DIR} even though it has an .npmrc already, you should either"
    echo "delete your existing ${NPMRC_DEST_DIR}/.npmrc or set force_npm=1 when running"
    echo "this script!"
    echo
    exit 1
  elif [[ ( -e ${NPMRC_DEST_DIR}/.npmrc ) ]]; then
    echo "Existing ${NPMRC_DEST_DIR}/.npmrc file detected, but force_npm specified."
    echo "Renaming your existing file to: ${NPMRC_DEST_DIR}/${epoch_time}.npmrc.bak."
    mv ${NPMRC_DEST_DIR}/.npmrc ${NPMRC_DEST_DIR}/${epoch_time}.npmrc.bak
  fi
}

generate_npmrc ()
{
  echo "Generating ${NPMRC_DEST_DIR}/.npmrc..."

  repo_url=https://packagecloud.io/dslzuha/MyRepo/npm/

  echo "registry=${repo_url}" > ${NPMRC_DEST_DIR}/.npmrc

  if [[ -z "$DIR" ]]; then
    echo
    echo "You didn't specify the environment variable DIR, so your .npmrc file was written to your home directory (${NPMRC_DEST_DIR})."
    echo "If you want to create a project specific npmrc, you can re-run this script and set \$DIR to the directory where .npmrc should be written."
  fi
}


main ()
{
  curl_check
  set_write_dir
  abort_if_npmrc_exists


  generate_npmrc
}

main
