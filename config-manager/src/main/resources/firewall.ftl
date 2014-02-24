[#ftl/]
<?xml version="1.0" encoding="utf-8"?>
<zone>
  <short>Public</short>
[#list ports as port]
  <port protocol="tcp" port="${port}"/>
[/#list]
</zone>
