{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        name = "main";
        layer = "top";
        position = "top";
        margin-left = 10;
        margin-right = 10;
        margin-top = 3;
        spacing = 1;
        margin-bottom = -15;
        modules-left = ["custom/power" "hyprland/workspaces" "custom/tomato"];
        modules-center = ["clock"];
        modules-right = ["battery" "cpu" "temperature" "memory" "pulseaudio" "network" "tray"];
        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            "1" = "I";
            "2" = "II";
            "3" = "III";
            "4" = "IV";
            "5" = "V";
            "6" = "VI";
            "7" = "VII";
            "8" = "VIII";
            "9" = "IX";
            "10" = "X";
          };
        };
        tray = {
          icon-size = 18;
          spacing = 5;
          show-passive-items = true;
        };
        clock = {
          interval = 60;
          format = "  {:%a %b %d  %I:%M %p}"; # %b %d %Y  --Date formatting
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%Y-%m-%d}";
        };
        temperature = {
          critical-threshold = 70;
          interval = 2;
          hwmon-path = "/sys/class/hwmon/hwmon4/temp1_input";
          format = " {temperatureC}°C";
          format-icons = ["🧊" "" "🔥"];
        };
        cpu = {
          interval = 2;
          format = "  {usage}%";
          tooltip = false;
        };
        battery = {
          interval = 30;
          format = "{capacity}%";
          tooltip = false;
        };
        memory = {
          interval = 2;
          format = "  {}%";
        };
        network = {
          format-wifi = " ";
          format-ethernet = " {ipaddr}/{cidr}";
          tooltip-format-wifi = "{essid} ({signalStrength}%) ";
          tooltip-format = "still disconnected";
          format-linked = "{ifname} (No IP) ";
          format-disconnected = "Disconnected ⚠";
        };
        pulseaudio = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}% 󰂯";
          format-bluetooth-muted = "󰖁 {icon} 󰂯";
          format-muted = "󰖁 {format_source}";
          format-source = "{volume}% ";
          format-source-muted = "";
          format-icons = {
            headphone = "󰋋";
            hands-free = "󱡒";
            headset = "󰋎";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
          on-click = "pavucontrol";
        };
        "custom/power" = {
          format = "{icon}";
          format-icons = "starnick";
          exec-on-event = "true";
          on-click = "poweroff";
        };
        "custom/tomato" = {
          interval = 1;
          format = {};
          exec = "tomato -t";
        };
        "custom/sepp" = {
          format = "|";
        };
      };
      timerBar = {
        name = "timer";
        layer = "bottom";
        position = "bottom";
        exclusive = false;
        margin-left = 0;
        margin-right = 0;
        margin-top = 0;
        margin-bottom = 80;

        modules-left = ["timer"];
        modules-center = [];
        modules-right = [];

        timer = {
          interval = 60;
          format = "{:%I:%M %p \n<span size='xx-small'>%a %b %d </span>}";
        };
      };
    };
    style = ''
                   /*
                   *
                   * Base16 Outrun Dark
                   * Author: Hugo Delahousse (http://github.com/hugodelahousse/)
                   *
                   */

      	     @define-color base00 #3d1c2f;
      @define-color base01 #674d5c;
             @define-color base02 #907f8a;
             @define-color base03 #bab0b7;
             @define-color base04 #e4e2e4;
             @define-color base05 #ffffff;
             @define-color base06 #ffffff;
             @define-color base07 #ffffff;
             @define-color base08 #887468;
             @define-color base09 #767976;
             @define-color base0A #847380;
             @define-color base0B #cd4e3c;
             @define-color base0C #806ac5;
             @define-color base0D #8e53fb;
             @define-color base0E #6438ff;
             @define-color base0F #9122ff;

                   * {
                     min-height: 0;
                     font-family: FiraCode Nerd Font , "Hack Nerd Font", FontAwesome, Roboto,
                       Helvetica, Arial, sans-serif;
                     font-size: 14px;
                   }

                   window.main#waybar {
                     color: @base06;
                     background: @base00;
                     transition-property: background-color;
                     transition-duration: 0.5s;
                   }

                   window.main#waybar.empty {
                     opacity: 0.3;
                   }

                   .modules-left {
                       border: none;
                   }

                   .modules-right {
                     border: none;
                   }

                   .modules-center {
                     border: none;
                   }

                   button {
                     border: none;
                     border-radius: 0;
                   }

                   button:hover {
                     background: @base03;
                     border-radius: 90px;
                   }

                   #custom-power {
                     color: @base01;
                     font-weight: 600;
                     margin-right: 10px;
                     padding-left: 15px;
                     padding-right: 19px;
                     border-radius: 90px;
                     background: @base0E;
                   }

                   #workspaces {
                     font-weight: 600;
                     margin-right: 10px;
                     padding: 5px 10px;
                     border-radius: 90px;
                     background: @base01;
                   }

                   #workspaces button {
                     color: @base0F;
                       font-weight: 600;
                           margin: 0px;
                           padding: 0px 5px;
                   }

                   #workspaces button.urgent {
                     color: @base09;
                   }
                   #workspaces button.empty {
                     color: @base03;
                   }

                   #workspaces button.active {
                     color: @base06;
                   }

                   #workspaces button.focused {
                     color: @base0C;
                   }
                   #custom-tomato,
                   #cpu,
            #battery,
                   #temperature,
                   #memory,
                   #disk {
                     color: @base0F;
                     font-weight: 600;
                     margin-right: 10px;
                     padding: 6px 15px;
                     border-radius: 90px;
                     background: @base01;
                   }

                   #pulseaudio {
                     color: @base01;
                     font-weight: 600;
                     margin-right: 10px;
                     padding: 6px 15px;
                     border-radius: 90px;
                     background: @base0A;
                   }

                   #network {
                     color: @base01;
                     font-weight: 600;
                     margin-right: 10px;
                     padding: 6px 15px;
                     border-radius: 90px;
                     background: @base0D;
                   }

                   #tray {
                     color: @base06;
                     font-weight: 600;
                     padding: 6px 15px;
                     border-radius: 90px;
                     background: @base01;
                   }

                   #clock {
                     color: @base0F;
                     font-weight: 600;
                     margin-right: 10px;
                     padding: 6px 15px;
                     border-radius: 90px;
                     background: @base01;
                   }

                   #custom-sepp {
                     color: @base03;
                     font-size: 20px;
                     padding-left: 4px;
                     padding-right: 10px;
                   }

                   #network.disconnected {
                     background-color: @base09;
                   }

            window.timer#waybar {
              background: 00;
            }

             #timer {
                 margin-left: 100px;
                 font-weight: 300;
                 font-size: 48pt;
                 color: @base05;
             }
    '';
  };
  home.packages = with pkgs; [
    inotify-tools
    tomato-c
    networkmanagerapplet
  ];
  # home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./waybar;
}
