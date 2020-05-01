FROM ubuntu:bionic
MAINTAINER krishneel@krishneel

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO crystal
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3

RUN apt-get update && apt-get install -y \
	curl gnupg2 lsb-release\
	libgl1-mesa-glx libgl1-mesa-dri \
	libglu1-mesa-dev freeglut3-dev mesa-common-dev \
	build-essential \
	libfontconfig1 \
	python3-pip\
	cmake \
	git \
	wget \
	libasio-dev \
	libtinyxml2-dev\
	libpcre3-dev \
	libpcre3 \
	liblog4cxx-dev\
	liborocos-kdl-dev \
	xorg-dev \
	xaw3dg \
	libtinyxml-dev\
	qtcreator \
	qt5-default \
	&& pip3 install -U \
	colcon-common-extensions \
	lark-parser \
	rosdep \
	vcstool \
	argcomplete \
	flake8 \
	flake8-blind-except \
	flake8-builtins \
	flake8-class-newline \
	flake8-comprehensions \
	flake8-deprecated \
	flake8-docstrings \
	flake8-import-order \
	flake8-quotes \
	pytest-repeat \
	pytest-rerunfailures \
	pytest \
	pytest-cov \
	pytest-runner \
	setuptools\
	&& pip3 install ipython \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -

RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list --as-root apt:false


WORKDIR /opt/ros2/$ROS_DISTRO/src/
RUN cd /opt/ros2/$ROS_DISTRO &&\
	wget https://raw.githubusercontent.com/ros2/ros2/crystal/ros2.repos && \
	vcs import src < ros2.repos

RUN python3 -m pip install PyYAML
RUN apt-get update && apt-get install -y libpoco-dev
RUN cd /opt/ros2/$ROS_DISTRO/ && pwd && ls
RUN rosdep init && rosdep update
RUN rosdep install --from-paths /opt/ros2/$ROS_DISTRO/src --ignore-src --rosdistro $ROS_DISTRO -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"

RUN cd /opt/ros2/$ROS_DISTRO/ && colcon build --symlink-install

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

WORKDIR /ros2/$ROS_DISTRO/src
