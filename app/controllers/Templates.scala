package controllers

import play.api._
import play.api.mvc._
import sch.utils._
import java.lang.reflect.Method

object Templates extends Controller with LollipopHelper {

	def view(file: String) = Action { implicit req => 
		try{
			val clazz: Class[_] = Play.current.classloader.loadClass("views.html.templates." + file.replace('/', '.'))
			val render: Method = clazz.getDeclaredMethod("render")
			val view: play.api.templates.Html = render.invoke(clazz).asInstanceOf[play.api.templates.Html]
			Ok(view)
		} catch {
			case ex: Throwable => Ok("Noooope")
		}
		
	}

}