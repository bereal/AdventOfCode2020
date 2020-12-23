import scala.io.StdIn
import scala.collection.mutable.{Map => MMap, Set => MSet}
import scala.util.matching.Regex

object Types {
  type Matrix[T] = Array[Array[T]]
}

object D4 extends Enumeration {
  import Types._

  def apply(m: Matrix[Char]): Seq[Matrix[Char]] = List(
    m, // R0
    m.reverse, // SH
    m.map(_.reverse), // SV
    m.transpose, // D1
    m.reverse.map(_.reverse).transpose, // D2
    m.transpose.reverse,  // R1
    m.reverse.map(_.reverse), // R2
    m.reverse.transpose // R3
  )
}

class Tile(val id: Int, val body: Types.Matrix[Char]) {
  lazy val top = body.head.mkString
  lazy val left = body.map(_.head).mkString
  lazy val right = body.map(_.last).mkString
  lazy val bottom = body.last.mkString

  lazy val configs = D4(body).map(new Tile(id, _))
}

class Area(val tiles: Seq[Tile]) {
  import Types._

  val tileConfigs = tiles.flatMap(_.configs)
  val tileConfigsById = tileConfigs.groupBy(_.id)
  val mapSize = Math.sqrt(tiles.length).toInt
  val tileSize = tileConfigs.head.body.length

  val sideCount = tileConfigs
    .groupBy(_.top).view.mapValues(_.map(_.id).toSet.size).toMap

  def isUnique(side: String) = sideCount(side) == 1

  def findCorners() = tileConfigs.filter(t => isUnique(t.top) && isUnique(t.left)).map(_.id).toSet

  def fillMap(): Matrix[Char] = {
    val map: MMap[(Int, Int), Tile] = MMap()
    val pendingSet = MSet.from(tileConfigsById.keys)
    val update = (i: Int, j: Int, t: Tile) => {
      pendingSet.remove(t.id)
      map.update((i, j), t)
    }

    // find a tile matching the criterias
    val find: (Tile => Boolean) => Tile = (f) =>
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

    val getRowMatrix: (Int) => Matrix[Char] = (row) =>
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

  def findMonsters(sea: Matrix[Char]): Option[Int] = {
    val pattern = new Regex(s".{18}#.{${sea.length-19}}#....##....##....###.{${sea.length-19}}#..#..#..#..#..#...")
    val text = sea.map(_.mkString).mkString
    val found = findOverlapping(text, pattern)
    if (found>0) Some(sea.map(_.count(_ == '#')).sum - found * 15) else None
  }
}

object Main {
  import Types._

  def readTileBody(): Matrix[Char] =
    Iterator.continually(StdIn.readLine())
      .takeWhile(s => s != null && s.length() > 0).map(_.toArray).toArray

  def readTile(): Option[Tile] = {
    val reg = """Tile (\d+):""".r
    StdIn.readLine() match {
      case reg(id) => Some(new Tile(id.toInt, readTileBody()))
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
    val sea = area.fillMap()
    println(D4(sea).map(area.findMonsters).flatten.head)
  }
}
