defmodule NumbersTest do
  use ExUnit.Case
  doctest Numbers

  test "greets the world" do
    assert Numbers.hello() == :world
  end
end
