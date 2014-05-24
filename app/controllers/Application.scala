package controllers

import play.api.mvc._
import play.api.libs.json._
import sch.utils._
import com.github.nscala_time.time.Imports._


object Application extends Controller with LollipopHelper {
	def index = Action { implicit req => 
		lollipop.session << ("sess" -> Json.toJson(DateTime.now))
		//session + ("lel", "haw")
		lollipop.ok(views.html.index())
	}

}