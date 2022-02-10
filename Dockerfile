#this docker file is based on https://github.com/fusion-energy/neutronics-workshop/blob/main/Dockerfile

# build with the following command
# docker build -t [image tag]

# To build with multiple cores change the build command to the following.
# Replace 7 with the number of cores you would like to use
# docker build -t fusion-energy/neutronics-workshop --build-arg compile_cores=7 .
FROM debian:latest

ARG compile_cores=8

#update system
RUN apt-get --allow-releaseinfo-change update
RUN DEBIAN_FRONTEND=noninteractive && apt-get --yes update && apt-get --yes upgrade
RUN DEBIAN_FRONTEND=noninteractive && apt-get --yes install git sudo bash wget apt-utils xz-utils python3

#RUN git clone git@github.com:openmsr/openmc_install_scripts

RUN useradd -rm -u 1001 usr -G sudo -g root -s /bin/bash \
 && sed -i '/%sudo.*ALL/a %sudo ALL=(ALL) NOPASSWD: ALL' /etc/sudoers
USER usr
WORKDIR /home/usr

#clone the install scripts and run them
#RUN git clone git@github.com:openmsr/openmc_install_scripts.git
#this is done step by step to avoid invalidating the docker cache.
COPY OpenMSR/openmc_install_scripts/Debian11/nuclear_data-install.sh .
RUN ./nuclear_data-install.sh

COPY OpenMSR/openmc_install_scripts/Debian11/embree-install.sh .
RUN ./embree-install.sh "$compile_cores"

COPY OpenMSR/openmc_install_scripts/Debian11/moab-install.sh .
RUN ./moab-install.sh "$compile_cores"

COPY OpenMSR/openmc_install_scripts/Debian11/double_down-install.sh .
RUN ./double_down-install.sh "$compile_cores"

COPY OpenMSR/openmc_install_scripts/Debian11/dagmc-install.sh .
RUN ./dagmc-install.sh "$compile_cores"

COPY OpenMSR/openmc_install_scripts/Debian11/openmc-install.sh .
RUN ./openmc-install.sh "$compile_cores"

#clean up a bit
RUN rm *-install.sh
RUN rm *-install.sh.done

#Here should be added COPYING in MSRE-data directories - probably needs meshes and h5m-files as well
#include neither cubit nor onshape can be distributed like this.
#Now we can consider installing more stuff such as a xpra such that we can simply have an X-server
