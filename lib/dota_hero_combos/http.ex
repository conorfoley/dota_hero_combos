defmodule DotaHeroCombos.HTTP do
  require Logger

  def start() do
    listen(Mix.env)
  end

  def listen(:test) do
    :noop
  end
  def listen(_) do
    cowboy_opts = [port: Application.get_env(:dota_hero_combos, :port),
                   compress: true]

    wait1_opts = []

    Logger.info "Server listening on port #{cowboy_opts[:port]}"
    {:ok, _} = Plug.Adapters.Wait1.http(DotaHeroCombos.Router, wait1_opts, cowboy_opts)
  end
end
