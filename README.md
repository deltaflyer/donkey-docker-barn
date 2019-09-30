# Donkey-Docker-Barn - A Docker Container Development Environment for Donkey Car

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

This is a Docker-based Donkey-Installation suitable for performing all machine learning tasks and running the donkey unity-based simulator.
It's main purpose is to have a reproducable development environment with minimal footprint for developing features on Donkey car.
It also manages the versions of dependent software artifacts (tensor flow, other git repos)

## Starting up

Run the command `run_environment.sh` to get an interactive bash shell with donkey installed.
A docker container is build on the initial startup.

## Architecture

While the Donkey Car Stack runs completely in Docker, the unit-based 3D-simulator runs on the host machine.
Docker interconnects both software parts using Docker's internal network capabilities

![architecture](https://user-images.githubusercontent.com/491707/65860718-23044900-e36b-11e9-8b65-d22e4a8f9339.png)

## Running the donkey simulator

* Download the donkey unity simulator to your _host_ machine (since it is executing the main wayland / xwindow context.
* Start the simulator on the _host_ machine with `donkey_sim.x86_64 --port 9090`. The `--port` argument is important to link the simulator to the donkey software stack running in the docker container
* Start the donkey docker container with `./run_environment.sh`

## Requirements

Following requirements exist from the hard- and software side

* any mainstream Linux distribution
* nvidia cuda-enabled GPU card
* official nvidia driver with CUDA support
* docker
* nvidia docker runtime
