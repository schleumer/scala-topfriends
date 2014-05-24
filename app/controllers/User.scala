package controllers

import play.api.mvc._
import sch._
import sch.utils._
import sch.json.UserReader._
import scala.concurrent._
import scala.concurrent.duration._
import play.api.libs.ws.WS
import ExecutionContext.Implicits.global
import play.api.libs.json._


object User extends Controller with LollipopHelper {


  def status = Action.async { implicit req =>
    var token: String = req.getQueryString("token").getOrElse("")
    val facebook = new Facebook(token)
    val settings = Global.getSettings()
    var user: JsObject = Json.obj()
    var permissions: JsObject = Json.obj()

    val extend: Future[String] = WS.url("https://graph.facebook.com/oauth/access_token?grant_type=fb_exchange_token&client_id=" + (settings \ "app_id").as[String] + "&client_secret=" + (settings \ "app_secret").as[String] + "&fb_exchange_token=" + token).get() map { res =>
      if (res.body.matches(".*access_token=.*")) {
        ".*access_token=(.*?)&".r.findAllIn(res.body).matchData foreach { m =>
          token = m.group(1)
        }
      }
      res.body
    }

    val justAnotherFuture = extend.map { fres =>
      val futureOfTheWorld: Future[JsObject] = facebook.get("/me") map { r: JsObject =>
        user = r
        user
      }

      val finalCountdown: Future[JsObject] = facebook.get("/me/permissions") map { r =>
        permissions = (r \ "data")(0).as[JsObject]
        permissions
      }

      val fainal: Future[SimpleResult] = Future.sequence(List(extend, futureOfTheWorld, finalCountdown)) map { gay =>
        val json = Json.obj("data" -> (user ++ Json.obj("permissions" -> permissions)))

        lollipop.session << ("token" -> Json.toJson(token))


        lollipop.session << (
          "user" -> json \ "data"
          )

        lollipop.ok(Json.prettyPrint(json))
      }
      fainal
    }

    Await.result(justAnotherFuture, Duration.Inf)
  }

  def logout = Action { implicit req =>
    lollipop.session.kill()
    Redirect("/")
  }

  def delete = Action.async { implicit req =>
    val facebook = new Facebook(req.session.get("token").getOrElse(""))

    val futureOfTheWorld: Future[SimpleResult] = facebook.get("/me") map { r =>
      val json: JsValue = Json.obj(
        "data" -> r
      )
      Ok(json)
    }

    futureOfTheWorld
  }

}