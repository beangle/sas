[#ftl]
<?xml version='1.0' encoding='utf-8'?>
<tomcat version="${config.version}">
[#list config.farms as farm]
  <farm name="${farm.name}" >
[#if farm.jvmopts??]
    <jvm opts="${farm.jvmopts}"/>
[/#if]

    [#assign http=farm.http/]
    <http URIEncoding="${http.URIEncoding}" enableLookups="${http.enableLookups?c}" disableUploadTimeout="${http.disableUploadTimeout?c}"
          maxThreads="${http.maxThreads}"  minSpareThreads="${http.minSpareThreads}" 
          acceptCount="${http.acceptCount}" connectionTimeout="${http.connectionTimeout}" [#if http.maxConnections??]maxConnections="${http.maxConnections}"[/#if] [#rt/]
[#if http.compression!="off"]
          compression="${http.compression}" compressionMinSize="${http.compressionMinSize}" compressableMimeType="${http.compressionMimeType}"[#rt/]
[/#if]
      />[#lt/]

[#if farm.ajp??]
[#assign ajp= farm.ajp]
    <ajp URIEncoding="${http.URIEncoding}" enableLookups="${http.enableLookups?c}"
         maxThreads="${http.maxThreads}" minSpareThreads="${http.minSpareThreads}"
         acceptCount="${http.acceptCount}" [#if http.maxConnections??]maxConnections="${http.maxConnections}"[/#if]/>
[/#if]

    [#list farm.servers as server]
    <server name="${server.name}" shutdownPort="${server.shutdownPort}" [#if server.httpPort>0] httpPort="${server.httpPort}"[/#if] [#if server.httpsPort>0] httpsPort="${server.httpsPort}"[/#if] [#if server.ajpPort>0] ajpPort="${server.ajpPort}"[/#if]/>
    [/#list]
  </farm>
[/#list]

  <webapp docBase="${config.webapp.docBase}">
    [#list config.webapp.contexts as context]
    <context path="${context.path}"  reloadable="${context.reloadable?c}" runAt="${context.runAt}">
      [#list context.dataSources as resource]
      <datasource name="${resource.name}" url="${resource.url}" driver="${resource.driver}" username="${resource.username}"   [#list resource.properties?keys as p] ${p}="${resource.properties[p]}"[/#list]/>
      [/#list]
    </context>
    [/#list]
  </webapp>
</tomcat>