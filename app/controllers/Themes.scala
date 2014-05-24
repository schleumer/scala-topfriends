package controllers

import play.api.mvc._
import sch.utils.LollipopHelper

object Themes extends Controller with LollipopHelper {

  def change(theme: String) = Action { implicit req =>
    Redirect("/").withSession(
      session +("theme", theme)
    )
  }

}