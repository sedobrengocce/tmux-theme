#!/bin/bash

# This script will check the battery charge and if is charging or not

# Get the battery charge
BATTERY_CHARGE=$(pmset -g batt | grep '[0-9][0-9]%' | awk 'NR==1{print$3}' | awk -F"%" '{print$1}')

# Get the battery status
BATTERY_STATUS=$(pmset -g batt | grep '[0-9][0-9]%' | awk -F";" '{print$2}')

# Check if the battery is not charging
if [[ $BATTERY_STATUS == *"discharging"* ]]; then
    # Check the battery charge
    if [[ $BATTERY_CHARGE -gt 80 ]]; then
        echo "$BATTERY_CHARGE%  "
    elif [[ $BATTERY_CHARGE -gt 60 ]]; then
        echo "$BATTERY_CHARGE%  "
    elif [[ $BATTERY_CHARGE -gt 40 ]]; then
        echo "$BATTERY_CHARGE%  "
    elif [[ $BATTERY_CHARGE -gt 20 ]]; then
        echo "$BATTERY_CHARGE%  "
    else
        echo "$BATTERY_CHARGE%  "
    fi
else
    echo "$BATTERY_CHARGE%  "
fi

