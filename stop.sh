#!/bin/bash

if [[ $# -eq 0 ]]; then 
  docker stop $(docker ps -aq) && docker rm $(docker ps -aq)
else
  /usr/local/bin/docker-compose down $@
fi

