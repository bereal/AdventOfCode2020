import scala.io.StdIn

class Tile(val id: Int, val s: Array[String]) {
  val init = s.map(_.toArray)
  val allConfigs = Array(
    init,
    init.reverse,
    init.map(_.reverse),
    init.transpose,
    init.transpose.reverse,
    init.reverse.transpose,
    init.transpose.reverse.map(_.reverse),
    init.reverse.map(_.reverse)
  )

  val initSides =
    Array(init(0), init.last, init.map(_(0)), init.map(_.last)).map(_.mkString)
  val sides = allConfigs.map(_(0).mkString)
}

class Area(val tiles: Seq[Tile]) {
  val sideLookup =
    tiles
      .flatMap(c => c.sides.map({ _ -> c.id }))
      .groupBy(_._1)
      .view
      .mapValues(_.map(_._2).toSet)
      .toMap

  def findMatch(t: Tile) = t.initSides
    .flatMap(
      sideLookup.getOrElse(_, List.empty)
    )
    .toSet
    .filter(_ != t.id)

  def findCorners(): Seq[Tile] = tiles.filter(findMatch(_).size <= 2)
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
    println(area.findCorners().map(_.id.toLong).reduce(_ * _))
  }
}
