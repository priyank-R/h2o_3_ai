########################################################################
# Dockerfile for Oracle JDK 8 on Ubuntu 16.04
########################################################################
#version h2o_priyank:3.0
# pull base image
FROM public.ecr.aws/e5d0c9b0/hpc_hpe:ubuntu_16.04


# maintainer details
MAINTAINER h2oai "h2o.ai"

# add a post-invoke hook to dpkg which deletes cached deb files
# update the sources.list
# update/dist-upgrade
# clear the caches


RUN \
  export HTTP_PROXY="http://10.154.248.91:8080/" && \
  export HTTPS_PROXY="http://10.154.248.91:8080/" && \
  export FTP_PROXY="http://10.154.248.91:8080/" && \
  export no_proxy="127.0.0.1,localhost" && \
  export HTTP_PROXY="http://10.154.248.91:8080/" && \
  export HTTPS_PROXY="http://10.154.248.91:8080/" && \
  export FTP_PROXY="http://10.154.248.91:8080/" && \
  export NO_PROXY="127.0.0.1,localhost" && \
  echo 'DPkg::Post-Invoke {"/bin/rm -f /var/cache/apt/archives/*.deb || true";};' | tee /etc/apt/apt.conf.d/no-cache && \
  echo "deb http://mirror.math.princeton.edu/pub/ubuntu xenial main universe" >> /etc/apt/sources.list && \
  apt-get update -q -y --fix-missing && \
  apt-get dist-upgrade -y --fix-missing && \
  apt-get clean && \
  rm -rf /var/cache/apt/* && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y wget unzip python-pip python-sklearn python-pandas python-numpy python-matplotlib software-properties-common python-software-properties default-jdk default-jre && \
  apt-get clean

# Fetch h2o latest_stable
RUN \
  wget http://h2o-release.s3.amazonaws.com/h2o/latest_stable -O latest && \
  wget -i latest -O /opt/h2o.zip && \
  unzip -d /opt /opt/h2o.zip && \
  rm /opt/h2o.zip && \
  cd /opt && \
  cd `find . -name 'h2o.jar' | sed 's/.\///;s/\/h2o.jar//g'` && \
  cp h2o.jar /opt

RUN \
  cd /opt &&  \
  apt-get install -y curl && \
  curl --insecure "https://bootstrap.pypa.io/pip/2.7/get-pip.py" -o "get-pip.py" && \
  python3 get-pip.py && \
  pip install `find . -name "*.whl"` && \
  printf '!/bin/bash\ncd /home/h2o\n./start-h2o-docker.sh\n' > /start-h2o-docker.sh && \
  chmod +x /start-h2o-docker.sh

RUN \
  useradd -m -c "h2o.ai" h2o

USER h2o

# Get Content
RUN \
  cd && \
  wget https://raw.githubusercontent.com/h2oai/h2o-3/master/docker/start-h2o-docker.sh && \
  chmod +x start-h2o-docker.sh 


# Define a mountable data directory
#VOLUME \
#  ["/data"]

# Define the working directory
WORKDIR \
  /home/h2o

#COPY ./test.csv /home/h2o

EXPOSE 54321
EXPOSE 54322

ENTRYPOINT ["java", "-Xmx4g", "-jar", "/opt/h2o.jar"]
# Define default command