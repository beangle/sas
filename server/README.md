### Install Beangle Tomcat Server

    wget https://raw.githubusercontent.com/beangle/tomcat/master/server/src/main/resources/netinstall.sh;\
    chmod +x ./netinstall.sh;\
    netinstall.sh 0.2.1

### Install and Update Tomcat
0. Init

    bin/init.sh

1. install jar and war

    --install postgresql.9.3-1102-jdbc4 into $base/ext

    bin/install.sh lib org.postgresql postgresql 9.3-1102-jdbc4

2. install tomcat 8.0.3

     bin/install.sh tomcat 8.0.3

3. update tomcat to version 8.0.22

     bin/install.sh tomcat 8.0.22

