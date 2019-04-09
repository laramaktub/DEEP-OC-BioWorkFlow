FROM ubuntu:16.04

RUN apt-get update && apt-get install -y gcc g++ perl nano python automake make wget git curl libdb-dev software-properties-common unzip bzip2 ncurses-dev  zlib1g-dev libbz2-dev liblzma-dev && apt-get clean



  ##### Install Java.
RUN \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java8-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer
  
  
   ##### Install PICARD TOOLS

WORKDIR /opt

RUN git clone --depth 1 https://github.com/broadinstitute/picard.git /opt/picard && \
    cd /opt/picard && \
    ./gradlew shadowJar

# Cleanup
RUN rm -rf /tmp/picard-tools-*


#Install GATK


RUN wget https://github.com/broadinstitute/gatk/releases/download/4.1.1.0/gatk-4.1.1.0.zip && unzip gatk-4.1.1.0.zip 

ENV PATH="/opt/gatk-4.1.1.0:${PATH}"

#Install Samtools

RUN wget https://github.com/samtools/samtools/releases/download/1.9/samtools-1.9.tar.bz2 &&  tar -jxvf samtools-1.9.tar.bz2 && cd samtools-1.9 &&  ./configure --prefix=/opt && make && make install 

ENV PATH="/opt/samtools-1.9:${PATH}"

#Install BWA

RUN apt-get update
RUN apt-get install -y bwa

