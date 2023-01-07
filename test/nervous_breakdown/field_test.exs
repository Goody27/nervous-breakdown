defmodule NervousBreakdown.FieldTest do
  use ExUnit.Case
  alias NervousBreakdown.Field

  test "create_initial_field" do
    field = Field.create_inital_field(9)
    assert field.kinds == 9
    assert field.clear == false
    assert field.gameover == false
    assert field.state == :stay
    assert tuple_size(field.cards) == 9 * 2
    assert elem(field.cards, 0) |> elem(1) == :nomatch
  end
end
