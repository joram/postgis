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
RUN apt-cache search postgres

#########
# create user/password/db:
#  - tp_user
#  - tp_password
#  - tp_database
#########
USER postgres
RUN service postgresql start && psql --command "CREATE USER tp_user WITH SUPERUSER PASSWORD 'tp_password';" && createdb -O tp_user tp_database

EXPOSE 5432
#CMD ["service", "postgresql", "start"]
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]
