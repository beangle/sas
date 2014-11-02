### Install Beangle Tomcat Server

    wget https://raw.githubusercontent.com/beangle/tomcat/master/server/src/main/resources/netinstall.sh;\
    chmod +x ./netinstall.sh;\
    netinstall.sh 0.1.0

### Get scala and postgresql libararies

  bin/get-pg-driver.sh
  bin/get-scala.sh 2.11.2

### Install and Update Tomcat

1. install tomcat 8.0.3

     bin/install 8.0.3

2. update tomcat to version 8.0.14

     bin/update 8.0.14
