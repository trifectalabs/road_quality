package models

import play.api.libs.json._

case class EmailSignup(email_address: String, status: String)

object EmailSignup {
  implicit val emailSignupFormat = Json.format[EmailSignup]
}
