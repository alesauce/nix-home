{ pkgs, ... }:

{
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;

      nixvimInjections = true;

      ensureInstalled = [
        "bash"
        "dockerfile"
        "git_config"
        "git_rebase"
        "gitattributes"
        "gitcommit"
        "gitignore"
        "go"
        "gomod"
        "gosum"
        "gowork"
        "graphql"
        "haskell_persistent"
        "java"
        "javascript"
        "jq"
        "json"
        "json5"
        "lua"
        "luadoc"
        "lua patterns"
        "luau"
        "markdown"
        "markdown_inline"
        "nickel"
        "nix"
        "python"
        "regex"
        "rust"
        "smithy"
        "sql"
        "terraform"
        "todotxt"
        "toml"
        "tsx"
        "typescript"
        "vim"
        "vimdoc"
        "yaml"
        "zig"
      ];
    };
  };
}
