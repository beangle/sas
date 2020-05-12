[#ftl]
<?xml version="1.0" encoding="UTF-8"?>
<Server port="-1" shutdown="SHUTDOWN">
[#list farm.engine.listeners as listener]
  <Listener className="${listener.className}" [#list listener.properties?keys as k]${k}="${listener.properties[k]}"[/#list]/>
[/#list]
[#t/]
[#if container.resourceNames?size >0 ]
  <GlobalNamingResources>
  [#list container.farmResourceNames(farm)?sort as resourceName]
    [#assign resource=container.resources[resourceName]/]
    <Resource name="${resource.name}" [#list resource.properties?keys as p] ${p}="${resource.properties[p]}"[/#list]/>
 [/#list]
  </GlobalNamingResources>
[/#if]
[#t/]
  <Service name="Catalina">
    [#if server.http>0 && farm.http??]
    [#assign http=farm.http/]
    <Connector port="${server.http}" protocol="HTTP/1.1"
      URIEncoding="${http.URIEncoding}" enableLookups="${http.enableLookups?c}" [#if http.acceptCount??]acceptCount="${http.acceptCount}"[/#if]
      maxThreads="${http.maxThreads}" minSpareThreads="${http.minSpareThreads}" connectionTimeout="${http.connectionTimeout}"
      [#if http.compression!="off"]
      compression="${http.compression}" compressionMinSize="${http.compressionMinSize}" compressableMimeType="${http.compressionMimeType}"
      [#else]
      compression="off"
      [/#if]
      disableUploadTimeout="${http.disableUploadTimeout?c}"/>
    [/#if]
    [#if server.http2>0 && farm.http2??]
    [#assign http=farm.http2/]
    <Connector port="${server.http2}" protocol="org.apache.coyote.http11.Http11AprProtocol"
      URIEncoding="${http.URIEncoding}" SSLEnabled="true" enableLookups="${http.enableLookups?c}"
      [#if http.acceptCount??]acceptCount="${http.acceptCount}"[/#if] maxThreads="${http.maxThreads}"
      minSpareThreads="${http.minSpareThreads}" connectionTimeout="${http.connectionTimeout}" disableUploadTimeout="${http.disableUploadTimeout?c}"
      [#if http.compression!="off"]
      compression="${http.compression}" compressionMinSize="${http.compressionMinSize}" compressableMimeType="${http.compressionMimeType}"
      [#else]compression="off"[/#if]>
      <UpgradeProtocol className="org.apache.coyote.http2.Http2Protocol" />
      <SSLHostConfig>
         <Certificate certificateKeyFile="${http.caKeyFile}" certificateFile="${http.caFile}" />
      </SSLHostConfig>
    </Connector>
    [/#if]
[#t/]
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" unpackWARs="true" startStopThreads="0" autoDeploy="false" errorReportValveClass="org.beangle.sas.tomcat.SwallowErrorValve">
      [#if server.enableAccessLog]
        <Valve className="ch.qos.logback.access.tomcat.LogbackValve" quiet="true" filename="conf/logback-access.xml"/>
      [/#if]
[#t/]
      [#list deployments as deployment]
        [#assign webapp=container.getWebapp(deployment.webapp)/]
[#t/]
        [#assign containerSciFilter=webapp.getContainerSciFilter(farm.engine)!""/]
        <Context path="${deployment.path}" [#if containerSciFilter?length>0]containerSciFilter="${containerSciFilter}"[/#if]  [#if !((deployment.unpack)!true)]unpackWAR="false"[/#if] [#if deployment.reloadable]reloadable="true"[/#if] [#rt/]
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
          ${webapp.realms!}[#t/]
        </Context>
    [/#list]
      </Host>
    </Engine>
  </Service>
</Server>
[#-- display object properties--]
[#macro spawnProps obj][#list obj.properties?keys as k]${k}="${obj.properties[k]}" [/#list][/#macro]
