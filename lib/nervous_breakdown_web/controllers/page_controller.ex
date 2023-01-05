defmodule NervousBreakdownWeb.PageController do
  use NervousBreakdownWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
