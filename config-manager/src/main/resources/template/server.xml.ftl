<?xml version='1.0' encoding='utf-8'?>
<Server port="${server.shutdownPort}" shutdown="SHUTDOWN">
  <Listener className="org.apache.catalina.core.AprLifecycleListener" SSLEngine="off" />
  <Listener className="org.apache.catalina.core.JasperListener" />
  <Listener className="org.apache.catalina.core.JreMemoryLeakPreventionListener" />
  <Listener className="org.apache.catalina.mbeans.GlobalResourcesLifecycleListener" />
  <Listener className="org.apache.catalina.core.ThreadLocalLeakPreventionListener" />

  <Service name="Catalina">
    <Connector port="${connector.port}" protocol="HTTP/1.1"
      acceptCount="${connector.acceptCount}"
      maxThreads="${connector.maxThreads}"
      processorCache="${connector.processorCache}"
      connectionTimeout="${connector.timeout}"
      minSpareThreads="${connector.minSpareThreads}"
      disableUploadTimeout="false"
      URIEncoding="utf-8"
      enableLookups="false"
      [#if connector.compression!="off"]
      compression="${connector.compression}" 
      compressionMinSize="${connector.compressionMinSize}"
      compressableMimeType="${connector.compressionMimeType}"
      [/#if]
      />
    <Engine name="Catalina" defaultHost="localhost">
      <Host name="localhost" appBase="webapps" unpackWARs="true" autoDeploy="true">
    </Engine>
  </Service>
</Server>
