# neovuilder
Neovim everywhere!

## Need
A Neovim portable setup ready to use (to avoid online plugin management).  
Based on [LazyVim](https://github.com/LazyVim/LazyVim).

## Usage
```
./build.sh [bundle] [docker-repository]

Options:
bundle            The name of the neovim bundle [default: minimal]
docker-repository The remote repository if you want to push
```

## Bundles
According to the `bundle` parameter, the following `extras.lang` plugins will be imported in your LazyVim configuration.  
Note: Lua and Bash LSP servers, linters and formatters are installed in all of them.
| bundle    | extras.lang    |
|:---------:|:--------------:|
| minimal   | NONE           |
| ansible   | ansible python |
| docker    | docker         |
| go        | go             |
| python    | python         |
| rust      | rust           |
| terraform | terraform      |
