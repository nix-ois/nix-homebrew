# nix-homebrew

## Usage

```nix
# flake.nix
{
  inputs = {
    nix-darwin.url = "github:nix-darwin/nix-darwin";
    nix-homebrew.url = "github:nix-ois/nix-homebrew";

    # optional third-party taps
    brewsci-bio = {
      url = "github:brewsci/homebrew-bio";
      flake = false;
    };
  };

  outputs = inputs: {
    darwinConfigurations.Johns-Mac = inputs.nix-darwin.lib.darwinSystem {
      specialArgs.inputs = inputs;
      modules = [ ./configuration.nix ];
    };
  };
}
```

```nix
# configuration.nix
{ brews, casks, inputs, ... }:
{
  imports = [ inputs.nix-homebrew.darwinModules.homebrew ];

  ois.homebrew.taps = {
    "brewsci/bio" = inputs.brewsci-bio;
  };

  ois.homebrew.brews = [
    brews.telnet
    brews."brewsci/bio/fasttree"
  ];

  ois.homebrew.casks = [
    casks.docker-desktop
    casks.spotify
  ];

  ois.homebrew.mas = {
    "Apple Configurator" = 1037126344;
    "Numbers" = 409203825;
  };
}
```
