# Incomplete OTP installations

Incomplete installations is a frequent cause of ElixirLS failures. Generally
this is resolved by:

* Installing elixir and erlang via [ASDF](https://github.com/asdf-vm/asdf) or [RTX](https://github.com/jdx/rtx)
  (recommended)
* Installing a full version of Erlang/OTP via the package manager

## dialyzer missing

On *Ubuntu* this is caused by the required `erlang-dialyzer` package not being
installed. For Ubuntu this can be fixed by running

```bash
sudo apt-get install erlang erlang-dialyzer
```

or installing Elixir and Erlang via [ASDF](https://github.com/asdf-vm/asdf) or [RTX](https://github.com/jdx/rtx)

Relevant issue: https://github.com/elixir-lsp/vscode-elixir-ls/issues/134

## edoc missing

On *Fedora* this is caused by the required `erlang-edoc` package not being
installed. For fedora this can be fixed by running

```bash
sudo dnf install erlang erlang-edoc
```

or installing Elixir and Erlang via [ASDF](https://github.com/asdf-vm/asdf) or [RTX](https://github.com/jdx/rtx)

Relevant issue: https://github.com/elixir-lsp/elixir-ls/issues/431
