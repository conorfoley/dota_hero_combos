# fugue  [![Build Status](https://travis-ci.org/exstruct/fugue.svg?branch=master)](https://travis-ci.org/exstruct/fugue) [![Hex.pm](https://img.shields.io/hexpm/v/fugue.svg?style=flat-square)](https://hex.pm/packages/fugue) [![Hex.pm](https://img.shields.io/hexpm/dt/fugue.svg?style=flat-square)](https://hex.pm/packages/fugue)

Extendable testing utilities for Plug

## Installation

`Fugue` is [available in Hex](https://hex.pm/docs/publish) and can be installed as:

  1. Add fugue your list of dependencies in `mix.exs`:

  ```elixir
  def deps do
    [{:fugue, "~> 0.1.0"}]
  end
  ```

## Usage

`Fugue` extends `ExUnit.Case` by adding macros for calling `Plug` applications in an extendable way.

```elixir
defmodule Test.MyApp do
  use Fugue, plug: MyApp

  test "root response" do
    request()
  after conn ->
    conn
    |> assert_status(200)
  end

  test "users read response" do
    user_id = "123" # this could come from a seed function

    request do
      path "/users/#{user_id}"
    end
  after conn ->
    conn
    |> assert_body_contains(user_id)
  end
end
```

Notice the setup and assertions are separated by an `after` keyword. The idea is to decouple the test case setup/generation from the actual test case execution. This ends up being useful in many ways. We could:

* generate cases on a single machine and distribute the requests around a cluster
* create benchmarks that exclude the setup time and just test the request rate (maybe even skip assertions entirely)
* serialize the requests into a file and run at a later time, or in a different language or service
* chain multiple tests together to create flow tests
* _insert your crazy idea here_

`Fugue` exposes several overridable functions to support this behavior:

### `execute/3`

`execute` is the lowest level hook. It receives the request struct and a function handle for assertions. The default behavior is to call the `call/2` function followed by the assertions:

```elixir
defmodule Test.MyApp do
  use Fugue

  defp execute(request, assertions, context) do
    request
    |> call(context)
    |> assertions.()
  end
end
```

### `call/2`

`call` receives the request struct and executes the request. In the case standard `Plug` apps this would look something like:

```elixir
defmodule Test.MyApp do
  use Fugue

  def call(request, _context) do
    MyApp.call(request, [])
  end
end
```

When using `Fugue`, you may pass `:plug` and `:plug_opts` to the default `call` implementation:

```elixir
defmodule Test.MyApp do
  use Fugue, plug: MyApp,
             plug_opts: []
end
```

### `init_request/1`

`init_request` is passed the test context and can create the request struct. This is helpful for when something other than `Plug.Conn` is used or the default values for `Plug.Conn` need to be changed.

### `prepare_request/2`

`prepare_request` is called just before calling `execute/3` which allows for any final modifications to the request to be made.
