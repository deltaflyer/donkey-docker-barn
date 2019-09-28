FROM nvidia/cuda:10.1-cudnn7-runtime-ubuntu18.04
LABEL maintainer="Oliver Wannenwetsch"

# fix apt-dependies from lxde-vnc docker image

# install torcs build dependencies
RUN apt-get update \
        && DEBIAN_FRONTEND=noninteractive apt-get upgrade -y \
        && DEBIAN_FRONTEND=noninteractive apt-get install -y \
        wget \
        curl \
        bzip2 \
        git \
        && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8

# Install conda as user
RUN useradd -ms /bin/bash user
USER user
RUN id -u && id -g
WORKDIR /home/user
RUN wget --quiet  https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh  -O /tmp/miniconda.sh && \
    /bin/bash /tmp/miniconda.sh -b -p /home/user/conda && \
    rm /tmp/miniconda.sh && \
    /home/user/conda/bin/conda clean -tipsy

# Install Tensorflow
ENV PATH /home/user/conda/bin/:$PATH
RUN conda update -y -n base -c defaults conda \
    && conda install -y tensorflow-gpu==1.13.1

# Clone Donkey-Car
RUN git clone https://github.com/autorope/donkeycar \
    && cd donkeycar \
    && git checkout 5ce2b17dde6e7c9a88fd02f7876a9c3e408696df

# Setup donkey gym
RUN git clone https://github.com/tawnkramer/gym-donkeycar \
    && cd gym-donkeycar \
    git checkout 3c33a9ed850b059a6c6ca93959df8fe809d06306

# Setup a donkey car environment together with gym-donkeycar
RUN cd ~/donkeycar \
    && conda env create -f install/envs/ubuntu.yml \
    && echo "#!/bin/bash" >> activate.sh \
    && echo "cd ~/donkeycar" >> activate.sh \
    && echo "conda activate donkey" >> activate.sh \
    && echo "pip install -e .[pc]" >> activate.sh \
    && echo "cd ~/gym-donkeycar" >> activate.sh \
    && echo "pip install -e .[pc]" >> activate.sh \
    && echo "donkey createcar --path ~/mycar" >> activate.sh \
    && bash activate.sh \
    && rm -rf ~/mycar \
    && rm activate.sh