#!/bin/bash
printf "\n\n>>>>>>>>>>>>>>>>>>>>>\nSuccess!\n<<<<<<<<<<<<<<<<<<<<<<\n\n"
find /home/vagrant/.ssh
printf "\n---------------------------\n"
cat /home/vagrant/.ssh/authorized_keys
printf "\n---------------------------\n"
getent passwd
printf "\n---------------------------\n"
printf "\n\n>>>>>>>>>>>>>>>>>>>>>\nSuccess!\n<<<<<<<<<<<<<<<<<<<<<<\n\n"