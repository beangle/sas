[#ftl]
<?xml version='1.0' encoding='utf-8'?>
<Sas>
[#t/]
[#if container.repository?? && (container.repository.local?? || container.repository.remote??)]
  <Repository [#if container.repository.local??]local="${container.repository.local}"[/#if] [#if container.repository.remote??]remote="${container.repository.remote}"[/#if]/>
[/#if]

  <Engines>
  [#list container.engines as engine]
    <Engine name="${engine.name}" type="${engine.typ}" version="${engine.version}">
    [#list engine.listeners as listener]
      <Listener className="${listener.className}" [@spawnProps listener/]/>
    [/#list]

    [#if engine.context??]
      [#assign ctx = engine.context/]
      <Context>
        [#if ctx.loader??]
        <Loader className="${ctx.loader.className}" [@spawnProps ctx.loader /]/>
        [/#if]
        [#if ctx.jarScanner??]
        <JarScanner [@spawnProps ctx.jarScanner /]/>
        [/#if]
      </Context>
    [/#if]
    </Engine>
  [/#list]
  </Engines>

  <Hosts>
  [#list container.hosts as host]
    <Host name="${host.name}" ip="${host.ip}" [#if host.comment??]comment="${host.comment}"[/#if]/>
  [/#list]
  </Hosts>

  <Farms>
  [#list container.farms as farm]
    <Farm name="${farm.name}" engine="${farm.engine.name}">
    [#if farm.jvmopts??]
      <JvmArgs opts="${farm.jvmopts}"/>
    [/#if]
  [#t/]
  [@displayConnector farm/]
      [#list farm.servers as server]
      <Server name="${server.name}" http="${server.http}"/>
      [/#list]
    </Farm>
  [/#list]
  </Farms>

  <Resources>
 [#list container.resources?keys as r]
    <Resource  name="${r}"  [@spawnProps container.resources[r] /] />
 [/#list]
  </Resources>

  <Webapps>
    [#list container.webapps as webapp]
    <Webapp name="${webapp.name}" reloadable="${webapp.reloadable?c}" [#if webapp.docBase??]docBase="${webapp.docBase}"[/#if] [#rt/]
    [#lt/] [#list webapp.properties?keys as p] ${p}="${webapp.properties[p]}"[/#list]>
      [#list webapp.resources as resource]
      <ResourceRef ref="${resource.name}" type="${resource.type}"/>
      [/#list]
      ${webapp.realms!}
    </Webapp>
    [/#list]
  </Webapps>

  <Deployments>
  [#list container.deployments as deployment]
    <Deployment webapp="${deployment.webapp}" on="${deployment.on}" path="${deployment.path}"  />
  [/#list]
  </Deployments>
</Sas>
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
[/#macro]
[#-- display object properties--]
[#macro spawnProps obj][#list obj.properties?keys as k] ${k}="${obj.properties[k]}" [/#list][/#macro]