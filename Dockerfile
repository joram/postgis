FROM ubuntu:15.10
MAINTAINER John Oram <john@oram.ca>

RUN locale-gen --no-purge en_US.UTF-8
ENV LC_ALL en_US.UTF-8
RUN update-locale LANG=en_US.UTF-8

#########
# install all aptitude packages
#########
RUN apt-get -y update
RUN apt-get -y upgrade
ADD requirements_apt.txt /requirements_apt.txt
RUN cat /requirements_apt.txt | xargs apt-get install -y

#########
# create user/password/db:
#  - tp_user
#  - tp_password
#  - tp_database
#########
USER postgres
RUN service postgresql start && psql --command "CREATE USER tp_user WITH SUPERUSER PASSWORD 'tp_password';" && createdb -O tp_user tp_database
RUN touch /var/log/postgresql/error.log

USER root
EXPOSE 5432
COPY ./postgresql.conf /etc/postgresql/9.4/main/postgresql.conf
COPY ./pg_hba.conf /etc/postgresql/9.4/main/pg_hba.conf
CMD service postgresql start && tail -F /var/log/postgresql/error.log
