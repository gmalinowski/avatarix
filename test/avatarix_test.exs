defmodule AvatarixTest do
  use ExUnit.Case
  doctest Avatarix

  test "hash method returns list" do
    result = Avatarix.hash_input("something")
    assert is_list(result)
  end

  test "hashed list has numbers" do
    Avatarix.hash_input("dsafasf")
    |> Enum.all?(fn num -> is_number(num) end)
    |> assert
  end
end
