defmodule Test.DotaHeroCombos.Resource.GET do
  use Test.DotaHeroCombos.Resource

  test "should respond with a 200" do
    request()
  after conn ->
    conn
    |> assert_status(200)
    |> assert_json(%{"greeting" => _})
  end

  test "should respond with an affordance" do
    affordance()
  after conn ->
    conn
    |> assert_json(%{"href" => _})
  end
end
