name := "TopFriends"

version := "1.0-SNAPSHOT"

scalaVersion := "2.11.0"

libraryDependencies ++= Seq(
  jdbc,
  anorm,
  cache,
  "mysql" % "mysql-connector-java" % "5.1.12",
  "com.restfb" % "restfb" % "1.6.14",
  "com.netaporter" %% "scala-uri" % "0.4.1",
  "org.scala-lang.modules" %% "scala-async" % "0.9.1",
  "org.scalautils" % "scalautils_2.10" % "2.1.3",
  "com.github.nscala-time" %% "nscala-time" % "1.0.0",
  "com.kenshoo" %% "metrics-play" % "0.1.3",
  "net.debasishg" % "redisclient_2.10" % "2.12"
)     

play.Project.playScalaSettings

templatesImport += "views.helper._"

templatesImport += "sch._"

templatesImport += "sch.utils._"

templatesImport ++= Seq("play.mvc.Http.Context.Implicit._")

playAssetsDirectories <+= baseDirectory / "static/public"