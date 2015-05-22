[#ftl]
<?xml version='1.0' encoding='utf-8'?>
<Tomcat version="${container.version}">
[#t/]
[#list container.listeners as listener]
  <Listener className="${listener.className}" [@spawnProps listener/]/>
[/#list]

[#if container.context??]
  [#assign ctx = container.context/]
  <Context>
    [#if ctx.loader??]
    <Loader className="${ctx.loader.className}" [@spawnProps ctx.loader /]/>
    [/#if]
    [#if ctx.jarScanner??]
    <JarScanner [@spawnProps ctx.jarScanner /]/>
    [/#if]
  </Context>
[/#if]

[#list container.farms as farm]
  <Farm[#if farm.name?exists && farm.name?length>0] name="${farm.name}"[/#if]>
[#if farm.jvmopts??]
    <JvmArgs opts="${farm.jvmopts}"/>
[/#if]
[#t/]
[@displayConnector farm/]
    [#list farm.servers as server]
    <Server name="${server.name}" shutdown="${server.shutdownPort}" [#if server.httpPort>0] http="${server.httpPort}"[/#if] [#if server.httpsPort>0] https="${server.httpsPort}"[/#if] [#if server.ajpPort>0] ajp="${server.ajpPort}"[/#if]/>
    [/#list]
  </Farm>
[/#list]

  <Webapps>
    [#list container.webapps as webapp]
    <Webapp name="${webapp.name}" reloadable="${webapp.reloadable?c}" [#if webapp.docBase??]docBase="${webapp.docBase}"[/#if]>
      [#list webapp.resources as resource]
      <ResourceRef ref="${resource.name}"/>
      [/#list]
    </Webapp>
    [/#list]
  </Webapps>

[#if container.resources?size>0]
  <Resources>
 [#list container.resources?keys as r]
    <Resource  name="${r}"  [@spawnProps container.resources[r] /] />
 [/#list]
  </Resources>
[/#if]

[#if container.deployments?size>0]
  <Deployments>
  [#list container.deployments as deployment]
    <Deployment webapp="${deployment.webapp}" on="${deployment.on}" path="${deployment.path}"  />
  [/#list]
  </Deployments>
[/#if]
</Tomcat>
[#-- display connector--]
[#macro displayConnector holder]
[#if holder.http??]
[#assign http=holder.http/]
    <HttpConnector protocol="HTTP/1.1" URIEncoding="${http.URIEncoding}" enableLookups="${http.enableLookups?c}" disableUploadTimeout="${http.disableUploadTimeout?c}"
      maxThreads="${http.maxThreads}"  minSpareThreads="${http.minSpareThreads}" 
      acceptCount="${http.acceptCount}" connectionTimeout="${http.connectionTimeout}" [#if http.maxConnections??]maxConnections="${http.maxConnections}"[/#if] [#rt/]
 [#if http.compression!="off"]
      compression="${http.compression}" compressionMinSize="${http.compressionMinSize}" compressableMimeType="${http.compressionMimeType}"[#rt/]
 [/#if]
  />[#lt/]
[/#if]
[#if holder.ajp??]
[#assign ajp= farm.ajp]
<AjpConnector protocol="AJP/1.3" URIEncoding="${http.URIEncoding}" enableLookups="${http.enableLookups?c}"
     maxThreads="${http.maxThreads}" minSpareThreads="${http.minSpareThreads}"
     acceptCount="${http.acceptCount}" [#if http.maxConnections??]maxConnections="${http.maxConnections}"[/#if]/>
[/#if]
[/#macro]
[#-- display object properties--]
[#macro spawnProps obj][#list obj.properties?keys as k] ${k}="${obj.properties[k]}" [/#list][/#macro]