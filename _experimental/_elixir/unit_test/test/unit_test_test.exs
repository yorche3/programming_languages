defmodule UnitTestTest do
  use ExUnit.Case
  doctest UnitTest

  test "greets the world" do
    assert UnitTest.hello() == :world
  end
end
