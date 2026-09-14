{
  plugins = {
    dap = {
      enable = true;
      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "dapBreakpointCondition";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DapBreakpointRejected";
        };
        dapLogPoint = {
          text = "";
          texthl = "DapLogPoint";
        };
        dapStopped = {
          text = "";
          texthl = "DapStopped";
        };
      };
    };
    dap-ui.enable = true;
    dap-virtual-text.enable = true;
  };

  keymaps = [
    {
      mode = "n";
      key = "<leader>db";
      action.__raw =
        # lua
        ''
          function()
            require("dap").toggle_breakpoint()
          end
        '';
      options = {
        desc = "Breakpoint toggle";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dc";
      action.__raw =
        # lua
        ''
          function()
            require("dap").continue()
          end
        '';
      options = {
        desc = "Continue Debugging (Start)";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>do";
      action.__raw =
        # lua
        ''
          function()
            require("dap").step_out()
          end
        '';
      options = {
        desc = "Step Out";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>ds";
      action.__raw =
        # lua
        ''
          function()
            require("dap").step_over()
          end
        '';
      options = {
        desc = "Step Over";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dS";
      action.__raw =
        # lua
        ''
          function()
            require("dap").step_into()
          end
        '';
      options = {
        desc = "Step Into";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>dt";
      action.__raw =
        # lua
        ''
          function() require("dap").terminate() end
        '';
      options = {
        desc = "Terminate Debugging";
        silent = true;
      };
    }
    {
      mode = "n";
      key = "<leader>du";
      action.__raw =
        # lua
        ''
          function()
            require('dap.ext.vscode').load_launchjs(nil, {})
            require("dapui").toggle()
          end
        '';
      options = {
        desc = "Toggle Debugger UI";
        silent = true;
      };
    }
  ];

  plugins.which-key.settings.spec = [
    {
      __unkeyed = "<leader>d";
      group = "Debugging";
    }
  ];
}
