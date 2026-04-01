{
  flake.modules.homeManager.base = {
    lib,
    pkgs,
    ...
  }: let
    mkValueString = v:
      with builtins; let
        err = t: v:
          abort
          ("generators.mkBtopKV: "
            + "${t} not supported: ${toPretty {} v}");
      in
        if isInt v
        then toString v
        else if lib.isDerivation v
        then toString v
        else if isString v
        then ''"${v}"''
        else if v
        then "True"
        else if !v
        then "False"
        else if null == v
        then err "null" v
        else if isList v
        then ''"${toString v}"''
        else if isAttrs v
        then err "attrsets" v
        else if isFunction v
        then err "functions" v
        else if isFloat v
        then lib.strings.floatToString v
        else err "this value is" (toString v);
    mkKeyValue = lib.generators.mkKeyValueDefault {inherit mkValueString;} "=";
  in {
    home.packages = with pkgs; [btop];
    xdg.configFile."btop/btop.conf".text = lib.generators.toKeyValue {inherit mkKeyValue;} {
      color_theme = "Default";
      theme_background = true;
      force_tty = false;
      presets = "cpu:-6:default,proc:0:default cpu:0:default,mem:0:default,net:0:default cpu:0:block,net:0:tty";
      vim_keys = true;
      rounded_corners = true;
      graph_symbol = "braille";
      graph_symbol_cpu = "default";
      graph_symbol_mem = "default";
      graph_symbol_net = "default";
      graph_symbol_proc = "default";
      shown_boxes = "cpu mem net proc";
      update_ms = 1000;
      proc_sorting = "cpu lazy";
      proc_reversed = false;
      proc_tree = false;
      proc_colors = true;
      proc_gradient = true;
      proc_per_core = true;
      proc_mem_bytes = true;
      proc_info_smaps = false;
      proc_left = false;
      cpu_graph_upper = "total";
      cpu_graph_lower = "total";
      cpu_invert_lower = true;
      cpu_single_graph = false;
      cpu_bottom = false;
      show_uptime = true;
      check_temp = true;
      cpu_sensor = "Auto";
      show_coretemp = true;
      cpu_core_map = "";
      temp_scale = "celsius";
      show_cpu_freq = true;
      clock_format = "%X";
      background_update = true;
      custom_cpu_name = "";
      disks_filter = "/ /nix /nix/state /nix/store /mnt/emp /mnt/movies /mnt/music /mnt/redacted /mnt/shows";
      mem_graphs = false;
      mem_below_net = false;
      show_swap = true;
      swap_disk = true;
      show_disks = true;
      only_physical = false;
      use_fstab = false;
      show_io_stat = true;
      io_mode = false;
      io_graph_combined = false;
      io_graph_speeds = "";
      net_download = 1024;
      net_upload = 1024;
      net_auto = false;
      net_sync = false;
      net_iface = "";
      show_battery = true;
      selected_battery = "Auto";
      log_level = "WARNING";
    };
  };
}
