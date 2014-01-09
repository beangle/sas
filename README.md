tomcat-jdbc-encrypt
===================

#### Beangle-tomcat-jdbc-encrypt原理
通常使用Apache Tomcat(7.0.x),数据源配置会放在$CATALINA_HOME/conf/catalina/localhost/app1.xml,密码会暴露出来。
例如
```
<Resource 
  name="jdbc/app1"
  driverClassName="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@database_server:1521:orcl" 
  type="javax.sql.DataSource"
  username="app1_user_name"
  password="app1_password"
  />
```
通过将配置中的密码改成加密密码，可在一定程度上防止明文密码泄露。beangle-tomcat-jdbc-encrypt中提供了对称加密（AES）方式，
可以基于默认key或者用户输入key产生密码。他实际上是通过继承tomcat的`DataSourceFactory`，并要求在配置中明确声明`  factory="org.beangle.tomcat.jdbc.EncryptedDataSourceFactory"`的方式实现将解密的密码注入到数据源中。

#### 使用步骤

* 下载[beangle-tomcat-jdbc-encrypt.jar](http://search.maven.org/remotecontent?filepath=org/beangle/tomcat/beangle-tomcat-jdbc-encrypt/0.0.1/beangle-tomcat-jdbc-encrypt-0.0.1.jar),放置在$CATALINA_HOME/lib目录下，

* 生成密码

```
# 使用普通的加密密文
java -jar beangle-tomcat-jdbc-encrypt-0.0.1.jar 123456
# 生成自定义key的密文
java -jar beangle-tomcat-jdbc-encrypt-0.0.1.jar 123456 mykey
```
会产生

```
# 第一种情况生成
123456:fd7f189b5c6b7140ca06390b61a06a35
# 第二种情况生成
123456:468eed9cd1d0eb71edd7fbf763cd0ba0
```

这样上述配置可以改为：
```
<Resource 
  name="jdbc/app1"
  factory="org.beangle.tomcat.jdbc.EncryptedDataSourceFactory"
  driverClassName="oracle.jdbc.driver.OracleDriver"
  url="jdbc:oracle:thin:@database_server:1521:orcl" 
  type="javax.sql.DataSource"
  username="app1_user_name"
  password="fd7f189b5c6b7140ca06390b61a06a35"
  <!--或者password="?468eed9cd1d0eb71edd7fbf763cd0ba0"-->
  />
```

* 启动系统

如果采用第一种情况，启动过程和明文密码一样。第二种情况中，password中密码前***多个一个特殊符号?***,意味着要在启动过程中进行输入。
如果使用catalina.sh run时需要在控制台中输入key；采用startup.sh则需要对其进行改造，例如该文件的最后一行前，追加如下内容：
```
echo "What is the data_source_secret key?"
stty -echo
read data_source_secret
stty echo
export data_source_secret
```
