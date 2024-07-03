{ config, pkgs, lib, ... }:
let
  hpfan = pkgs.callPackage ../pkgs/hpfan { };
  exec = pkgs.writeScript "hpfan" ''
    #!${pkgs.fish}/bin/fish
    ${hpfan}/bin/hpfan $argv >/dev/null 2>&1 &
    while true
      echo -n -e "\x31" | dd of=/sys/kernel/debug/ec/ec0/io bs=1 seek=149 count=1 conv=notrunc >/dev/null 2>&1
      sleep 30
    end
  '';
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
        example = "/sys/class/hwmon/hwmon*/pwm1_enable";
      };
      wallLow = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = null;
        description = "The temperature at which the fan should stop boosting";
        example = 45000;
      };
      wallHigh = lib.mkOption {
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
        (mkArg null "-L" cfg.wallLow)
        (mkArg null "-H" cfg.wallHigh)
      ];
    in
    lib.mkIf cfg.enable {
      systemd.services.hpfan = {
        description = "HP fan control";
        after = [ "sysinit.target" ];
        serviceConfig = {
          User = "root";
          ExecStart = "${exec} ${args}";
          Restart = "always";
        };
        wantedBy = [ "multi-user.target" ];
      };

      boot.kernelModules = [ "ec_sys" ];
      boot.extraModprobeConfig = ''
        options ec_sys write_support=1
      '';
    };
}
