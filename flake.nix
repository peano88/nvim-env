{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs { inherit system; };
      in
      rec	{
        packages.lbnvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          configure = {
            customRC =
              ''
                lua << EOF
                package.path = "${self}/?.lua;" .. package.path
              ''
              + pkgs.lib.readFile ./init.lua
              + ''
                EOF
              '';
            packages.myPlugins = with pkgs.vimPlugins; {
              start = with pkgs.vimPlugins; [
                nvim-lspconfig
                cmp-nvim-lsp
                nvim-cmp
                luasnip
                telescope-nvim
                telescope-file-browser-nvim
                lualine-nvim
                nvim-lightbulb
                nvim-web-devicons
                go-nvim
                nvim-dap-go
                nvim-dap-ui
                nvim-dap
                (nvim-treesitter.withPlugins (p: [
                  p.tree-sitter-yaml
                  p.tree-sitter-vim
                  p.tree-sitter-toml
                  p.tree-sitter-sql
                  p.tree-sitter-rust
                  p.tree-sitter-python
                  p.tree-sitter-nix
                  p.tree-sitter-markdown
                  p.tree-sitter-make
                  p.tree-sitter-lua
                  p.tree-sitter-json
                  p.tree-sitter-go
                  p.tree-sitter-dockerfile
                  p.tree-sitter-bash
                ]))
                tokyonight-nvim
                vim-fugitive
                harpoon
                nvim-ufo
              ];
              opt = with pkgs.vimPlugins; [
              ];
            };
          };
        };
        apps.lbnvim = flake-utils.lib.mkApp {
          drv = packages.lbnvim;
          name = "lbnvim";
          exePath = "/bin/nvim";
        };
        packages.default = packages.lbnvim;
        apps.default = apps.lbnvim;

      });
}
