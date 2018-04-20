# Run PFHub in a Docker Instance

## Install Docker

Install Docker and run the Daemon. See
https://docs.docker.com/install/linux/docker-ce/ubuntu/ for
installation details.

    $ sudo service docker start

## Pull the Docker instance

Pull the Docker Instance from Dockerhub

    $ docker pull docker.io/wd15/pfhub

## Run PFHub

Run the container

    $ docker run -i -t -p 4000:4000 wd15/pfhub:latest

and then

    # jekyll serve --host 0.0.0.0

to view the website at http://127.0.0.1:4000/pfhub/ on the host.

## Build the Docker instance

Clone this repository and run

    $ docker build -t wd15/pfhub:latest .

## Push the Docker instance

Create the repository in Dockerhub and then push it.

    $ docker login
    $ docker push docker.io/wd15/pfhub
