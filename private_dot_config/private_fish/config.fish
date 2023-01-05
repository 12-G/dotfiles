if status is-interactive
    # Commands to run in interactive sessions can go here
end

# Fish_greeting
set -g fish_greeting

# Environments
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx CARGO_HOME "$XDG_CONFIG_HOME/cargo"
set -gx nimbleDir "XDG_CONFIG_HOME/nimble/.nimble/"

# Neovim
set -gx EDITOR nvim

# Make su launch fish
function su
   command su --shell=/usr/bin/fish $argv
end

# Get terminal emulator
set TERM_EMULATOR (ps -aux | grep (ps -p $fish_pid -o ppid=) | awk 'NR==1{print $11}')

# Nitch
nitch

