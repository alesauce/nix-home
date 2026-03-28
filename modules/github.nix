{
  flake.modules.homeManager.base = {
    programs = {
      gh = {
        enable = true;
        settings.git_protocol = "ssh";
      };

      gh-dash = {
        enable = true;
        settings = {
          prSections = [
            {
              title = "My Pull Requests";
              filters = "is:open author:@me";
            }
          ];
        };
      };
    };
  };
}
