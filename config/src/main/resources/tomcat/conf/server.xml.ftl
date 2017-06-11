[#ftl]
<?xml version='1.0' encoding='utf-8'?>
<Server port="-1" shutdown="SHUTDOWN">
  [#list farm.engine.listeners as listener]
  <Listener className="${listener.className}" [#list listener.properties?keys as k]${k}="${listener.properties[k]}"[/#list]/>
  [/#list]

  [#if container.resourceNames?size >0 ]
  <GlobalNamingResources>
  [#list container.farmResourceNames(farm)?sort as resourceName]
    [#assign resource=container.resources[resourceName]/]
    <Resource name="${resource.name}"
      [#list resource.properties?keys as p]
      ${p}="${resource.properties[p]}"
      [/#list]
    />
 [/#list]
  </GlobalNamingResources>
 [/#if]

  <Service name="Catalina">
    [#assign http=farm.http/]
    <Connector port="${server.http}" protocol="HTTP/1.1"
      URIEncoding="${http.URIEncoding}"
      enableLookups="${http.enableLookups?c}"
      [#if http.acceptCount??]
      acceptCount="${http.acceptCount}"
      [/#if]
      maxThreads="${http.maxThreads}"
      minSpareThreads="${http.minSpareThreads}"
      connectionTimeout="${http.connectionTimeout}"
      disableUploadTimeout="${http.disableUploadTimeout?c}"
      [#if http.compression!="off"]
      compression="${http.compression}"
      compressionMinSize="${http.compressionMinSize}"
      compressableMimeType="${http.compressionMimeType}"
      [#else]
      compression="off"
      [/#if]
      />

    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="false">
      [#list container.deployments as deployment]
      [#if deployment.matches(server.qualifiedName)]
      [#list container.webapps as webapp]
      [#if webapp.name == deployment.webapp]
      <Context path="${deployment.path}" reloadable="${webapp.reloadable?c}" swallowOutput="true"[#rt/]
      [#lt/] docBase="${webapp.docBase}"[#rt/]
      [#lt/][#list webapp.properties?keys as p] ${p}="${webapp.properties[p]}"[/#list]>
        [#list webapp.resources as resource]
        <ResourceLink name="${resource.name}" global="${resource.name}" type="${resource.type}" />
        [/#list]
        [#if farm.engine.context??]
        [#assign ctx=farm.engine.context/]
        [#if ctx.jarScanner??]<JarScanner [@spawnProps ctx.jarScanner/]/>[/#if]
        [#if ctx.loader??]<Loader className="${ctx.loader.className}" [@spawnProps ctx.loader/]/>[/#if]
        [/#if]
        ${webapp.realms!}
        </Context>
       [/#if]
       [/#list]
       [/#if]
       [/#list]
      </Host>
    </Engine>
  </Service>
</Server>
[#-- display object properties--]
[#macro spawnProps obj][#list obj.properties?keys as k] ${k}="${obj.properties[k]}" [/#list][/#macro]
