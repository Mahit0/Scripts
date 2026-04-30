#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp11.sh                #  
# Edit : 30/04/2026             #
# Last commit by : Ottema05     #
#################################

fic_tmp=/tmp/space.$$
if [[ ! -f ${fic_tmp} ]] ; then 
    touch ${fic_tmp}
else 
    > ${fic_tmp}
fi

df -h | awk '{print $1" " $2}'