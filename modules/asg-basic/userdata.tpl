#!/bin/bash

set -e

sudo apt-get update -y
sudo dpkg --configure -a
sudo apt install openjdk-11-jre-headless -y
sudo apt install postgresql postgresql-contrib -y
sudo apt install postgresql-client-common -y
