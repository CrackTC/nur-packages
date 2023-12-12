{ config, pkgs, lib, ... }:
let
  hpfan = pkgs.callPackage ../pkgs/hpfan { };
  cfg = config.services.hpfan;
  mkArg = defaultValue: name: value:
    if value == defaultValue then [ ] else [ name (toString value) ];
  mkArgs = args:
    lib.strings.concatStringsSep " " (builtins.concatLists args);
in
{
  options = {
    services.hpfan = {
      enable = lib.mkEnableOption "hpfan";
      temperatureFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to the file containing the temperature in millidegrees Celsius";
        example = "/sys/class/thermal/thermal_zone1/temp";
      };
      pwmFile = lib.mkOption {
        type = lib.types.str;
        default = "";
        description = "Path to the file containing the PWM value";
        example = "/sys/class/hwmon/hwmon5/pwm1_enable";
      };
      wall = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "The temperature at which the fan should boost";
        example = 50000;
      };
    };
  };

  config =
    let
      args = mkArgs [
        (mkArg "" "-t" cfg.temperatureFile)
        (mkArg "" "-p" cfg.pwmFile)
        (mkArg null "-w" cfg.wall)
      ];
    in
    lib.mkIf cfg.enable {
      systemd.services.hpfan = {
        description = "HP fan control";
        after = [ "sysinit.target" ];
        serviceConfig = {
          User = "root";
          ExecStart = "${hpfan}/bin/hpfan ${args}";
          Restart = "always";
        };
        wantedBy = [ "multi-user.target" ];
      };
    };
}
