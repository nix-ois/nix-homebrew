{ config, pkgs, ... }:
let
  cfg = config.ois.homebrew;

  brew-wrapper = pkgs.writeScript "brew" ''
    #!/bin/sh
    HOMEBREW_NO_AUTO_UPDATE=1 \
    HOMEBREW_NO_INSTALL_FROM_API=1 \
    HOMEBREW_CELLAR=${cfg.prefix}/Cellar \
    HOMEBREW_PREFIX=${cfg.prefix} \
    HOMEBREW_REPOSITORY=${cfg.prefix} \
    exec ${cfg.prefix}/bin/.brew-wrapped "$@"
  '';

  install = ''
    uid=$(id -u "$(logname)")
    gid=$(id -g "$(logname)")
    ${pkgs.rsync}/bin/rsync \
      --archive \
      --owner --group --chown="$uid:$gid" \
      --perms --chmod=u+w \
      ${cfg.package}/ ${cfg.prefix}
    cd ${cfg.prefix}
    mv bin/brew bin/.brew-wrapped
    ln -s ${brew-wrapper} bin/brew
    mkdir -p .nix
    find ${cfg.package} ! -type d > .nix/files
    echo ${cfg.package.rev} > .nix/rev
  '';

  uninstall = ''
    if cd ${cfg.prefix} 2>/dev/null; then
      xargs rm -f < .nix/files
      rm -f bin/.brew-wrapped
      rm -rf Library/Homebrew/vendor/portable-ruby
    fi
  '';
in
{
  system.activationScripts.preActivation.text = ''
    if [ -e ${cfg.prefix} ] && ! [ -e ${cfg.prefix}/.nix/rev ]; then
      printf >&2 '\e[1;31m%s\e[0m\n' "error: homebrew installation already present but not managed by nix"
      exit 2
    fi
  '';

  system.activationScripts.homebrewInstall.text = ''
    if [ "$(cat ${cfg.prefix}/.nix/rev 2>/dev/null)" != ${cfg.package.rev} ]; then
      echo "installing homebrew..." >&2
      ( ${uninstall} )
      ( ${install} )
    fi
  '';
}
