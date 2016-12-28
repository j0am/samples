#!/bin/bash -e
#-------------
# Script to install required ubuntu packages that are needed to run a small webservice
# Assumptions - 
#  1. This script is run as root
#  2. The os debian package management system is configured correctly to point to 
#      a valid ubuntu repository.
#  
#  This script will install packages and create necessary directories for the app.
#  In case there is an error, hopefully we have some logs in /var/tmp/gif_search_install.log.
#
#  Tested on ubuntu server: 16.04.1 LTS
#  
#-------------

ME=${0}
LOGFILE=/var/tmp/gif_search_install.log
echo "${ME}: START `date`" > ${LOGFILE}

# function to clean up and print some useful info if user Cancels on us.
err_exit(){
  local msg="$@" 
  #cleanup: Currently we dont leave any other status of tmp files.

  # echo something to console and raise proper status so a monitoring script can react.
  printf "\t${ME}: Exiting without completing all tasks!\n"
  printf "\t${ME}: Error at ${msg}\n"
  printf "\t${ME}: Please check ${LOGFILE} for any errors\n"
  #return err status
  exit 1
}

# function to echo on console as well as persist to a log file.
echo_log(){
  local msg="$@" 
  printf " ${msg}\n" >>${LOGFILE}
  printf " ${msg}\n" 
}

# -- start of main execution....
echo_log "${ME}: Start"
trap err_exit SIGINT


#1. Basic pip so we can install everything else under this.
echo_log "${ME}: Installing required packages..."
if ! /usr/bin/apt-get -y -q install python3-pip python3-dev &>>${LOGFILE}
then
  err_exit "INSTALL_S1:"
fi

#2. virtualenv 
if !  /usr/bin/pip3 install virtualenv
then
  err_exit "INSTALL_S2:"
fi

echo_log "${ME}: Creating directories..."
#3. Create Directory structures for the app
APP_DIR="/app/w_flask/gif_search"
if ! mkdir -p ${APP_DIR}
then
  err_exit "INSTALL_S3:"
fi

cd ${APP_DIR}
echo_log "${ME}: Cur dir `pwd` "

echo_log "${ME}: Creating virtualenv bins and activating"
virtualenv gif_search_env &>${LOGFILE}
if [[ $? -ne 0 ]]; then err_exit "INSTALL_S4:"; fi

source gif_search_env/bin/activate
echo_log "${ME}: Installing Flask and uwsgi"
if !  pip install uwsgi flask 
then
  err_exit "INSTALL_S4:"
fi

echo "${ME}: End - Successful completion."
exit 0
