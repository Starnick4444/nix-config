{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "top";
    position = "top";
    margin-left = 10;
    margin-right= 10;
    margin-top= 3;
    spacing= 1;
    margin-bottom= -15;
    modules-left= ["custom/power" "hyprland/workspaces" "custom/tomato"];
    modules-center= ["clock"];
    modules-right= ["cpu" "temperature" "memory" "pulseaudio" "network" "tray"];
    "hyprland/workspaces" = {
        on-click= "activate";
        format= "{icon}";
        format-icons= {
            "1"= "I";
            "2"= "II";
            "3"= "III";
            "4"= "IV";
            "5"= "V";
            "6"= "VI";
            "7"= "VII";
            "8"= "VIII";
            "9"= "IX";
            "10"= "X";
         };
    };
    tray= {
        icon-size= 18;
        spacing= 5;
        show-passive-items= true;
    };
    clock= {
        interval= 60;
        format= "  {:%a %b %d  %I:%M %p}"; # %b %d %Y  --Date formatting
        tooltip-format= "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
        format-alt= "{:%Y-%m-%d}";
    };
   temperature= {
        critical-threshold= 70;
        interval= 2;
	hwmon-path= "/sys/class/hwmon/hwmon4/temp1_input";
        format= " {temperatureC}°C";
        format-icons= ["🧊" "" "🔥"];
    };
    cpu= {
        interval= 2;
        format= "  {usage}%";
        tooltip= false;
    };
    memory= {
        interval= 2;
        format= "  {}%";
    };
    network= {
        format-wifi= " ";
        format-ethernet= " {ipaddr}/{cidr}";
        tooltip-format-wifi= "{essid} ({signalStrength}%) ";
        tooltip-format= "still disconnected";
        format-linked= "{ifname} (No IP) ";
        format-disconnected= "Disconnected ⚠";
        on-click= "kitty nmtui";
    };
    pulseaudio= {
        format= "{icon} {volume}%";
        format-bluetooth= "{icon} {volume}% 󰂯";
        format-bluetooth-muted= "󰖁 {icon} 󰂯";
        format-muted= "󰖁 {format_source}";
        format-source= "{volume}% ";
        format-source-muted= "";
        format-icons= {
            headphone= "󰋋";
            hands-free= "󱡒";
            headset= "󰋎";
            phone= "";
            portable= "";
            car= "";
            default= ["" "" ""];
        };
        on-click= "pavucontrol";
    };
    "custom/power" = {
      format= "{icon}";
      format-icons= "starnick";
      exec-on-event= "true";
      on-click= "poweroff";
    };
    "custom/tomato" = {
      interval= 1;
      format= {};
      exec= "tomato -t";
    };
    "custom/sepp" = {
        format= "|";
    };
      };
    };
  };
  home.packages = with pkgs; [
    inotify-tools
    tomato-c
    (pkgs.writeShellScriptBin "launch-waybar" ''
        CONFIG_FILES="$HOME/.config/waybar/noback/config $HOME/.config/waybar/noback/desc-colors.css $HOME/.config/waybar/noback/style.css $HOME/.config/waybar/desktopclock/config $HOME/.config/waybar/desktopclock/style.css $HOME/.config/waybar/desktopclock/desc-colors.css "

        trap "pkill waybar" EXIT

        while true; do
          waybar -c $HOME/.config/waybar/noback/config -s $HOME/.config/waybar/noback/style.css &
          waybar -c $HOME/.config/waybar/desktopclock/config -s $HOME/.config/waybar/desktopclock/style.css &
          inotifywait -e create,modify $CONFIG_FILES
          pkill waybar
        done
    '')
  ];
  home.file.".config/waybar".source = config.lib.file.mkOutOfStoreSymlink ./waybar;
}
