import sbt.*
import scala.collection.mutable

def newLocation(f: File, newBase: String): String = {
  val path = f.getAbsolutePath
  newBase + path.substring(path.indexOf("classes") + "classes".length)
}

def relocate(f: File, newBase: String, converter: FileConverter): Seq[(HashedVirtualFileRef, String)] = {
  val buf = new mutable.ArrayBuffer[(HashedVirtualFileRef, String)]
  if (f.getName != "META-INF") {
    buf += (converter.toVirtualFile(f.toPath) -> newLocation(f, newBase))
    val fc = f.listFiles()
    if (fc != null) {
      fc foreach { fi => buf ++= relocate(fi, newBase, converter) }
    }
  }
  buf.toSeq
}

Compile / packageBin / mappings := {
  val converter = fileConverter.value
  val newBase = "beangle-sas-" + version.value
  val resFiles = (Compile / resources).value
  val resDir = (Compile / resourceDirectory).value
  val resourcesMapping = resFiles.map { f =>
    val rel = f.relativeTo(resDir).getOrElse(f.getName).toString
    converter.toVirtualFile(f.toPath) -> s"$newBase/$rel"
  }
  // copyResources 会把 resources 同步进 classDirectory，若整个 classDirectory 递归打包，
  // 同名条目会出现两次，压缩时报 duplicate entry（如 bin/env.sh）。此处让 resources 映射优先。
  val resourcePaths = resourcesMapping.iterator.map(_._2).toSet
  val classesMapping = relocate((Compile / classDirectory).value, newBase, converter)
    .filterNot { case (_, path) => resourcePaths.contains(path) }
  classesMapping ++ resourcesMapping
}
