package sch.json

import play.api.libs.json._
import play.api.libs.json.Reads._
import play.api.libs.functional.syntax._

case class User(
                 name: String,
                 email: String,
                 bio: String,
                 first_name: String,
                 last_name: String,
                 username: String,
                 gender: String,
                 permissions: Map[String, Int]
                 ) {
  def hasPermission(permission: String): Boolean = permissions.keySet.contains(permission)
}

object UserReader {
  implicit val userReads: Reads[User] = (
    (__ \ "name").read[String] and
      (__ \ "email").read[String] and
      (__ \ "bio").read[String] and
      (__ \ "first_name").read[String] and
      (__ \ "last_name").read[String] and
      (__ \ "username").read[String] and
      (__ \ "gender").read[String] and
      (__ \ "permissions").read[Map[String, Int]]
    )(User)
}

object UserWriter {
  implicit val userWrites: Writes[User] = (
    (__ \ "name").write[String] and
      (__ \ "email").write[String] and
      (__ \ "bio").write[String] and
      (__ \ "first_name").write[String] and
      (__ \ "last_name").write[String] and
      (__ \ "username").write[String] and
      (__ \ "gender").write[String] and
      (__ \ "permissions").write[Map[String, Int]]
    )(unlift(User.unapply))
}
