package sch
import play.api.libs.json._
import scala.concurrent._
import play.api.libs.ws.WS
import ExecutionContext.Implicits.global
import com.netaporter.uri.dsl._
import scala.async.Async.{async, await}	

class Facebook(access_token: String = "") {

	def getGraphUrl(path: String = ""): String = {
		val settings = Global.getSettings()

		return "https://graph.facebook.com" + path ? ("access_token" -> this.access_token)
	}

	def get(what: String): Future[JsObject] = {
		val futureOfRequest = WS.url(this.getGraphUrl(what)).get()
		val futureOfResponse:Future[JsObject] = futureOfRequest.map { res =>
			res.json.as[JsObject]
		}
		futureOfResponse
	}

	def fql(query: String): Future[JsArray] = {
		val futureOfRequest = WS.url(this.getGraphUrl("/fql") ? ("q" -> query) ).get()
		val futureOfResponse:Future[JsArray] = futureOfRequest.map { res =>
			if(!(res.json \ "error").isInstanceOf[JsUndefined]) {
				println(res.body)
				throw new Exception("Error on fetch facebook data")
			} else {
				(res.json \ "data").as[JsArray]	
			}
		}
		futureOfResponse
	}
}