import gleam/int
import gleam/io
import gleam/list
import gleam/string
import utils

fn str_to_ints(str: String) -> List(Int) {
  str |> string.split(" ") |> list.filter_map(int.parse)
}

fn remove_elem(ls: List(a), at_index n: Int) -> List(a) {
  list.flatten({
    use e, idx <- list.index_map(ls)
    use _ <- list.filter([e])

    idx != n
  })
}

fn get_discriminant(x: Int, y: Int, disc: Int) -> Int {
  case x - y {
    n if n >= 1 && n <= 3 && disc >= 0 -> 1
    n if n <= -1 && n >= -3 && disc <= 0 -> -1
    _ -> 0
  }
}

fn tr_is_safe_report(report: List(Int), disc: Int, errors res: Int) -> Int {
  case report {
    [x, y, ..t] ->
      case get_discriminant(x, y, disc) {
        0 -> tr_is_safe_report([y, ..t], 0, res + 1)
        1 -> tr_is_safe_report([y, ..t], 1, res)
        _ -> tr_is_safe_report([y, ..t], -1, res)
      }
    _ -> res
  }
}

fn is_safe_report(report: List(Int)) -> Int {
  tr_is_safe_report(report, 0, 0)
}

pub fn part2(input: List(List(Int))) -> Int {
  use report <- list.count(input)
  use acc, _, n <- list.index_fold(report, False)

  acc || report |> remove_elem(n) |> is_safe_report == 0
}

pub fn part1(input: List(List(Int))) -> Int {
  list.count(input, fn(r) { 0 == is_safe_report(r) })
}

pub fn day02(input: String) -> List(Int) {
  let report_lines =
    input
    |> utils.clean_input_lines
    |> list.map(str_to_ints)

  [part1(report_lines), part2(report_lines)]
}

pub fn main() {
  utils.get_input(day: 2)
  |> day02
  |> list.each(io.debug)
}
