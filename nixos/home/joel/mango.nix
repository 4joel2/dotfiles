{
  inputs,
  ...
}:

{
  imports = [
    inputs.mangowm.hmModules.mango
  ];

  wayland.windowManager.mango = {
    enable = true;

    # Mango startet die Desktop-Shell beim Beginn der Sitzung.
    autostart_sh = ''
      noctalia --daemon &
    '';

    settings = {
      # Automatische Monitor-Konfiguration. Spezifische Monitorregeln können
      # später ergänzt werden, sobald die tatsächlichen Ausgangsnamen feststehen.
      monitorrule = "name:*,width:0,height:0,refresh:0,x:0,y:0,scale:1";

      env = [
        "XDG_CURRENT_DESKTOP,mango"
        "QT_QPA_PLATFORM,wayland"
        "ELECTRON_OZONE_PLATFORM_HINT,auto"
        "TERMINAL,ghostty"
      ];

      # Eingabe – entspricht weitgehend der bisherigen Niri-Konfiguration.
      repeat_rate = 25;
      repeat_delay = 600;
      numlockon = 1;
      xkb_rules_layout = "de";
      tap_to_click = 1;
      tap_and_drag = 1;
      drag_lock = 1;
      trackpad_natural_scrolling = 1;
      disable_while_typing = 1;
      middle_button_emulation = 1;
      mouse_natural_scrolling = 0;

      # Niris Spaltenlayout entspricht in Mango am ehesten "scroller".
      scroller_structs = 20;
      scroller_default_proportion = 0.5;
      scroller_default_proportion_single = 0.5;
      scroller_ignore_proportion_single = 0;
      scroller_proportion_preset = "0.33333,0.5,0.66667";
      scroller_focus_center = 0;
      scroller_prefer_center = 0;
      scroller_prefer_overspread = 1;
      edge_scroller_pointer_focus = 1;
      circle_layout = "scroller,tile,monocle";

      # Fokus und Verhalten.
      sloppyfocus = 1;
      warpcursor = 1;
      focus_cross_monitor = 0;
      focus_cross_tag = 0;
      drag_tile_to_tile = 1;
      no_border_when_single = 0;

      # Optik nach dem Vorbild der Niri-Konfiguration.
      gappih = 10;
      gappiv = 10;
      gappoh = 10;
      gappov = 10;
      borderpx = 2;
      border_radius = 12;
      focuscolor = "0x808080ff";
      bordercolor = "0x505050ff";
      urgentcolor = "0xcc4444ff";
      focused_opacity = 1.0;
      unfocused_opacity = 0.9;

      blur = 0;
      shadows = 1;
      shadow_only_floating = 1;
      shadows_size = 15;
      shadows_blur = 30;
      shadows_position_x = 0;
      shadows_position_y = 5;
      shadowscolor = "0x00000077";

      # Kurze, unaufdringliche Animationen wie bei Niri.
      animations = 1;
      layer_animations = 1;
      animation_type_open = "slide";
      animation_type_close = "slide";
      animation_fade_in = 1;
      animation_fade_out = 1;
      tag_animation_direction = 1;
      animation_duration_open = 150;
      animation_duration_close = 150;
      animation_duration_move = 200;
      animation_duration_tag = 250;
      animation_curve_open = "0.16,1,0.3,1";
      animation_curve_close = "0.25,1,0.5,1";
      animation_curve_move = "0.16,1,0.3,1";
      animation_curve_tag = "0.16,1,0.3,1";

      # Übersicht ohne Hot-Corner, wie zuvor in Niri.
      enable_hotarea = 0;
      ov_tab_mode = 1;
      ov_no_resize = 1;
      overviewgappi = 10;
      overviewgappo = 30;

      # Alle neun Tags verwenden standardmäßig das Scroller-Layout.
      tagrule = map (id: "id:${toString id},layout_name:scroller") [
        1 2 3 4 5 6 7 8 9
      ];

      windowrule = [
        "focused_opacity:0.9,appid:com.mitchellh.ghostty"
        "isfloating:1,appid:^(org.gnome.Calculator|galculator|blueman-manager|org.gnome.Nautilus|steam|xdg-desktop-portal)$"
        "isfloating:1,appid:firefox,title:^Picture-in-Picture$"
        "allow_csd:0,appid:^(com.mitchellh.ghostty|Alacritty|kitty)$"
      ];

      layerrule = [
        "animation_type_open:zoom,layer_name:^(fuzzel|launcher)$"
        "animation_type_close:zoom,layer_name:^(fuzzel|launcher)$"
      ];

      bind = [
        # System und Übersicht
        "SUPER,O,toggleoverview"
        "SUPER,Tab,toggleoverview"
        "SUPER+ALT,R,reload_config"

        # Programme und Noctalia
        "SUPER,Return,spawn,ghostty"
        "SUPER+SHIFT,B,spawn,helium-browser"
        "SUPER,D,spawn,fuzzel"
        "SUPER,V,spawn,noctalia msg panel-toggle clipboard"
        "SUPER,M,spawn,ghostty -e btop"
        "SUPER,Comma,spawn,noctalia msg settings-toggle"
        "SUPER,Y,spawn,noctalia msg panel-toggle wallpaper"
        "SUPER,N,spawn,noctalia msg panel-toggle control-center notifications"

        # Sitzung
        "SUPER+ALT,L,spawn,noctalia msg session lock"
        "SUPER+SHIFT,E,quit"
        "CTRL+ALT,Delete,spawn,ghostty -e btop"
        "SUPER+SHIFT,P,spawn,noctalia msg dpms-off"

        # Lautstärke und Helligkeit
        "NONE,XF86AudioRaiseVolume,spawn,noctalia msg volume-up 3"
        "NONE,XF86AudioLowerVolume,spawn,noctalia msg volume-down 3"
        "NONE,XF86AudioMute,spawn,noctalia msg volume-mute"
        "NONE,XF86AudioMicMute,spawn,noctalia msg mic-mute"
        "NONE,XF86MonBrightnessUp,spawn,noctalia msg brightness-up current 5"
        "NONE,XF86MonBrightnessDown,spawn,noctalia msg brightness-down current 5"
        "NONE,XF86AudioNext,spawn,noctalia msg media next"
        "NONE,XF86AudioPrev,spawn,noctalia msg media previous"
        "NONE,XF86AudioPlay,spawn,noctalia msg media toggle"

        # Fensterzustände
        "SUPER+SHIFT,Q,killclient"
        "SUPER,F,togglemaximizescreen"
        "SUPER+SHIFT,F,togglefullscreen"
        "SUPER+SHIFT,T,togglefloating"
        "SUPER,W,switch_layout"

        # Fokus – Pfeile und Vim-Tasten wie in Niri
        "SUPER,Left,focusdir,left"
        "SUPER,Down,focusdir,down"
        "SUPER,Up,focusdir,up"
        "SUPER,Right,focusdir,right"
        "SUPER,H,focusdir,left"
        "SUPER,J,focusdir,down"
        "SUPER,K,focusdir,up"
        "SUPER,L,focusdir,right"

        # Fenster verschieben
        "SUPER+SHIFT,Left,exchange_client,left"
        "SUPER+SHIFT,Down,exchange_client,down"
        "SUPER+SHIFT,Up,exchange_client,up"
        "SUPER+SHIFT,Right,exchange_client,right"
        "SUPER+SHIFT,H,exchange_client,left"
        "SUPER+SHIFT,J,exchange_client,down"
        "SUPER+SHIFT,K,exchange_client,up"
        "SUPER+SHIFT,L,exchange_client,right"

        # Monitore
        "SUPER+CTRL,Left,focusmon,left"
        "SUPER+CTRL,Right,focusmon,right"
        "SUPER+CTRL,H,focusmon,left"
        "SUPER+CTRL,J,focusmon,down"
        "SUPER+CTRL,K,focusmon,up"
        "SUPER+CTRL,L,focusmon,right"
        "SUPER+SHIFT+CTRL,Left,tagmon,left"
        "SUPER+SHIFT+CTRL,Down,tagmon,down"
        "SUPER+SHIFT+CTRL,Up,tagmon,up"
        "SUPER+SHIFT+CTRL,Right,tagmon,right"
        "SUPER+SHIFT+CTRL,H,tagmon,left"
        "SUPER+SHIFT+CTRL,J,tagmon,down"
        "SUPER+SHIFT+CTRL,K,tagmon,up"
        "SUPER+SHIFT+CTRL,L,tagmon,right"

        # Tags: U/PageDown = nächster, I/PageUp = vorheriger
        "SUPER,Page_Down,viewtoright,0"
        "SUPER,Page_Up,viewtoleft,0"
        "SUPER,U,viewtoright,0"
        "SUPER,I,viewtoleft,0"
        "SUPER+CTRL,Down,tagtoright,0"
        "SUPER+CTRL,Up,tagtoleft,0"
        "SUPER+CTRL,U,tagtoright,0"
        "SUPER+CTRL,I,tagtoleft,0"

        # Nummerierte Tags
        "SUPER,1,view,1,0"
        "SUPER,2,view,2,0"
        "SUPER,3,view,3,0"
        "SUPER,4,view,4,0"
        "SUPER,5,view,5,0"
        "SUPER,6,view,6,0"
        "SUPER,7,view,7,0"
        "SUPER,8,view,8,0"
        "SUPER,9,view,9,0"
        "SUPER+SHIFT,1,tag,1,0"
        "SUPER+SHIFT,2,tag,2,0"
        "SUPER+SHIFT,3,tag,3,0"
        "SUPER+SHIFT,4,tag,4,0"
        "SUPER+SHIFT,5,tag,5,0"
        "SUPER+SHIFT,6,tag,6,0"
        "SUPER+SHIFT,7,tag,7,0"
        "SUPER+SHIFT,8,tag,8,0"
        "SUPER+SHIFT,9,tag,9,0"

        # Scroller: Spaltenbreite und Stapeln
        "SUPER,R,switch_proportion_preset"
        "SUPER+CTRL,F,set_proportion,1.0"
        "SUPER,BracketLeft,scroller_stack,left"
        "SUPER,BracketRight,scroller_stack,right"
        "SUPER,Period,scroller_stack,right"
        "SUPER,Minus,set_proportion,0.33333"
        "SUPER,Plus,set_proportion,0.66667"
        "SUPER+SHIFT,R,switch_layout"

        # Screenshots über Noctalia
        "NONE,Print,spawn,noctalia msg screenshot-region"
        "CTRL,Print,spawn,noctalia msg screenshot-fullscreen all"
        "ALT,Print,spawn,noctalia msg screenshot-region"
      ];

      axisbind = [
        "SUPER,DOWN,viewtoright_have_client,0"
        "SUPER,UP,viewtoleft_have_client,0"
        "SUPER+CTRL,DOWN,tagtoright,0"
        "SUPER+CTRL,UP,tagtoleft,0"
        "SUPER+SHIFT,DOWN,focusdir,right"
        "SUPER+SHIFT,UP,focusdir,left"
      ];

      mousebind = [
        "SUPER,btn_left,moveresize,curmove"
        "SUPER,btn_right,moveresize,curresize"
      ];
    };
  };
}
