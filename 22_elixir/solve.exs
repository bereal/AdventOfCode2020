defmodule Game do
  def play1(a, []), do: {true, a}
  def play1([], b), do: {false, b}

  def play1([a | as], [b | bs]) do
    if a > b, do: play1(as ++ [a, b], bs), else: play1(as, bs ++ [b, a])
  end

  def play2(p1, p2, mem1 \\ MapSet.new(), mem2 \\ MapSet.new())
  def play2(a, [], _, _), do: {true, a}
  def play2([], b, _, _), do: {false, b}

  def play2([a | as] = p1, [b | bs] = p2, mem1, mem2) do
    win = fn p ->
      {new_as, new_bs} = if p, do: {as ++ [a, b], bs}, else: {as, bs ++ [b, a]}
      play2(new_as, new_bs, MapSet.put(mem1, p1), MapSet.put(mem2, p2))
    end

    cond do
      MapSet.member?(mem1, p1) or MapSet.member?(mem2, p2) ->
        {true, p1}

      a <= length(as) and b <= length(bs) ->
        case play2(Enum.take(as, a), Enum.take(bs, b)) do
          {p, _} -> win.(p)
        end

      true ->
        win.(a > b)
    end
  end

  def score({_, deck}) do
    Enum.reverse(deck) |> Enum.with_index(1) |> Enum.map(fn {a, b} -> a * b end) |> Enum.sum()
  end

  def read_player(buf \\ []) do
    case IO.read(:stdio, :line) do
      e when e in [:eof, "\n"] ->
        buf |> Enum.reverse() |> Enum.drop(1) |> Enum.map(&String.to_integer/1)

      v ->
        read_player([String.trim(v) | buf])
    end
  end

  def read_input(), do: {read_player(), read_player()}
end

{p1, p2} = Game.read_input()
Game.play1(p1, p2) |> Game.score() |> IO.inspect()
Game.play2(p1, p2) |> Game.score() |> IO.inspect()
