FROM ubuntu:16.04
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update && apt-get -y dist-upgrade
RUN apt-get install -y mysql-client python3 curl
ENTRYPOINT ["sh", "/sql/import.sh"]
