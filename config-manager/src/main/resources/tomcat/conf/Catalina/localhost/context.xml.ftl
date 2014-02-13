[#ftl/]
<?xml version='1.0' encoding='utf-8'?>
<Context path="${context.path}" reloadable="${context.reloadable?c}">
[#list context.dataSources as resource]
<Resource 
  name="${resource.name}"
  factory="org.beangle.tomcat.jdbc.EncryptedDataSourceFactory"
  driverClassName="${resource.driverClassName}"
  url="${resource.url}"
  type="javax.sql.DataSource"
  username="${resource.username}"
  password="${resource.password}"
  />
[/#list]
</Context>
