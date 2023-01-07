defmodule NervousBreakdown.Field do
  defstruct [
    :kinds,
    :cards,
    :state,
    clear: false,
    gameover: false
  ]
  def create_inital_field(cards \\ 12) do
    %__MODULE__{
      kinds: cards,
      cards: create_cards(cards),
      state: :stay,
      clear: false,
      gameover: false
    }
  end

  defp create_cards(cards) do
    Enum.map(1..2, fn _ ->
      Enum.take_random(1..cards,cards)
    end)
    |> Enum.zip_reduce([], fn x, y-> x ++ y  end)
    |> Enum.zip(List.duplicate(:nomatch, cards*2))
    |> List.to_tuple()
  end

  def open(field = %__MODULE__{}, index) do
    cond do
     can_open?(field, index) -> mode_change(field, index)
      true -> field
    end
  end

  def can_open?(field = %__MODULE__{}, index) do
    elem(field.cards, index) |> elem(1) == :nomatch
  end

  def mode_change(field = %__MODULE__{}, index) do
    Map.put(field, :cards,
      put_elem(
        field.cards,
        index,
        case current_value = get_cards_atom(field, index) do
          :nomatch -> {get_cards_num(field, index), :is_match?}
          _ -> current_value
        end
      )
    )
  end

  def get_cards_atom(field = %__MODULE__{}, index) do
    elem(field.cards, index) |> elem(1)
  end

  def get_cards_num(field = %__MODULE__{}, index) do
    elem(field.cards, index) |> elem(0)
  end
end
