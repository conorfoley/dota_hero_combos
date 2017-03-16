defmodule DotaHeroCombos.Resource.GET do
  use DotaHeroCombos.Resource

  input name

  mediatype Hyper do
    action do
      %{
        "greeting" => greeting(name || "guest")
      }
    end
  end

  def greeting(name) do
    %{
      "hello" => name
    }
  end
end
