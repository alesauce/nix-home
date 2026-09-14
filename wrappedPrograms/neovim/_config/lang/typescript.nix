{
  config = {
    autoCmd = [
      {
        event = "FileType";
        pattern = "typescript";
        command = "setlocal tabstop=2 shiftwidth=2";
      }
    ];

    plugins.typescript-tools = {
      enable = true;
      settings = {
        settings = {
          code_lens = "off";
          separate_diagnostic_server = true;
          tsserver_file_preferences = {
            quotePreference = "single";
            includeCompletionsWithClassMemberSnippets = true;
            # Inlay Hints
            includeInlayParameterNameHints = "all";
            includeInlayParameterNameHintsWhenArgumentMatchesName = true;
            includeInlayFunctionParameterTypeHints = true;
            includeInlayVariableTypeHints = true;
            includeInlayVariableTypeHintsWhenTypeMatchesName = true;
            includeInlayPropertyDeclarationTypeHints = true;
            includeInlayFunctionLikeReturnTypeHints = true;
            includeInlayEnumMemberValueHints = true;
          };
          complete_function_calls = true;
          include_completions_with_insert_text = true;
          tsserver_format_options = {
            semicolons = "insert";
          };
        };
      };
    };
  };
}
