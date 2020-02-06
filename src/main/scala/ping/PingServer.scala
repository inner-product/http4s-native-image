package co.innerproduct
package ping

import cats.effect.{ContextShift, IO, Timer}
import fs2.Stream
import org.http4s.client.blaze.BlazeClientBuilder
import org.http4s.implicits._
import org.http4s.server.blaze.BlazeServerBuilder
import org.http4s.server.middleware.Logger
import scala.concurrent.ExecutionContext.global

object PingServer {
  def stream(implicit T: Timer[IO], C: ContextShift[IO]): Stream[IO, Nothing] = {
    for {
      client <- BlazeClientBuilder[IO](global).stream

      httpApp = (PingRoutes.pingRoutes).orNotFound

      // With Middlewares in place
      finalHttpApp = Logger.httpApp(true, true)(httpApp)

      exitCode <- BlazeServerBuilder[IO]
        .bindHttp(8080, "0.0.0.0")
        .withHttpApp(finalHttpApp)
        .serve
    } yield exitCode
  }.drain
}
