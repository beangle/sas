[#ftl/]
PRG="$0"
PRGDIR=`dirname "$PRG"`
export JAVA_HOME=`cd "$PRGDIR/../../jdk" >/dev/null; pwd`
[#if farm.jvmopts??]JAVA_OPTS="${farm.jvmopts}"[/#if]