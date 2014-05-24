package sch;

import java.io._
import scala.sys.process._
import play._

object Drawer {
	def apply(html: String): String = {
		val tempFile:File = File.createTempFile("facebook-topchat-", "-image.html")
		val fw:FileWriter = new FileWriter(tempFile)
		fw.write(html)
		fw.close()

		try { 
			val root = new File(Play.application().path().getAbsolutePath())
			val public = new File(root, "public")
			val publicVault = new File(public, "vault")
			val publicImages = new File(publicVault, "images")
			if(!publicImages.exists()){
				publicImages.mkdirs()	
			}
			val targetPath = new File(publicImages, java.util.UUID.randomUUID().toString() + ".png")
			val script = new File(new File(root, "scripts"), "rasterize.js").getPath()
			val command = Seq("phantomjs", "--ignore-ssl-errors=yes", "--disk-cache=true", script, "file:///" + tempFile.getPath(), targetPath.getPath())
			println(command.lines)
		} catch {
			case e: Exception => println(e)
		}
		"http://placekitten.com/g/200/300"
	}
}