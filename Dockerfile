FROM ubuntu:15.04
MAINTAINER John Oram <john@oram.ca>

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

RUN apt-get -y update
RUN apt-get -y upgrade
ADD requirements_apt.txt /requirements_apt.txt

#########
# create user/password/db:
#  - tp_user
#  - tp_password
#  - tp_database
#########
USER postgres
RUN service postgresql start && psql --command "CREATE USER tp_user WITH SUPERUSER PASSWORD 'tp_password';" && createdb -O tp_user tp_database

EXPOSE 6543
CMD service postgresql start

