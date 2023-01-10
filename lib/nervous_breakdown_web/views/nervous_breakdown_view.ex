defmodule NervousBreakdownWeb.NervousBreakdownView do
  use Phoenix.LiveView
  alias NervousBreakdown.Field
  #use PetalComponents

  def render(assigns) do
    ~H"""
      <div class="centering_item" id='map' style={style_string(@field)}>
        <%= for {index, class_string, value} <- create_elements(@field) do%>
          <div class={class_string} phx-click="clicked" id={"field"} phx-value-pos={index}>
            <%= value %>
          </div>
        <% end %>
        <button class="new_game_item" phx-click="next_open" id="bt-next">Next</button>
        <%= if @field.clear do %>
          <button class="new_game_item" phx-click="new_game" id="bt-new-game">New Game</button>
        <% end %>
      </div>
    """
  end

  def mount(_params, _session, socket) do
    field = Field.create_inital_field(12)
    {:ok, assign(socket, field: field)}
  end

  def handle_event("clicked", %{"pos" => string_pos}, socket) do
    pos = String.to_integer(string_pos)
    {:noreply, update(socket, :field, &Field.update_field(&1, pos))}
  end

  def handle_event("next_open", _, socket) do
    {:noreply, update(socket, :field, &Field.next_step_do(&1))}
  end

  def handle_event("new_game", _, socket) do
    field = socket.assigns.field
    field = Field.create_inital_field(field.kinds)
    {:noreply, update(socket, :field, fn _ -> field end)}
  end


  def style_string(field) do
    px = 80
    "display: grid;
      grid-template-columns: repeat(#{field.kinds},#{px}px);
      grid-template-rows: repeat(#{field.kinds},#{px}px);
      width: #{field.kinds*px}px;
      height: #{field.kinds*px}px;
      background: rgb(95, 211, 27);"
  end

  def create_elements(field) do
    for index <- 0..(field.kinds*2-1) do
      {index, get_class_string(field, index), get_value_string(field, index)}
    end
  end

  def get_class_string(field, index) do
    card = elem(field.cards, index)
    (["field"]
    ++
    (if field.clear, do: ["clear"], else: [])
    ++
    (if elem(card, 1) == :nomatch, do: ["nomatch"], else: [])
    ++
    (if elem(card, 1) == :is_match?,do: ["is_match"], else: [])
    ++
    (if elem(card, 1) == :match, do: ["match"], else: []))
    |> Enum.join(" ")
  end

  def get_value_string(field, index) do
    card =
      elem(field.cards, index)
      |> elem(1)
    cards =
      elem(field.cards, index)
      |> elem(0)
    cond do
      card == :match -> Integer.to_string(cards)
      card == :is_match? -> Integer.to_string(cards)
      true -> ""
    end
  end

end
