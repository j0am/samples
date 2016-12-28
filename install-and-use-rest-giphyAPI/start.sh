#!/bin/bash
#-------------
# This script starts a http web service that listens on port 8080
# the url to access the webservice is: <host_ip>:8080/search/[ enter your gif search criteria ]
# ------------
# Lets just run this in the foreground.
# If this is required to be a service, then convert this to a systemd (or initV) script.

/app/w_flask/gif_search/gif_search_env/bin/python3 gif_search.py
