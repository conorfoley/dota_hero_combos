defmodule DotaHeroCombos.Resource.Error.GET do
  use DotaHeroCombos.Resource

  mediatype Hyper do
    action do
      %{
        "error" => %{
          "message" => "Resource not found"
        }
      }
    end
  end
end
