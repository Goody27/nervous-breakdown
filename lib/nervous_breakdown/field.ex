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

  def check_and_do(field = %__MODULE__{}, index) do
    cond do
     can_open?(field, index) -> mode_change(field, index) |> pair_check()
      true -> field
    end
  end

  def can_open?(field = %__MODULE__{}, index) do
    elem(field.cards, index) |> elem(1) == :nomatch
  end

  def pair_check(field) do
    len_is_match = len_is_match?(field)
    case len_is_match do
      0 -> field
      1 -> field
      2 -> case_2_do(field)
      _ -> field
    end
  end

  def case_2_do(field, match_value) do
    index = Enum.find_index(Tuple.to_list(field.cards), fn x -> x == match_value end)
    mode_change(field, index)
  end
  def case_2_do(field) do
    is_match = case_2_check_match?(field)
    match_value =
      take_is_match?(field)
      |> Tuple.to_list()
      |> hd()
    if is_match do
      IO.puts "*****************************************************"
      index = Enum.find_index(Tuple.to_list(field.cards), fn x -> x == match_value end)
      mode_change(field, index)
      |> case_2_do(match_value)
    else
      #ここにnomatchも変更する値を
    end
  end

  def case_2_check_match?(field) do
    check_match_tuples = take_is_match?(field)
    {first, second} = check_match_tuples
    first == second
  end

  def take_is_match?(field) do
    field.cards
    |> Tuple.to_list()
    |> Enum.filter(fn tuple -> elem(tuple, 1) == :is_match? end)
    |> List.to_tuple()
  end

  def len_is_match?(field) do
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
  def mode_change(field = %__MODULE__{}, index) do
    Map.put(field, :cards,
      put_elem(
        field.cards,
        index,
        case current_value = get_cards_atom(field, index) do
          #　ここでis_matchがmatchにしかならないからnomatchにもしなければならないんこ
          :nomatch -> {get_cards_num(field, index), :is_match?}
          :is_match? -> {get_cards_num(field, index), :match}
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
