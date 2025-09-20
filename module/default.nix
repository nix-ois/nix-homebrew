{ lib, ... }:
let
  mkOptionType =
    type:
    lib.mkOptionType {
      name = type;
      check = x: x.type or null == type;
    };
in
{
  imports = [
    ./activation.nix
    ./args.nix
    ./bundle.nix
    ./install.nix
    ./shell.nix
    ./taps.nix
  ];

  options.ois.homebrew = {
    package = lib.mkOption {
      type = lib.types.pathInStore;
    };

    prefix = lib.mkOption {
      readOnly = true;
      default = "/opt/homebrew";
    };

    taps = lib.mkOption {
      type = lib.types.attrsOf lib.types.pathInStore;
      default = { };
      apply =
        taps:
        builtins.deepSeq (lib.pipe taps [
          builtins.attrNames
          (map (
            tapName:
            if
              builtins.match "[0-9A-Za-z]+/[0-9A-Za-z]+" tapName == null || lib.hasInfix "/homebrew-" tapName
            then
              throw ''
                Invalid tap name ${lib.strings.escapeNixIdentifier tapName}.
                Must be in format "user/repo", without "homebrew-" prefix.
                See https://docs.brew.sh/Taps.
              ''
            else
              tapName
          ))
        ]) taps;
    };

    brews = lib.mkOption {
      type = lib.types.listOf (mkOptionType "brew");
      default = [ ];
    };

    casks = lib.mkOption {
      type = lib.types.listOf (mkOptionType "cask");
      default = [ ];
    };

    mas = lib.mkOption {
      type = lib.types.attrsOf lib.types.ints.unsigned;
      default = { };
    };
  };
}
