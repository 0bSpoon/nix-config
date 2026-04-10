{ ... }:
{
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.pipewire.wireplumber.extraConfig."disable-momentum4-mic" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            "node.name" =
              "alsa_input.usb-Sonova_Consumer_Hearing_MOMENTUM_4_30284BD06725A9AB3C08-01.mono-fallback";
          }
        ];
        actions.update-props."node.disabled" = true;
      }
    ];
  };
}
