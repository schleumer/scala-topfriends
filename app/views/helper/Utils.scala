package views.helper

import play.api.templates.Html

object cu{
	def apply(c: String): String = {
		return c
	}
  	def unapply(c: String): String = {
  		return c
  	}
}

object Utils {
  def test(htmlText: String): String = {
  	return htmlText
  }
}