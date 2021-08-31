import scala.collection.mutable

def newLocation(f: File, newBase: String): String = {
  val path = f.getAbsolutePath
  newBase + path.substring(path.indexOf("classes") + "classes".length)
}

def relocate(f: File, newBase: String): Seq[(File, String)] = {
  val buf = new mutable.ArrayBuffer[(File, String)]
  buf += (f -> newLocation(f, newBase))
  val fc = f.listFiles()
  if (fc != null) {
    fc foreach { fi => buf ++= relocate(fi, newBase) }
  }
  buf
}

Compile / packageBin / mappings := relocate(target.value / "classes", "beangle-sas-"+version.value)
