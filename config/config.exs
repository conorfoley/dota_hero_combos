use Mix.Config

config :logger, :console,
  level: :info,
  format: "$message
"

config :dota_hero_combos,
  port: (System.get_env("PORT") || "4000") |> String.to_integer
