# qmware2-install
```
cd qmware2-install
```

## Run it
Run it in background mode
```
sudo /usr/local/bin/docker-compose up -d
```

## Stop it

```
sudo /usr/local/bin/docker-compose down

or

sudo docker stop $(sudo docker ps -aq) && sudo docker rm $(sudo docker ps -aq)
```
