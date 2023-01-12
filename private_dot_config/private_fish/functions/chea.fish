function chea --wraps='chezmoi edit --apply' --description 'alias chea chezmoi edit --apply'
  chezmoi edit --apply $argv; 
end
