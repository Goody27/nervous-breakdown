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

  def update_field(field = %__MODULE__{}, index) do
    cond do
      is_nomatch?(field, index) -> change_field(field, index)
      true -> field
    end
  end

  def is_nomatch?(field = %__MODULE__{}, index) do
    elem(field.cards, index) |> elem(1) == :nomatch
  end

  def next_step_do(field) do
    case field.clear do
      true -> field
      _    -> pair_check_and_do(field) |> clear_check_do()
    end
  end

  def change_field(field, index) do
    len_is_match = len_is_match(field)
    case len_is_match do
      0 -> mode_change(:nomatch, field, index)
      1 -> mode_change(:nomatch, field, index) |> clear_check_do()
      _ -> field
    end
  end

  def is_match_to_nomatch(field) do
    index = Enum.find_index(Tuple.to_list(field.cards), fn x -> elem(x, 1) == :is_match? end)
    mode_change(:nomatch, field, index)
  end

  def pair_check_and_do(field, match_value) do
    index = Enum.find_index(Tuple.to_list(field.cards), fn x -> x == match_value end)
    mode_change(:match, field, index)
  end
  def pair_check_and_do(field) do
    is_match = is_pair_same?(field)
    match_value =
      take_is_match(field)
      |> Tuple.to_list()
      |> hd()
    if is_match do
      index = Enum.find_index(Tuple.to_list(field.cards), fn x -> x == match_value end)
      mode_change(:match, field, index)
      |> pair_check_and_do(match_value)
    else
      index = Enum.find_index(Tuple.to_list(field.cards), fn x -> elem(x, 1) == :is_match? end)
      mode_change(:nomatch, field, index)
      |> is_match_to_nomatch()
    end
  end

  def is_pair_same?(field) do
    check_match_tuples = take_is_match(field)
    {first, second} = check_match_tuples
    first == second
  end

  def take_is_match(field) do
    field.cards
    |> Tuple.to_list()
    |> Enum.filter(fn tuple -> elem(tuple, 1) == :is_match? end)
    |> List.to_tuple()
  end

  def len_is_match(field) do
    field.cards
    |> Tuple.to_list()
    |> Enum.filter(fn tuple -> elem(tuple, 1) == :is_match? end)
    |> length()
  end

  def len_match(field) do
    field
    |> Tuple.to_list()
    |> Enum.filter(fn tuple -> elem(tuple, 1) == :match end)
    |> length()
  end
  def mode_change(:match, field = %__MODULE__{}, index) do
    Map.put(field, :cards,
      put_elem(
        field.cards,
        index,
        case current_value = get_cards_atom(field, index) do
          :nomatch -> {get_cards_num(field, index), :is_match?}
          :is_match? -> {get_cards_num(field, index),:match}
          _ -> current_value
        end
      )
    )
  end

  def mode_change(:nomatch, field = %__MODULE__{}, index) do
    Map.put(field, :cards,
      put_elem(
        field.cards,
        index,
        case current_value = get_cards_atom(field, index) do
          :nomatch -> {get_cards_num(field, index), :is_match?}
          :is_match? -> {get_cards_num(field, index), :nomatch}
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

  def clear_check_do(field)do
    if is_clear?(field) do
      Map.put(field, :clear, true)
    else
      field
    end
  end
  def is_clear?(field) do
    field.cards
    |> Tuple.to_list()
    |> Enum.all?(fn tuple -> elem(tuple, 1) == :match end)
  end

end
