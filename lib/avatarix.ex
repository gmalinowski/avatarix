defmodule Avatarix do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
  end

  def build_grid(%Avatarix.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten()
      |> Enum.with_index()

    %Avatarix.Image{image | grid: grid}
  end

  def mirror_row([one, two, three]) do
    [one, two, three, two, one]
  end

  def pick_color(%Avatarix.Image{hex: [r, g, b | _tail]} = image) do
    %Avatarix.Image{image | color: {r, g, b}}
  end

  def hash_input(input) do
    hex =
      :crypto.hash(:md5, input)
      |> :binary.bin_to_list()

    %Avatarix.Image{hex: hex}
  end
end
