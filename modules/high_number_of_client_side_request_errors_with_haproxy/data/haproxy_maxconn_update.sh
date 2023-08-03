
#!/bin/bash

# Set the maximum connections

MAX_CONNECTIONS=${MAX_CONNECTIONS}

# Update the HAProxy configuration file

sudo sed -i "s/maxconn [0-9]*/maxconn $MAX_CONNECTIONS/" ${HAPROXY_CFG}

# Reload the HAProxy service

sudo systemctl reload haproxy.service