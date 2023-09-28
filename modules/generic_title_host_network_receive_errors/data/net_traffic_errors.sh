

#!/bin/bash



# Set the network interface to diagnose (replace ${INTERFACE_NAME} with the actual interface name)

INTERFACE_NAME=${INTERFACE_NAME}



# Check the current network traffic on the interface

TRAFFIC=$(ifconfig $INTERFACE_NAME | grep "RX packets" | awk '{print $5}')



# Check the current number of errors on the interface

ERRORS=$(ifconfig $INTERFACE_NAME | grep "RX errors" | awk '{print $2}')



# Check if the number of errors is increasing rapidly

if [ $ERRORS -gt 0 ]; then

    ERROR_RATE=$((ERRORS*100/TRAFFIC))

    if [ $ERROR_RATE -gt 5 ]; then

        echo "Network congestion may be causing Host Network Receive Errors on $INTERFACE_NAME"

    else

        echo "Errors on $INTERFACE_NAME are within normal range"

    fi

else

    echo "No errors found on $INTERFACE_NAME"

fi