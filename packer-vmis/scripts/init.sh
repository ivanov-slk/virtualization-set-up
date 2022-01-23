#!/bin/bash

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y net-tools vnstat bmon tcptrack

sudo apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release