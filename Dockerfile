FROM osrf/ros2:nightly
MAINTAINER krishneel@krishneel

ENV DEBIAN_FRONTEND noninteractive
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3

# built-in packages
RUN apt-get update \
	&& apt-get install -y --no-install-recommends --allow-unauthenticated \
	build-essential \
	libccd-dev \
	libflann-dev \
	libpcl-dev \
	cmake \
	&& pip3 install cython \
    && apt-get autoclean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/*

# =================================

RUN wget https://github.com/OctoMap/octomap/archive/v1.8.1.tar.gz \
	&& tar -xzvf v1.8.1.tar.gz \
	&& cd octomap-1.8.1 && mkdir build && cd build \
	&& cmake .. && make -j${nproc} && make install

RUN git clone https://github.com/flexible-collision-library/fcl.git /fcl \
	&& mkdir -p /fcl/build && cd /fcl/build \
	&& cmake .. && make -j${nproc} install && make clean
# =================================

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /home/.bashrc

WORKDIR /home
ENV HOME /home
ENV SHELL /bin/bash
ENV COLCON_HOME $HOME/.colcon
