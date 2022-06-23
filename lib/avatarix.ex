defmodule Avatarix do
  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Avatarix.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)

    :egd.render(image)
  end

  def build_pixel_map(%Avatarix.Image{grid: grid} = image) do
    pixel_map =
      Enum.map(grid, fn {_code, index} ->
        horizontal = rem(index, 5) * 50
        vertical = div(index, 5) * 50
        top_left = {horizontal, vertical}
        bottom_right = {horizontal + 50, vertical + 50}

        {top_left, bottom_right}
      end)

    %Avatarix.Image{image | pixel_map: pixel_map}
  end

  def filter_odd_squares(%Avatarix.Image{grid: grid} = image) do
    grid =
      Enum.filter(grid, fn {val, _index} ->
        rem(val, 2) === 0
      end)

    %Avatarix.Image{image | grid: grid}
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
