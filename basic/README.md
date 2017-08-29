# Basic setup with 4 corda nodes

Launch the dockerized corda network:

`docker-compose up -d --build`

Or simply (skip `-d` flag if you want to see the logs on your console, skip `--build` to skip rebuilding from Dockerfiles) like this:

`docker-compose up`

Show logs (or view logs in Kitematic):

`docker-compose logs`

Log into running containers, e.g., NodeA:

`docker exec -t -i NodeA bash`

Terminate the corda network (remove all containers and volume data):

`docker-compose down --volumes`