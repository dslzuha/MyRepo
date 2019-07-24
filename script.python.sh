#!/bin/bash

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


virtualenv_check ()
{
  if [ -z "$VIRTUAL_ENV" ]; then
    echo "Detected VirtualEnv: Please visit https://packagecloud.io/dslzuha/MyRepo/install#virtualenv"
  fi
}

new_global_section ()
{
  echo "No pip.conf found, creating"
  mkdir -p "$HOME/.pip"
  pip_extra_url > $HOME/.pip/pip.conf
}

edit_global_section ()
{
  echo "pip.conf found, making a backup copy, and appending"
  cp $HOME/.pip/pip.conf $HOME/.pip/pip.conf.bak
  awk -v regex="$(escaped_pip_extra_url)" '{ gsub(/^\[global\]$/, regex); print }' $HOME/.pip/pip.conf.bak > $HOME/.pip/pip.conf
  echo "pip.conf appended, backup copy: $HOME/.pip/pip.conf.bak"
}

pip_check ()
{
  version=`pip --version`
  echo $version
}

abort_already_configured ()
{
  if [ -e "$HOME/.pip/pip.conf" ]; then
    if grep -q "dslzuha/MyRepo" "$HOME/.pip/pip.conf"; then
      echo "Already configured pip for this repository, skipping"
      exit 0
    fi
  fi
}

pip_extra_url ()
{
  printf "[global]\nextra-index-url=https://packagecloud.io/dslzuha/MyRepo/pypi/simple\n"
}

escaped_pip_extra_url ()
{
  printf "[global]\\\nextra-index-url=https://packagecloud.io/dslzuha/MyRepo/pypi/simple"
}

edit_pip_config ()
{
  if [ -e "$HOME/.pip/pip.conf" ]; then
    edit_global_section
  else
    new_global_section
  fi
}

main ()
{
  abort_already_configured
  curl_check
  virtualenv_check
  pip_check


  edit_pip_config

  echo "The repository is setup! You can now install packages."
}

main
