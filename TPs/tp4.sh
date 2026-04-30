#!/bin/bash

#################################
# Author : Ottema05             #
# File : tp4.sh                 #  
# Edit : 27/04/2026             #
# Last commit by : Ottema05     #
#################################

# On verif si notre variable n'est pas vide, sinon on explique comment faire
if [ $1 == "" ] ; then 
    echo "Exemple d'utilisations : 
    \n ~/tp4.sh sshd.service
    "
    exit 1
fi

# On recup le PID du processus voulu
proc_PID=$(pgrep $1)
if [ ${proc_PID} == "" ] ; then
    echo "Le processus existe pas"
else
    echo "Le processus $1 a comme PID ${proc_PID}"
fi