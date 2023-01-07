defmodule NervousBreakdownWeb.NervousBreakdownView do
  use Phoenix.LiveView
  alias NervousBreakdown.Field
  #use PetalComponents

  def render(assigns) do
    ~H"""
    <div class="centering_parent">
      <div class="grid grid-cols-1 gap-4 place-content-center">
      <div class="centering_item" id='map' style={style_string(@field)}>
        <%= for {index, class_string, value} <- create_elements(@field) do%>
          <div class="torima" phx-click="clicked" id={"field"} phx-value-pos={index}>
          <%= value %>
          </div>
          <div class={class_string}></div>
        <% end %>
      </div>
        <div draggable="true" id="dragtest" class="draggable centering_item cell flag" id='map' style="
        display: grid;
        width: 40px;
        height: 40px;">
        </div>

      </div>
    </div>
    Hello

    """
  end

  def mount(_params, _session, socket) do
    IO.inspect("-----------------------------------------------------")
    field = Field.create_inital_field(12)
    {:ok, assign(socket, field: field)}
  end

  def handle_event("clicked", %{"pos" => string_pos}, socket) do
    IO.inspect("======================================================")
    pos = String.to_integer(string_pos)
    {:noreply, update(socket, :field, &Field.open(&1, pos))}
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
      {index, "hello", get_value_string(field, index)}
    end
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
