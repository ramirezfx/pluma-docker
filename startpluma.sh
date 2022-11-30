#!/bin/bash

HOME="$(echo ~)"

set -e

if [[ -n "$(docker ps -qaf 'name=ramirezfx/pluma:latest')" ]]; then
	docker restart ramirezfx/pluma:latest
else
	USER_UID=$(id -u)
	USER_GID=$(id -g)
	xhost +local:docker

	docker run --shm-size=2g --rm \
                --security-opt seccomp=unconfined \
		--env=USER_UID=$USER_UID \
		--env=USER_GID=$USER_GID \
		--env=DISPLAY=unix$DISPLAY \
		-v ${HOME}/docker/pluma-home:/home/pluma \
                -v ${HOME}/docker/sync:/sync \
		--volume=/tmp/.X11-unix:/tmp/.X11-unix:ro \
		--volume=/run/user/$USER_UID/pulse:/run/pulse:ro \
		--name pluma \
		ramirezfx/pluma:latest
fi
