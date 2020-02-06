package co.innerproduct
package ping

import cats.effect.{ExitCode, IOApp}
import cats.implicits._

object Main extends IOApp {
  def run(args: List[String]) =
    PingServer.stream.compile.drain.as(ExitCode.Success)
}
