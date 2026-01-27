{
  inputs = {
    homebrew = {
      url = "github:homebrew/brew/5.0.12";
      flake = false;
    };

    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };

    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };

    xcode-cli-tools.url = "github:nix-ois/nix-xcode-cli-tools";
  };

  outputs = inputs: {
    darwinModules.homebrew =
      { lib, ... }:
      {
        imports = [
          inputs.xcode-cli-tools.darwinModules.xcode-cli-tools
          ./module
        ];

        ois.homebrew = {
          package = lib.mkDefault inputs.homebrew;
          taps = {
            "homebrew/core" = lib.mkDefault inputs.homebrew-core;
            "homebrew/cask" = lib.mkDefault inputs.homebrew-cask;
          };
        };
      };
  };
}
