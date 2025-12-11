{
  description = "My own Neovim flake";
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixpkgs-unstable";
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixneovimplugins.url = "github:NixNeovim/NixNeovimPlugins";
    #vim-extra-plugins.url = "github:m15a/nixpkgs-vim-extra-plugins";
    #vim-extra-plugins.url = "github:developing-today-forks/nixpkgs-vim-extra-plugins";
    presenting_nvim = {
        url = "github:sotte/presenting.nvim";
        flake = false;
    };
    bazel_nvim = {
        url = "github:peano88/bazel_nvim";
        flake = false;
    };
  };
  outputs = inputs @ { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = import nixpkgs {
        inherit system;
        overlays = [
            inputs.nixneovimplugins.overlays.default
            (self: super: {
                vimPlugins = super.vimPlugins // {
                    presenting_nvim = super.vimUtils.buildVimPlugin {
                        pname = "presenting.nvim";
                        name = "presenting.nvim";
                        src = inputs.presenting_nvim;
                    };
                    bazel_nvim = super.vimUtils.buildVimPlugin {
                        pname = "bazel_nvim";
                        name = "bazel_nvim";
                        src = inputs.bazel_nvim;
                    };
                };
            })
        ];
      };
      python_pkgs = ps: with ps; [
        pynvim
        python-dotenv
        requests
        prompt-toolkit
      ];

      in
      rec	{
        packages.lbnvim = pkgs.wrapNeovim pkgs.neovim-unwrapped {
          viAlias = true;
          vimAlias = true;
          withPython3 = true;
          extraPython3Packages = python_pkgs;
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
                nvim-web-devicons
                go-nvim
                nvim-dap-go
                nvim-dap-ui
                nvim-dap
                nvim-dap-virtual-text
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
                  p.tree-sitter-diff
                  p.tree-sitter-haskell
                ]))
                tokyonight-nvim
                vim-fugitive
                harpoon
                nvim-ufo
                pkgs.vimExtraPlugins.guihua-lua
                refactoring-nvim
                glow-nvim
                nvim-notify
                vim-bazel
                vim-maktaba
                copilot-lua
                pkgs.vimExtraPlugins.CopilotChat-nvim
                presenting_nvim
                which-key-nvim
                bazel_nvim
                oil-nvim
                mini-nvim
                plenary-nvim
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
        devShell = pkgs.mkShell {
          buildInputs = with pkgs; [
            packages.lbnvim
            git
            fd
            ripgrep
            fzf
            ];
        };

      });
}
