package controllers.facebook

import sch._
import sch.utils.{Taskable, LollipopHelper}

import play.api.mvc._
import play.api.libs.Comet
import play.api.libs.json._
import play.api.libs.ws.WS
import scala.concurrent._
import ExecutionContext.Implicits.global
import play.api.templates.Html
import scala.concurrent.duration._
import scala.async.Async.{async, await}

object Topchat extends Controller with LollipopHelper {

	def js(data: (String, String)):Option[String] = {
		Some(Json.stringify(Json.obj("type" -> data._1, "message" -> data._2)))
	} 

	def comet(cbFn: String) = Action { implicit req =>

		if(!lollipop.session.has("token")){
			Ok(Html("<html><body><script type=\"text/javascript\">console.log('merda');" + s"top.cb.${cbFn}('" + js(("die", "Você precisa estar logado para acessar essa área!")).getOrElse("") + "')</script></body></html>"))
		} else {
			val facebook = new Facebook(lollipop.session.get("token").as[String])
			
			var messages = Json.arr()
			var usersIds:List[Long] = List[Long]()
			var myId:Long = 0
			var myFriends:JsValue = Json.obj()

			val taskTable = Taskable.TaskStack(
				() => {
					Future[Option[String]] {
						js(("status", "Carregando..."))
					}
				},
				() => {
					Future[Option[String]] {
						val promised = Promise[Option[String]]()
						
						val req = facebook.fql("SELECT uid FROM user WHERE uid = me()")
						
						
						req map { r =>
							myId = (r(0) \ "uid").as[Long]
							promised.success(js("status", "Oi"))
							true
						}

						req onFailure {
							case e => promised.failure(new Exception("Eeeeeeepa, algum erro aconteceu."))
						}
						
						val fuckingFuture: Future[Option[String]] = promised.future.map { res =>
							res
						}

						Await.result(fuckingFuture, Duration.Inf)
					}
				},
				() => {
					Future[Option[String]] {
						js(("status", "Contando suas mensagens..."))
					}
				},
				() => {
					Future[Option[String]] {
						val promised = Promise[Option[String]]()
						val req = facebook.fql("SELECT object_id, thread_id, subject, recipients, message_count, updated_time FROM thread WHERE folder_id = 0 ORDER BY message_count DESC") 
						val nearFuture: Future[Boolean] = req map { r =>
							messages = r
							messages.as[List[JsObject]].map { message =>
								val recips = (message \ "recipients").as[List[Long]]
								recips.map { recip =>
									usersIds = recip :: usersIds
									recip
								}
								message
							}
							promised.success(js("status", "Oi"))
							true
						}
						
						val fuckingFuture: Future[Option[String]] = promised.future.map { res =>
							res
						}

						Await.result(fuckingFuture, Duration.Inf)
					}
				},
				() => {
					Future[Option[String]] {
						js(("status", "Procurando as pessoas com quem você conversou..."))
					}
				},
				() => {
					async {
						val promised = Promise[Option[String]]()
						WS.url("http://graph.facebook.com/?ids=" + usersIds.mkString(",")).get map { res =>
							myFriends = res.json
							promised.success(js("status", "Amigos Carregados..."))
						}
						await(promised.future)
					}
				},
				() => {
					Future[Option[String]] {
						js(("status", "Fazendo as continhas"))
					}
				},
				() => {
					Future[Option[String]] {
						var treta = messages.as[List[JsObject]].filter { message =>
							val participant_id = ( message \ "recipients" ).as[List[Long]].filter { p =>
								p != myId
							}.head
							( message \ "recipients" ).as[List[Long]].length < 3 && !(myFriends \ participant_id.toString).isInstanceOf[JsUndefined]
						}
						treta = treta.map { message =>
							var userOfThread = None
							
							val participant_id = ( message \ "recipients" ).as[List[Long]].filter { p =>
								p != myId
							}.head
							
							val participant = myFriends \ participant_id.toString

							message ++ Json.obj(
								"participant" -> participant,
								"participant_id" -> participant_id
							)
						}

						lollipop.session << (
							"facebook_topchat" -> Json.toJson(treta)
						)


						js(("threads", Json.stringify(Json.toJson(treta))))
					}
				}
			)

			val tasks = Taskable.Tasks(taskTable)

	  		Ok.chunked(tasks &> Comet(callback = s"top.cb.$cbFn"))
	  	}
	}

	def generate(cbFn: String) = Action { implicit req =>
		

		if(!lollipop.session.has("facebook_topchat") || !lollipop.session.has("token")){
			Ok(Html("<html><body><script type=\"text/javascript\">" + s"top.cb.$cbFn('" + js(("die", "Você não deveria estar aqui, tente novamente!")).getOrElse("") + "')</script></body></html>"))
		} else {
			val facebook = new Facebook(lollipop.session.get("token").as[String])
			val data = lollipop.session.get("facebook_topchat")
			var imageUrl = ""

			val taskTable = Taskable.TaskStack(
				Taskable.Task {
					js(("status", "Desenhando as parada toda..."))
				},
				Taskable.Task {
					try { 
						val html = views.html.facebook.topchat.image(data.as[List[JsObject]])
						println(html.body)
						imageUrl = Drawer(html.body)						
					} catch {
						case e: Exception => println(e)
					}
					js(("status", "Salvando uma cópia..."))
				},
				Taskable.Task {
					/*var q = SQL("INSERT INTO images VALUES({uuid}, '{}', {date}, NULL)").on(
							"uuid" -> uuid, 
							"date" -> DateTime.now.toString("yyyy-MM-dd HH:mm:ss")
						).execute()*/
					js(("status", "Salvando uma cópia..."))
				}
			)

			val tasks = Taskable.Tasks(taskTable)

	  		Ok.chunked(tasks &> Comet(callback = s"top.cb.$cbFn"))
	  	}
	}

}