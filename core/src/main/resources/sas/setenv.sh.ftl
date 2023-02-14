[#ftl/]
[#if server.farm.engine.typ!='vibed' && server.farm.engine.typ!='any']
SERVER_OPTS="-server -Djava.awt.headless=true -Xmx${server.maxHeapSize} -Djava.security.egd=file:/dev/./urandom ${farm.serverOptions!}"
[#elseif farm.serverOptions??]
SERVER_OPTS="${farm.serverOptions}"
[/#if]
