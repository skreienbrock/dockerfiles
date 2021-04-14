# Basic image you've got to use
# the nvidia-image is an ubuntu 20.04.1 base image:
FROM nvidia/cuda:11.0-base
# FROM ubuntu:20.04
MAINTAINER sven.kreienbrock@ruhr-uni-bochum.de
# RUN apt install ca-certificates
# RUN curl -k -L https://nvidia.github.io/nvidia-docker/gpgkey | apt-key add -
# we don't want to be disturbed while setting up this image...
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update 2>/dev/null && apt-get -y upgrade 2>/dev/null
RUN apt -y install vim wget curl apt-transport-https git ca-certificates
RUN update-ca-certificates

# preparing other software
RUN mkdir /opt/pkgs
WORKDIR /opt/pkgs
## SOFTWARE INSTALLATIONS
# reduce 3.23
RUN wget http://kinemage.biochem.duke.edu/downloads/software/reduce31/reduce.3.23.130521.linuxi386.gz
RUN gunzip reduce.3.23.130521.linuxi386.gz
RUN chmod a+x reduce.3.23.130521.linuxi386
RUN ln /opt/pkgs/reduce.3.23.130521.linuxi386 /usr/local/bin/reduce

# MSMS 2.6.1
# https://mybiosoftware.com/msms-2-6-1-compute-molecular-surfaces.html
# http://mgltools.scripps.edu/downloads#msms
WORKDIR /opt/pkgs
RUN wget http://mgltools.scripps.edu/downloads/tars/releases/MSMSRELEASE/REL2.6.1/msms_i86_64Linux2_2.6.1.tar.gz
RUN mkdir /opt/msms_2.6.1
WORKDIR /opt/msms_2.6.1
RUN tar xf ../pkgs/msms_i86_64Linux2_2.6.1.tar.gz
RUN ln -s /opt/msms_2.6.1/msms.x86_64Linux2.2.6.1 /usr/local/bin/msms.x86

# PyMesh (0.1.14)
WORKDIR /opt/
# sometimes you encounter some problems due to ssl-certs.
#RUN git config --global http.sslverify false
#RUN env GIT_SSL_NO_VERIFY=true git clone https://github.com/PyMesh/PyMesh
RUN git clone git://github.com/PyMesh/PyMesh
WORKDIR /opt/PyMesh
RUN git submodule update --init

# pymol & qt
RUN apt-get -y -qq install pymol qt5-default libusb-1.0.0 libglw1-mesa

WORKDIR /opt/pkgs
RUN mkdir /opt/anaconda3 
# install anaconda individual edition in silent mode
RUN wget https://repo.anaconda.com/archive/Anaconda3-2020.11-Linux-x86_64.sh
RUN /bin/bash Anaconda3-2020.11-Linux-x86_64.sh -b -u -p /opt/anaconda3
RUN rm -v Anaconda3-2020.11-Linux-x86_64.sh
ENV PATH=/opt/anaconda3/bin:$PATH
# install more python packages:
# pymol goes with biopython and pdb2pqr
RUN conda install -c schrodinger pymol-bundle
# adding tensorflow, scikit-learn, dask
RUN conda install tensorflow tensorflow-gpu matplotlib numpy scikit-learn dask scipy
# Open3D
RUN conda install -c open3d-admin -c conda-forge open3d
# RUN conda init && . ~/.bashrc

# StrBioInfo (does not work) (pyton2 problems?)
#RUN pip install strbioinfo
RUN mkdir /opt/strBioInfo
WORKDIR /opt/strBioInfo
RUN wget https://files.pythonhosted.org/packages/77/26/a44051e52123d5a32c77c7600bc13dc6c275782d578258693e54d831f9fc/StrBioInfo-0.2.2.tar.gz
RUN tar xf StrBioInfo-0.2.2.tar.gz
#WORKDIR /opt/strBioInfo/StrBioInfo-0.2.2
#RUN python setup.py install

# Adding a local user to biox group and create homedir
RUN groupadd -g 2500 biox
RUN useradd -m -u 1024 -g biox localuser
# set the user that later runs the software:
USER localuser
WORKDIR /home/localuser
RUN conda init
# run command
CMD /bin/bash


