FROM debian:latest

ARG compile_cores=8

#update system
RUN apt-get --allow-releaseinfo-change update
RUN DEBIAN_FRONTEND=noninteractive && apt-get --yes update && apt-get --yes upgrade
RUN DEBIAN_FRONTEND=noninteractive && apt-get --yes install git sudo bash wget apt-utils xz-utils python3 python3-pip

#RUN git clone git@github.com:openmsr/openmc_install_scripts

RUN groupadd -g 1000 usr
RUN useradd -rm -u 1000 usr -G sudo -g usr -s /bin/bash \
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
RUN mkdir msre
COPY msre_simple.step msre/
COPY msre_simple.h5m msre/
COPY msre_*.py msre/
RUN mkdir example_notebooks
COPY MSRE.ipynb example_notebooks/

#we are now ready to run the msre
RUN sudo pip install jupyterlab
EXPOSE 8888
ENTRYPOINT ["jupyter","lab","--ip=0.0.0.0","--allow-root"]
