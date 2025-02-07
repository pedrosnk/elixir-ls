defmodule ElixirLS.LanguageServer.Providers.HoverTest do
  use ElixirLS.Utils.MixTest.Case, async: false
  import ElixirLS.LanguageServer.Test.PlatformTestHelpers

  alias ElixirLS.LanguageServer.Providers.Hover
  # mix cmd --app language_server mix test test/providers/hover_test.exs

  def fake_dir() do
    Path.join(__DIR__, "../../../..") |> Path.expand() |> maybe_convert_path_separators()
  end

  test "blank hover" do
    text = """
    defmodule MyModule do
      def hello() do
        IO.inspect("hello world")
      end
    end
    """

    {line, char} = {2, 1}

    assert {:ok, resp} = Hover.hover(text, line, char, fake_dir())
    assert nil == resp
  end

  test "elixir module hover" do
    text = """
    defmodule MyModule do
      def hello() do
        IO.inspect("hello world")
      end
    end
    """

    {line, char} = {2, 5}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\nIO\n```\n\n*module* [View on hexdocs](https://hexdocs.pm/elixir/#{System.version()}/IO.html)"
           )
  end

  test "function hover" do
    text = """
    defmodule MyModule do
      def hello() do
        IO.inspect("hello world")
      end
    end
    """

    {line, char} = {2, 10}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\nIO.inspect(item, opts \\\\ [])\n```\n\n*function* [View on hexdocs](https://hexdocs.pm/elixir/#{System.version()}/IO.html#inspect/2)"
           )
  end

  test "macro hover" do
    text = """
    defmodule MyModule do
      import Abc
    end
    """

    {line, char} = {1, 3}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\nKernel.SpecialForms.import(module, opts)\n```\n\n*macro* [View on hexdocs](https://hexdocs.pm/elixir/#{System.version()}/Kernel.SpecialForms.html#import/2)"
           )
  end

  test "elixir type hover" do
    text = """
    defmodule MyModule do
      @type d :: Date.t()
    end
    """

    {line, char} = {1, 18}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\nDate.t()\n```\n\n*type* [View on hexdocs](https://hexdocs.pm/elixir/#{System.version()}/Date.html#t:t/0)"
           )
  end

  test "erlang function" do
    text = """
    defmodule MyModule do
      def hello() do
        :timer.sleep(1000)
      end
    end
    """

    {line, char} = {2, 10}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(v, "```elixir\n:timer.sleep(time)\n```\n\n*function*")
    # TODO hexdocs and standard lib docs
    assert not String.contains?(
             v,
             "[View on hexdocs]"
           )
  end

  test "keyword" do
    text = """
    defmodule MyModule do
      @type d :: Date.t()
    end
    """

    {line, char} = {0, 19}

    if Version.match?(System.version(), ">= 1.14.0") do
      assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
               Hover.hover(text, line, char, fake_dir())

      assert String.starts_with?(
               v,
               "```elixir\ndo\n```\n\n*reserved word*"
             )
    else
      assert {:ok, nil} =
               Hover.hover(text, line, char, fake_dir())
    end
  end

  test "variable" do
    text = """
    defmodule MyModule do
      asdf = 1
    end
    """

    {line, char} = {1, 3}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\nasdf\n```\n\n*variable*"
           )
  end

  test "attribute" do
    text = """
    defmodule MyModule do
      @behaviour :some
    end
    """

    {line, char} = {1, 4}

    assert {:ok, %{"contents" => %{kind: "markdown", value: v}}} =
             Hover.hover(text, line, char, fake_dir())

    assert String.starts_with?(
             v,
             "```elixir\n@behaviour\n```\n\n*module attribute*"
           )
  end
end
