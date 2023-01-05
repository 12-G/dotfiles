function upd --wraps='sudo pacman -Syyu' --description 'alias upd sudo pacman -Syyu'
  sudo pacman -Syyu $argv; 
end
