#!/bin/bash
echo "simple script to mass check of virtualization types and os versions"
echo "Operating System: " `awk -F '=' '/PRETTY_NAME/ { print $2 }' /etc/os-release | sed -r 's/.* = (.*)/\1/' | tr -d \"`
if [[ $(hostnamectl | grep Virtu | awk '{print $2}') ]]; then
    echo "Virtualization: " `hostnamectl | grep Virtu | awk '{print $2}'`
else
    echo "Virtualization: Not detected"
fi
