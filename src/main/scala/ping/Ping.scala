package co.innerproduct
package ping

import cats.effect.IO
import io.circe.{Encoder, Json}
import org.http4s.EntityEncoder
import org.http4s.circe._

object Ping {

  def ping(message: String): IO[Pong] =
    IO(Pong(message))

  final case class Pong(message: String) extends AnyVal
  object Pong {
    implicit val pongEncoder: Encoder[Pong] = new Encoder[Pong] {
      final def apply(a: Pong): Json = Json.obj(
        ("message", Json.fromString(a.message))
      )
    }

    implicit val pongEntityEncoder: EntityEncoder[IO, Pong] =
      jsonEncoderOf[IO, Pong]
  }
}
