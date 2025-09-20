{ config, ... }:
{
  config.system.activationScripts.postActivation.text = ''
    ${config.system.activationScripts.homebrewInstall.text}
    ${config.system.activationScripts.homebrewTaps.text}
    ${config.system.activationScripts.homebrewBundle.text}
  '';
}
