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

  test "nanndeyanenn" do
    field =
    %Field{
      kinds: 20,
      cards: {{2, :nomatch}, {9, :nomatch}, {3, :nomatch}, {1, :nomatch}, {5, :nomatch}, {6, :nomatch},
      {10, :nomatch}, {3, :nomatch}, {8, :nomatch}, {8, :nomatch}, {6, :nomatch}, {7, :nomatch},
      {1, :nomatch}, {5, :nomatch}, {7, :nomatch}, {2, :nomatch}, {9, :nomatch}, {4, :nomatch},
      {4, :nomatch}, {10, :nomatch}},
      state: :stay,
      clear: false,
      gameover: false
    }
    test =
      field
      |> Field.mode_change(5)
    test2 =
      test
      |> Field.mode_change(10)
    IO.inspect(test)
    IO.inspect(test2)
    assert Field.pair_check(test2) == false
  end
  test "case_2_test" do
    field =
    %Field{
      kinds: 20,
      cards: {{2, :nomatch}, {9, :nomatch}, {3, :is_match?}, {1, :nomatch}, {5, :nomatch}, {6, :nomatch},
      {10, :nomatch}, {3, :is_match?}, {8, :nomatch}, {8, :nomatch}, {6, :nomatch}, {7, :nomatch},
      {1, :nomatch}, {5, :nomatch}, {7, :match}, {2, :match}, {9, :nomatch}, {4, :nomatch},
      {4, :nomatch}, {10, :nomatch}},
      state: :stay,
      clear: false,
      gameover: false
    }

    #assert Field.case_2_do(field) == false
    assert Field.pair_check(field) == false

  end
end
