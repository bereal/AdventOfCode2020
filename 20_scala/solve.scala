import scala.io.StdIn
import scala.collection.mutable.{Map => MMap}

object D4 extends Enumeration {
  val R0, R1, R2, R3, SH, SV, D1, D2 = Value

  def apply(op: Value, square: Array[Array[Char]]): Array[Array[Char]] = {
    op match {
      case R0 => square
      case SH => square.reverse
      case SV => square.map(_.reverse)
      case D1 => square.transpose
      case D2 => square.reverse.map(_.reverse).transpose
      case R1 => square.transpose.reverse
      case R2 => square.reverse.map(_.reverse)
      case R3 => square.reverse.transpose
    }
  }
}

object Side extends Enumeration {
  val Top, Right, Bottom, Left = Value
}

class TileConfig(val id: Int, val d4: D4.Value, init: Array[Array[Char]]) {
  import Side._
  val body = D4(d4, init)
  val perimeter = Map(
    Top -> body(0).mkString,
    Right -> body.map(_.last).mkString,
    Bottom -> body.last.mkString,
    Left -> body.map(_(0)).mkString
  )

  val lookup = perimeter.toSeq.map({ case (k -> v) => (v -> k) }).toMap
}

class Tile(val id: Int, val s: Array[String]) {
  import Side._
  type Row = Array[Char]

  val init = s.map(_.toArray)
  val allConfigs =
    D4.values.toArray
      .map(new TileConfig(id, _, init))
      .groupBy(_.d4)
      .view
      .mapValues(_(0))
      .toMap
}

class Area(val tiles: Seq[Tile]) {
  import Side._

  val sideLookup = tiles
    .flatMap(c => c.allConfigs.values.map({ _.perimeter(Top) -> c.id }))
    .groupBy(_._1)
    .view
    .mapValues(_.map(_._2).toSet)
    .toMap

  def findCorners() = sideLookup.toSeq
    .filter(_._2.size == 1)
    .groupBy(_._2.head)
    .filter(_._2.length == 4) // two unique sides, each is mentioned twice
    .keys
    .toSet
}

object Main {
  def readTile(): Option[Tile] = {
    val reg = """Tile (\d+):""".r

    StdIn.readLine() match {
      case reg(id) =>
        Some(
          new Tile(
            id.toInt,
            Iterator
              .continually(StdIn.readLine())
              .takeWhile(s => s != null && s.length > 0)
              .toArray
          )
        )
      case c => None
    }
  }

  def readInput(): Seq[Tile] = {
    readTile() match {
      case Some(t) => t +: readInput()
      case None    => Nil
    }
  }

  def main(args: Array[String]): Unit = {
    val area = new Area(readInput())
    println(area.findCorners().map(_.toLong).reduce(_ * _))
  }
}
