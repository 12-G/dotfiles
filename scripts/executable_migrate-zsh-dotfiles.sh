# This command moves your zsh dotfiles (.zshrc, .zsh_history, etc.)
# from the home directory to ~/.config/zsh. It's been verified to
# work correctly if you are using zsh4humans. With other zsh configs
# your mileage may vary.
#
# How to:
#
#   1. Close all terminals except one.
#   2. Copy-paste this command into the only remaining terminal.
() {
  emulate -L zsh -o err_return -o no_unset -o xtrace
  # The new ZDOTDIR relative to $HOME. You might want to
  # change this value before running the script.
  local -r zdotdir='.config/zsh'
  # The absolute path to the new ZDOTDIR.
  local -r dstdir=~/$zdotdir
  # Create the new ZDOTDIR if it does not exist.
  command mkdir -p -- $dstdir
  # The list of files to be moved from $HOME to the new ZDOTDIR.
  local -r srcs=(
    ~/.{zshenv,zprofile,zshrc,zlogin,zlogout}{,.zwc}(N)
    ~/.p10k*.zsh{,.zwc}(N)
    ~/.zsh_history(N)
  )
  # Check that all source files are regular files.
  () { (( $# == $#srcs )) } ${^srcs}(.)
  # Check that ~/.zshenv exists.
  [[ $srcs[1] == ~/.zshenv ]]
  # Copy the files to the new ZDOTDIR.
  command cp -p -- $srcs $dstdir/
  {
    # Create ~/.zshenv with the new content.
    print -rC1 -- "ZDOTDIR=~/${(q-)zdotdir}" 'source -- "$ZDOTDIR"/.zshenv' >~/.zshenv
    if (( $#srcs > 1 )); then
      # Delete all files we've copied except for ~/.zshenv.
      command rm -f -- $srcs[2,-1]
      # Verify that the files have been deleted.
      () { (( ! $# )) } ${^srcs[2,-1]}(N)
    fi
    # Unset ZDOTDIR if it's set.
    local ZDOTDIR
    unset ZDOTDIR
    # Replace the current process with a new instance of zsh.
    exec zsh
  } always {
    # If anything goes wrong, attempt to restore the original files in $HOME.
    command cp -p -- $dstdir/${^${(@)srcs:t}} ~/
  }
}
