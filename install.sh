#!/bin/bash
LOG=./log.txt
echo "START: " `date` > $LOG
./kubernetes.sh 2>&1 | tee -a $LOG
echo "STOP: " `date` >> $LOG
