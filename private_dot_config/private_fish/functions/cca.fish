function cca --wraps='sudo pacman -Rns ' --description 'alias cca sudo pacman -Rns '
  sudo pacman -Rns  $argv; 
end
