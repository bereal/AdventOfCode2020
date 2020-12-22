import scala.io.StdIn
import scala.collection.mutable.{Map => MMap, Set => MSet}
import scala.util.matching.Regex

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

  val top = perimeter(Top)
  val left = perimeter(Left)
  val right = perimeter(Right)
  val bottom = perimeter(Bottom)

  val lookup = perimeter.toSeq.map({ case (k -> v) => (v -> k) }).toMap
}

class Tile(val id: Int, val s: Array[String]) {
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

  val tileConfigs = tiles.flatMap(_.allConfigs.values)
  val tileConfigsById = tileConfigs.groupBy(_.id)
  val mapSize = Math.sqrt(tiles.length).toInt
  val tileSize = tileConfigs.head.body.length

  val sideLookup = tileConfigs
    .map((t) => t.perimeter(Top) -> t.id)
    .groupBy(_._1)
    .view
    .mapValues(_.map(_._2).toSet)
    .toMap

  def isUnique(side: String) = {
    sideLookup(side).size == 1
  }

  def findCorners() = sideLookup.toSeq
    .filter(_._2.size == 1)
    .groupBy(_._2.head)
    .filter(_._2.length == 4) // two unique sides, each is mentioned twice
    .keys
    .toSet

  def fillMap(): Array[Array[Char]] = {
    val map: MMap[(Int, Int), TileConfig] = MMap()
    val pendingSet = MSet.from(tileConfigsById.keys)
    val update = (i: Int, j: Int, t: TileConfig) => {
      pendingSet.remove(t.id)
      map.update((i, j), t)
    }

    // find a tile matching the criterias
    val find: (TileConfig => Boolean) => TileConfig = (f) =>
      pendingSet.flatMap(tileConfigsById).filter(f).head

    for (i <- 1 to mapSize; j <- 1 to mapSize) {
      val tile = (i, j) match {
        // corners
        case (1, 1) => find(t => { isUnique(t.top) && isUnique(t.left) })
        case (1, `mapSize`) => find(t => isUnique(t.top) && isUnique(t.right) && t.left == map(i, j - 1).right)
        case (`mapSize`, 1) => find(t => isUnique(t.left) && isUnique(t.bottom) && t.top == map(i - 1, j).bottom)
        case (`mapSize`, `mapSize`) => find(_ => true)

        // sides
        case (1, _) => find(t => isUnique(t.top) && t.left == map(1, j - 1).right)
        case (_, 1) => find(t => isUnique(t.left) && t.top == map(i - 1, 1).bottom)
        case (`mapSize`, _) => find(t => isUnique(t.bottom) && t.left == map(i, j - 1).right)
        case (_, `mapSize`) => find(t => isUnique(t.right) && t.top == map(i - 1, j).bottom)

        // others
        case _ => find(t => t.top == map(i - 1, j).bottom && t.left == map(i, j - 1).right)
      }
      update(i, j, tile)
    }

    val getRowMatrix: (Int) => Array[Array[Char]] = (row) =>
      (1 to tileSize-2)
        .map(i => (1 to mapSize).flatMap(col => map(row, col).body(i).slice(1, tileSize-1)).toArray)
        .toArray
    (1 to mapSize).flatMap(getRowMatrix(_)).toArray
  }

  def findOverlapping(text: String, pattern: Regex): Int = {
    pattern.findFirstMatchIn(text) match {
      case Some(m) => 1 + findOverlapping(text.substring(m.start+1), pattern)
      case None => 0
    }
  }

  def findMonsters(sea: Array[Array[Char]]): Option[Int] = {
    val pattern = new Regex(s".{18}#.{${sea.length-19}}#....##....##....###.{${sea.length-19}}#..#..#..#..#..#...")
    val text = sea.map(_.mkString).mkString
    val found = findOverlapping(text, pattern)
    if (found>0) Some(sea.map(_.count(_ == '#')).sum - found * 15) else None
  }
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
    val map = area.fillMap()
    println(D4.values.toArray.map((D4(_, map))).map(area.findMonsters).filter(_.isDefined).head.get)
  }
}
