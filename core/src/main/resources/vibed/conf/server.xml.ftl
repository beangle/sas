[#ftl]
<?xml version="1.0" encoding="UTF-8"?>
<Server ips="[#list ips as ip]${ip}[#if ip_has_next],[/#if][/#list]" port="${server.http}" >
   [#list webapps as webapp]
   <Context path="${webapp.contextPath}"/>
   [/#list]
</Server>
