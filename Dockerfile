FROM osrf/ros:noetic-desktop-full
ARG CUDA_VERSION

# Install dependencies, mostly the same as Kalibr
# We know that Python is 3.8 so no need for a conda env
RUN apt-get update && DEBIAN_FRONTEND=noninteractive \
    apt-get install -y \
    git wget autoconf automake nano vim tmux \
    python3-dev python3-pip python3-scipy python3-matplotlib \
    ipython3 python3-wxgtk4.0 python3-tk python3-igraph python3-pyx \
    libeigen3-dev libboost-all-dev libsuitesparse-dev \
    doxygen \
    libopencv-dev \
    libpoco-dev libtbb-dev libblas-dev liblapack-dev libv4l-dev \
    python3-catkin-tools python3-osrf-pycommon

# Install Python reqs
COPY requirements_no_torch.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt

# Install appropriate Pytorch for given Cuda version
RUN pip3 install torch==2.4.0 torchvision==0.19.0 --index-url https://download.pytorch.org/whl/cu${CUDA_VERSION}

# Install e2calib
RUN mkdir /e2calib
COPY python /e2calib/python
RUN cd e2calib && pip3 install -e python/
