import Config

if :test == Mix.env() do
  config :logger, level: :info
end
