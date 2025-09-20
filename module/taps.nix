{
  config,
  lib,
  pkgs,
  ...
}:
let
  taps = lib.pipe config.ois.homebrew.taps [
    (builtins.mapAttrs (
      name: value: ''
        mkdir -p $out/${builtins.dirOf name}
        ln -s ${value} $out/${builtins.dirOf name}/homebrew-${builtins.baseNameOf name}
      ''
    ))
    builtins.attrValues
    lib.concatLines
    (pkgs.runCommand "Taps" { })
  ];
in
{
  system.activationScripts.homebrewTaps.text = ''
    uid=$(id -u "$(logname)")
    gid=$(id -g "$(logname)")
    ${pkgs.rsync}/bin/rsync \
      --archive --delete \
      --owner --group --chown="$uid:$gid" \
      --perms --chmod=u+w \
      ${taps}/ ${config.ois.homebrew.prefix}/Library/Taps
  '';
}
