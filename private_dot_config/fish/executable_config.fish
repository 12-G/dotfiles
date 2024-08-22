if status --is-login
  # Commands to run in interactive sessions can go here
  if test (tty) = /dev/tty1
    Hyprland
  end
end

# Fish_greeting
set fish_greeting

# Starship
starship init fish | source

# theme
# fish_config theme choose "Catppuccin Macchiato"
fish_config theme choose "Dracula Official"

# XDG
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx XDG_DATA_HOME "$HOME/.local/share"
set -gx XDG_CACHE_HOME "$HOME/.cache"
set -gx XDG_STATE_HOME "$HOME/.local/state"

# Editor
set -gx EDITOR nvim
set -gx VISUAL nvim

# Fcitx5-rime
set -gx GTK_IM_MODULE fcitx
set -gx QT_IM_MODULE fcitx
set -gx XMODIFIERS "@im=fcitx"
set -gx SDL_IM_MODULE fcitx
set -gx GLFW_IM_MODULE ibus

# Other software
set -gx CARGO_HOME "$XDG_CONFIG_HOME/cargo"
set -gx nimbleDIR "$XDG_CONFIG_HOME/nimble/.nimble"

# NPM
set -gx NPM_PATH "$XDG_CONFIG_HOME/node_modules"
set -gx NPM_BIN "$XDG_CONFIG_HOME/node_modules/bin"
set -gx NPM_CONFIG_PREFIX "$XDG_CONFIG_HOME/node_modules"

# xdg-ninja
set -gx GTK2_RC_FILES "$XDG_CONFIG_HOME/gtk-2.0/gtkrc"
set -gx GNUPGHOME "$XDG_DATA_HOME/gnupg"
set -gx WINEPREFIX "$XDG_DATA_HOME/wine"
