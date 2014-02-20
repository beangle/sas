[#ftl]
<?xml version='1.0' encoding='utf-8'?>
<Server port="${server.shutdownPort}" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="off" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <Service name="Catalina">
    [#if farm.http??]
    [#assign http=farm.http/]
    <Connector port="${server.httpPort}" protocol="HTTP/1.1"
      URIEncoding="${http.URIEncoding}"
      enableLookups="${http.enableLookups?c}"
      [#if http.redirectPort??]redirectPort="${http.redirectPort}"[/#if]
      [#t/]
      acceptCount="${http.acceptCount}"
      maxThreads="${http.maxThreads}"
      minSpareThreads="${http.minSpareThreads}"
      [#if http.redirectPort??]redirectPort="${http.redirectPort}"[/#if]
      [#t/]
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
    [/#if]

    [#if farm.ajp??]
    <Connector port="${server.ajpPort}" protocol="AJP/1.3"
      URIEncoding="${http.URIEncoding}"
      enableLookups="${http.enableLookups?c}"
      [#if http.redirectPort??]redirectPort="${http.redirectPort}"[/#if]
      
      acceptCount="${http.acceptCount}"
      maxThreads="${http.maxThreads}"
      minSpareThreads="${http.minSpareThreads}"
      [#if http.redirectPort??]redirectPort="${http.redirectPort}"[/#if]
      />
    [/#if]
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="${container.webapp.base}" unpackWARs="true" autoDeploy="true">
    </Engine>
  </Service>
</Server>
