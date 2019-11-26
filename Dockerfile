FROM ubuntu:18.04
RUN echo "Atlassian applications runtime environment"
RUN apt-get update
RUN apt-get install -y software-properties-common
RUN apt-get install -y openjdk-8-jdk
WORKDIR /atlassian
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

#install linux tools
RUN apt-get update && \
  apt-get install -y mc && \
  apt-get install -y nano && \
  apt-get install -y tree && \
  apt-get install -y zip && \
  apt-get install -y wget

#install dev tools
RUN apt-get update && \
  apt-get install -y git && \
  apt-get install -y mercurial && \
  apt-get install -y subversion && \
  wget -P /usr/bin http://www.perforce.com/downloads/perforce/r15.1/bin.linux26x86_64/p4 && \
  chmod +x /usr/bin/p4

ENV LANG C.UTF-8
ENV FECRU_VERSION 4.7.2
ENV FISHEYE_HOME /atlassian/apps/fisheye
ENV FISHEYE_INST /atlassian/data/fisheye
ENV FISHEYE_OPTS -Dfecru.configure.from.env.variables=true

# FishEye configuration from environment variables
# ENV FECRU_CONFIGURE_LICENSE_FISHEYE=
# ENV FECRU_CONFIGURE_LICENSE_CRUCIBLE=
# ENV FECRU_CONFIGURE_ADMIN_PASSWORD=
# ENV FECRU_CONFIGURE_DB_TYPE=
# ENV FECRU_CONFIGURE_DB_HOST=
# ENV FECRU_CONFIGURE_DB_PORT=
# ENV FECRU_CONFIGURE_DB_NAME=
# ENV FECRU_CONFIGURE_DB_USER=
# ENV FECRU_CONFIGURE_DB_PASSWORD=
# ENV FECRU_CONFIGURE_DB_MIN_POOL_SIZE=
# ENV FECRU_CONFIGURE_DB_MAX_POOL_SIZE=

RUN echo "Atlassian - FishEye ${FECRU_VERSION} applications runtime environment"

WORKDIR /atlassian/apps

# download and install fisheye to /atlassian/apps/fisheye
ADD http://www.atlassian.com/software/fisheye/downloads/binary/fisheye-${FECRU_VERSION}.zip /atlassian/apps/

RUN unzip fisheye-${FECRU_VERSION}.zip && rm fisheye-${FECRU_VERSION}.zip
RUN mv fecru-${FECRU_VERSION} fisheye
RUN mkdir -p /atlassian/data/fisheye

ADD configure.sh ${FISHEYE_HOME}/
RUN chmod +x ${FISHEYE_HOME}/configure.sh
ADD start.sh ${FISHEYE_HOME}/
RUN chmod +x ${FISHEYE_HOME}/start.sh

VOLUME ${FISHEYE_INST}

EXPOSE 8080

WORKDIR ${FISHEYE_HOME}/

CMD ["./start.sh"]
