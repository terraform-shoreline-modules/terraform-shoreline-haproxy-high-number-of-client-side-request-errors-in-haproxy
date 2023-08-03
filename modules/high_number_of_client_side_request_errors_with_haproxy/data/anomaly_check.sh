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