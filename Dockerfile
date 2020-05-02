FROM ubuntu:bionic
MAINTAINER krishneel@krishneel

ENV DEBIAN_FRONTEND=noninteractive
ENV ROS_DISTRO dashing
ENV LANG C.UTF-8
ENV LC_ALL C.UTF-8
ENV ROS_PYTHON_VERSION 3

RUN apt-get update && apt-get install -y \
	curl \
	gnupg2 \
	lsb-release \
	&& rm -rf /var/lib/apt/lists/*

RUN curl -s https://raw.githubusercontent.com/ros/rosdistro/master/ros.asc | apt-key add -
RUN echo "deb http://packages.ros.org/ros2/ubuntu `lsb_release -cs` main" > /etc/apt/sources.list.d/ros2-latest.list --as-root apt:false

	# xserver-xorg-video-all dbus-x11 x11-utils \
RUN apt-get update && apt-get install -y \
	libgl1-mesa-dri \
	libgl1-mesa-glx \ 
	libglu1-mesa-dev \
	freeglut3-dev mesa-common-dev \
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
	libpoco-dev \
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
	PyYAML\
	&& pip3 install ipython 
	# && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/ros2/$ROS_DISTRO/src/
RUN cd /opt/ros2/$ROS_DISTRO &&\
	wget https://raw.githubusercontent.com/ros2/ros2/$ROS_DISTRO/ros2.repos && \
	vcs import src < ros2.repos

# RUN cd /opt/ros2/$ROS_DISTRO/ && pwd && ls
RUN rosdep init && rosdep update
RUN rosdep install --from-paths /opt/ros2/$ROS_DISTRO/src --ignore-src --rosdistro $ROS_DISTRO -y --skip-keys "console_bridge fastcdr fastrtps libopensplice67 libopensplice69 rti-connext-dds-5.3.1 urdfdom_headers"

RUN cd /opt/ros2/$ROS_DISTRO/ && \
	colcon build --packages-skip-test-passed  --continue-on-error --symlink-install 

RUN rm -rf /var/lib/apt/lists/*

COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["bash"]

WORKDIR /ros2/$ROS_DISTRO/src

