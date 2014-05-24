import play.api._
import play.api.mvc._
import collection.mutable.HashMap
import play.api.libs.json._
import java.io._
import com.redis._

package object Global extends GlobalSettings {

  val themes:HashMap[String,String] = HashMap(
    "default" -> "theme.default",
    "pink" -> "theme.pink",
    "amelia" -> "theme.amelia",
    "ubuntu" -> "theme.ubuntu",
    "yeti" -> "theme.yeti",
    "slate" -> "theme.slate",
    "black" -> "theme.black",
    "white" -> "theme.white"
    )

  def currentPath = new java.io.File( "." ).getCanonicalPath

  def getSettings():JsValue = {
  	var result: JsValue = Json.parse(scala.io.Source.fromFile(new File(currentPath, "settings.json")).mkString)
  	return result
  }
}


import org.joda.time._
import org.joda.time.format._
import anorm._

object AnormExtension {


  val dateFormatGeneration: DateTimeFormatter = DateTimeFormat.forPattern("yyyyMMddHHmmssSS");

  implicit def rowToDateTime: Column[DateTime] = Column.nonNull { (value, meta) =>
    val MetaDataItem(qualified, nullable, clazz) = meta
    value match {
      case ts: java.sql.Timestamp => Right(new DateTime(ts.getTime))
      case d: java.sql.Date => Right(new DateTime(d.getTime))
      case str: java.lang.String => Right(dateFormatGeneration.parseDateTime(str))  
      case _ => Left(TypeDoesNotMatch("Cannot convert " + value + ":" + value.asInstanceOf[AnyRef].getClass) )
    }
  }

  implicit val dateTimeToStatement = new ToStatement[DateTime] {
    def set(s: java.sql.PreparedStatement, index: Int, aValue: DateTime): Unit = {
      s.setTimestamp(index, new java.sql.Timestamp(aValue.withMillisOfSecond(0).getMillis()) )
    }
  }

}