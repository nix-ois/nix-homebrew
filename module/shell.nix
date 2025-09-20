{ config, ... }:
{
  programs.bash.interactiveShellInit = ''
    eval "$(${config.ois.homebrew.prefix}/bin/brew shellenv bash)"
  '';

  programs.zsh.interactiveShellInit = ''
    eval "$(${config.ois.homebrew.prefix}/bin/brew shellenv zsh)"
  '';

  programs.fish.interactiveShellInit = ''
    eval (${config.ois.homebrew.prefix}/brew shellenv fish)
  '';
}
