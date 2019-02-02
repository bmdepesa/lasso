#!/bin/bash

sudo docker stop $(sudo docker ps -aq)
sudo docker rm $(sudo docker ps -aq)
sudo docker rmi $(sudo docker images -q)
sudo docker volume rm $(docker volume ls -qf dangling=true)
