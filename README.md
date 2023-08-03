
### About Shoreline
The Shoreline platform provides real-time monitoring, alerting, and incident automation for cloud operations. Use Shoreline to detect, debug, and automate repairs across your entire fleet in seconds with just a few lines of code.

Shoreline Agents are efficient and non-intrusive processes running in the background of all your monitored hosts. Agents act as the secure link between Shoreline and your environment's Resources, providing real-time monitoring and metric collection across your fleet. Agents can execute actions on your behalf -- everything from simple Linux commands to full remediation playbooks -- running simultaneously across all the targeted Resources.

Since Agents are distributed throughout your fleet and monitor your Resources in real time, when an issue occurs Shoreline automatically alerts your team before your operators notice something is wrong. Plus, when you're ready for it, Shoreline can automatically resolve these issues using Alarms, Actions, Bots, and other Shoreline tools that you configure. These objects work in tandem to monitor your fleet and dispatch the appropriate response if something goes wrong -- you can even receive notifications via the fully-customizable Slack integration.

Shoreline Notebooks let you convert your static runbooks into interactive, annotated, sharable web-based documents. Through a combination of Markdown-based notes and Shoreline's expressive Op language, you have one-click access to real-time, per-second debug data and powerful, fleetwide repair commands.

### What are Shoreline Op Packs?
Shoreline Op Packs are open-source collections of Terraform configurations and supporting scripts that use the Shoreline Terraform Provider and the Shoreline Platform to create turnkey incident automations for common operational issues. Each Op Pack comes with smart defaults and works out of the box with minimal setup, while also providing you and your team with the flexibility to customize, automate, codify, and commit your own Op Pack configurations.

# High number of client-side request errors with HAProxy
---

This incident type refers to a high number of client-side request errors for a specific service, in this case HAProxy. This can be caused by various reasons such as client timeout, connection termination or read errors from the client. The incident is triggered when the error rate deviates from the predicted value and exceeds a certain threshold. This incident can affect the end-users' experience and requires immediate attention to prevent further issues.

### Parameters
```shell
# Environment Variables

export HAPROXY_CFG="PLACEHOLDER"

export HAPROXY_LOG="PLACEHOLDER"

export SERVER_IP="PLACEHOLDER"

export SERVER_NAME="PLACEHOLDER"

export SERVER_LOG="PLACEHOLDER"

export INTERFACE="PLACEHOLDER"

export MAX_CONNECTIONS="PLACEHOLDER"

```

## Debug

### Check HAProxy status
```shell
systemctl status haproxy
```

### Check the HAProxy configuration file for any syntax errors
```shell
haproxy -c -V -f ${HAPROXY_CFG}
```

### Check the current number of client-side request errors
```shell
tail -n 1000 ${HAPROXY_LOG} | grep "client-side request error"
```

### Check the network connectivity between the client and the server
```shell
ping ${SERVER_IP}
```

### Check the DNS resolution for the server
```shell
nslookup ${SERVER_NAME}
```

### Check the server logs for any errors or issues
```shell
tail -n 1000 ${SERVER_LOG} | grep "error"
```

### Check the server's firewall configuration to ensure it's not blocking traffic
```shell
iptables -L
```

### Check the server's resource utilization
```shell
top
```

### Security-related issues such as DDoS attacks or malicious traffic that cause anomalies in the error rate.
```shell
bash

#!/bin/bash

# Set variables

LOG_FILE="/var/log/haproxy.log"

ERROR_THRESHOLD=1000

ANOMALY_THRESHOLD=10

# Check for anomalies in error rate

anomalies=$(grep "haproxy.*frontend.*errors.*req_rate" $LOG_FILE | awk '{print $NF}' | awk -F'[,%]' '{print $1}')

max_anomaly=$(echo "$anomalies" | sort -nr | head -n 1)

if [ "$max_anomaly" -ge "$ANOMALY_THRESHOLD" ]; then

    echo "Anomalies detected in error rate. Maximum anomaly is $max_anomaly."

    # Check for DDoS attacks or malicious traffic

    errors=$(grep "haproxy.*frontend.*errors.*req_rate" $LOG_FILE | awk '{print $NF}' | awk -F'[,%]' '{if ($1 >= '$ERROR_THRESHOLD') print $0}')

    if [ -n "$errors" ]; then

        echo "Potential DDoS or malicious traffic detected:"

        echo "$errors"

    else

        echo "No DDoS or malicious traffic detected."

    fi

else

    echo "No anomalies detected in error rate."

fi


```

## Repair

### Updates the maximum connections .
```shell

#!/bin/bash

# Set the maximum connections

MAX_CONNECTIONS=${MAX_CONNECTIONS}

# Update the HAProxy configuration file

sudo sed -i "s/maxconn [0-9]*/maxconn $MAX_CONNECTIONS/" ${HAPROXY_CFG}

# Reload the HAProxy service

sudo systemctl reload haproxy.service
```