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

    $ docker run -i -t -p 8888:8888 wd15/pfhub:latest

### View the notebooks

    # cd pfhub
    # jupyter-notebook --ip 0.0.0.0 --no-browser

and view the running Jupyter file browser at http://127.0.0.1:8888 on
the host.

### View the website

    # cd pfhub
    # jekyll serve --host 0.0.0.0 --port 8888

to view the website at http://127.0.0.1:8888/pfhub/ on the host.

## Build the Docker instance

The Docker instance is built using Nix. See (./NIX.md) to get started.
Once you're familiar with Nix, clone this repository and then

    $ nix build .#docker
    $ docker load < result

in the base directory.

## Push the Docker instance

Create the repository in Dockerhub and then push it.

    $ docker login
    $ docker push docker.io/wd15/pfhub
