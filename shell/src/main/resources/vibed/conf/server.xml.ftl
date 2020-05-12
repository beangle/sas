[#ftl]
<?xml version="1.0" encoding="UTF-8"?>
<Server hosts="[#list ips as ip]${ip}[#if ip_has_next],[/#if][/#list]" port="${server.http}" >
   [#list deployments as deployment]
   <Context path="${deployment.path}"/>
   [/#list]
</Server>
