{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import qualified Data.Set as S

class Ord c => Coord c where
  neighbourhood :: c -> S.Set c
  from2D :: Int -> Int -> c

newtype Coord3D = Coord3D (Int, Int, Int) deriving (Eq, Ord, Show)

instance Coord Coord3D where
  neighbourhood (Coord3D (a, b, c)) =
    S.fromList
      [ Coord3D (a + i, b + j, c + k)
        | i <- [-1 .. 1],
          j <- [-1 .. 1],
          k <- [-1 .. 1],
          i /= 0 || j /= 0 || k /= 0
      ]
  from2D a b = Coord3D (a, b, 0)

newtype Coord4D = Coord4D (Int, Int, Int, Int) deriving (Eq, Ord, Show)

instance Coord Coord4D where
  neighbourhood (Coord4D (a, b, c, d)) =
    S.fromList
      [ Coord4D (a + i, b + j, c + k, d + l)
        | i <- [-1 .. 1],
          j <- [-1 .. 1],
          k <- [-1 .. 1],
          l <- [-1 .. 1],
          i /= 0 || j /= 0 || k /= 0 || l /= 0
      ]
  from2D a b = Coord4D (a, b, 0, 0)

type Area c = S.Set c

countOccupiedNearby area coord =
  S.size $ S.intersection area $ neighbourhood coord

transformCell area coord =
  let cur = S.member coord area
      n = countOccupiedNearby area coord
   in if cur then n == 2 || n == 3 else n == 3

transformArea area =
  let workingSet = S.foldr S.union area $ S.map neighbourhood area
   in S.filter (transformCell area) workingSet

parseArea input =
  let parseRow row dat = [from2D row col | (col, v) <- zip [0 ..] dat, v == '#']
   in S.fromList $ concat $ zipWith parseRow [0 ..] input

solve area = S.size (iterate transformArea area !! 6)

solve1 input =
  let area :: Area Coord3D = parseArea input
   in solve area

solve2 input =
  let area :: Area Coord4D = parseArea input
   in solve area

main = do
  contents <- getContents
  let input = lines contents
  print $ solve1 input
  print $ solve2 input
