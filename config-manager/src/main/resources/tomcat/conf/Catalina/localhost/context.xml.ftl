[#ftl/]
<?xml version='1.0' encoding='utf-8'?>
<Context path="${context.path}" reloadable="${context.reloadable?c}" privileged="true"  debug="0">
[#list context.dataSources as resource]
<Resource 
  name="${resource.name}"
  factory="org.beangle.tomcat.jdbc.EncryptedDataSourceFactory"
  driverClassName="${resource.driverClassName}"
  url="${resource.url}"
  type="javax.sql.DataSource"
  username="${resource.username}"
  password="${resource.password}"
  [#list resource.properties?keys as p]
  ${p}="${resource.properties[p]}"
  [/#list]
  />
[/#list]
</Context>
