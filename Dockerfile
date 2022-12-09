ARG IMAGE=containers.intersystems.com/intersystems/irishealth-community:2022.2.0.368.0
FROM $IMAGE

USER root

WORKDIR /opt/irisapp
RUN chown -R irisowner:irisowner /opt/irisapp

# install tools
RUN apt-get update && apt-get install -y \
  python3-pip \
  && rm -rf /var/lib/apt/lists/*

USER irisowner

# install python libraries
RUN pip3 install --target /usr/irissys/mgr/python/ pandas openpyxl

# copy file to image
WORKDIR /opt/irisapp
COPY --chown=irisowner:irisowner iris.script iris.script
COPY --chown=irisowner:irisowner src src
COPY --chown=irisowner:irisowner install install

# run iris.script
RUN iris start IRIS \
    && iris session IRIS < /opt/irisapp/iris.script \
    && iris stop IRIS quietly