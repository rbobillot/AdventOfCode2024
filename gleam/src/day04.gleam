import gleam/dict.{type Dict}
import gleam/io
import gleam/list
import gleam/string
import utils

pub type Coord {
  Coord(x: Int, y: Int)
}

fn get_neighbours(input: Dict(Coord, String), ns: Int, f: fn(Int) -> Coord) {
  list.range(0, ns)
  |> list.filter_map(fn(n) { dict.get(input, f(n)) })
  |> string.join("")
}

fn find_xmas(input: Dict(Coord, String), part: Int, x: Int, y: Int) {
  let ho = get_neighbours(input, 3, fn(n) { Coord(x + n, y) })
  let ve = get_neighbours(input, 3, fn(n) { Coord(x, y + n) })

  let dr = get_neighbours(input, 3, fn(n) { Coord(x + n, y + n) })
  let dl = get_neighbours(input, 3, fn(n) { Coord(x - n, y + n) })

  let dd = get_neighbours(input, 2, fn(n) { Coord(x + n, y + n) })
  let du = get_neighbours(input, 2, fn(n) { Coord(x + n, y + 2 - n) })

  case part {
    1 -> [ho, ve, dr, dl] |> list.count(fn(w) { "XMAS" == w || "SAMX" == w })
    _ ->
      case dd, du {
        "MAS", "MAS" | "SAM", "SAM" -> 1
        "MAS", "SAM" | "SAM", "MAS" -> 1
        _, _ -> 0
      }
  }
}

fn tr_solve(input: Dict(Coord, String), part: Int, x: Int, y: Int, res: Int) {
  case dict.has_key(input, Coord(x, y)), dict.has_key(input, Coord(0, y + 1)) {
    False, False -> res
    False, True -> tr_solve(input, part, 0, y + 1, res)
    _, _ -> tr_solve(input, part, x + 1, y, res + find_xmas(input, part, x, y))
  }
}

pub fn part2(input: Dict(Coord, String)) {
  tr_solve(input, 2, 0, 0, 0)
}

pub fn part1(input: Dict(Coord, String)) {
  tr_solve(input, 1, 0, 0, 0)
}

fn to_cells(input: List(List(String)), x: Int, y: Int, res: Dict(Coord, String)) {
  case input {
    [] -> res
    [row, ..rows] ->
      case row {
        [] -> to_cells(rows, 0, y + 1, res)
        [h, ..r] ->
          to_cells([r, ..rows], x + 1, y, dict.insert(res, Coord(x, y), h))
      }
  }
}

pub fn day04(input: String) -> List(Int) {
  let input =
    input
    |> utils.clean_input_lines
    |> list.map(string.to_graphemes)
    |> to_cells(0, 0, dict.new())

  [part1(input), part2(input)]
}

pub fn main() {
  utils.get_input(day: 4)
  |> day04
  |> list.each(io.debug)
}
