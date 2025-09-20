{ config, lib, ... }:
let
  cfg = config.ois.homebrew;

  rubyEscape = lib.escape [
    "\""
    "#"
  ];

  taps = map (x: ''tap "${x}"'') (builtins.attrNames cfg.taps);
  brews = map (x: ''brew "${x.name}"'') cfg.brews;
  casks = map (x: ''cask "${x.name}", greedy: true'') cfg.casks;
  mas = map (x: ''mas "${rubyEscape x.name}", id: ${toString x.value}'') (lib.attrsToList cfg.mas);

  brewfile = builtins.toFile "Brewfile" ''
    cask_args no_quarantine: true
    ${lib.concatLines (taps ++ brews ++ casks ++ mas)}
  '';
in
{
  system.activationScripts.homebrewBundle.text = ''
    echo "homebrew bundle..." >&2
    sudo --set-home --user="$(logname)" -- \
    ${cfg.prefix}/bin/brew bundle \
      --cleanup --quiet \
      --file ${brewfile}
  '';
}
