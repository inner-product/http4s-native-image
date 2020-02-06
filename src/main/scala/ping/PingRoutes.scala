package co.innerproduct
package ping

import cats.effect.IO
import org.http4s.HttpRoutes
import org.http4s.dsl.Http4sDsl

object PingRoutes {
  val dsl = new Http4sDsl[IO] {}

  val pingRoutes: HttpRoutes[IO] = {
    import dsl._
    HttpRoutes.of[IO] {
      case GET -> Root / "ping" / message =>
        for {
          pong <- Ping.ping(message)
          resp <- Ok(pong)
        } yield resp
    }
  }
}
