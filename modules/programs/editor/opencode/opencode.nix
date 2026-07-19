{
  home-manager.sharedModules = [
    ({ config, ... }: {
      xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
        "$schema" = "https://opencode.ai/config.json";
        instructions = [ "${config.xdg.configHome}/opencode/AGENTS.md" ];
        mcp = {
          codegraph = {
            type = "local";
            command = [
              "codegraph"
              "serve"
              "--mcp"
            ];
            enabled = true;
          };
          openpets = {
            type = "local";
            command = [
              "npx"
              "-y"
              "@open-pets/cli@latest"
              "mcp"
            ];
            enabled = true;
          };
        };

        provider = {
          sakana = {
            name = "Sakana";
            options = {
              apiKey = "{env:SAKANA_API_KEY}";
              baseURL = "https://api.sakana.ai/v1";
            };
            models.fugu = {
              name = "Fugu";
              cost = {
                input = 5;
                output = 30;
              };
            };
          };
          vl = {
            name = "Vilao";
            options = {
              apiKey = "{env:VILAO_API_KEY}";
              baseURL = "https://api.vilao.ai/v1";
            };
            models = {
              consultant = {
                name = "Vilao Consultant";
                options.thinking.type = "enabled";
              };
              implementor = {
                name = "Vilao Implementor";
                options.thinking.type = "enabled";
              };
              oracle = {
                name = "Vilao Oracle";
                options.thinking.type = "enabled";
              };
            };
          };
        };

        agent = {
          oracle = {
            description = "Designs system";
            mode = "primary";
            model = "vl/oracle";
            prompt = "You strategic technical advisor and code reviewer. You advise, you do not implement. Focus on strategy, not execution. Explain reasoning briefly to user, let user read, wait user approval before use subagents to write or read code. When plan, check if task hard by point. Default 5, larger is harder. If point bigger than 8 debate with @consultant else, you skip consultant. You control yourself and you read yourself and you review yourself, implementor agent code write. Ask implementor to fix if incorrect. Final report direct and concise with risks, file changes.";
            permission = {
              edit = "deny";
              bash = "deny";
              tool = "allow";
              task = "allow";
            };
          };
          general = {
            description = "General purpose";
            mode = "primary";
            model = "openai/gpt-5.4";
            prompt = "General agent. Solve in scope. Simple direct code. Ask only if blocked. No defensive fallbacks/checks unless boundary/contract requires.";
            permission = {
              edit = "allow";
              bash = "allow";
              tool = "allow";
            };
          };
          consultant = {
            description = "Consults with architect";
            mode = "subagent";
            model = "vl/consultant";
            prompt = "Architecture consultant. Take question from oracle and debate about the task, give advise for the plan, compare and choose simplest implementation path. Ask clarifying when requirement unclear. Focus on module boundaries, data flow, affected files, risks, tradeoffs. Report back with decision-focused report.";
            permission = {
              edit = "deny";
              bash = "deny";
              tool = "allow";
              task = "allow";
            };
          };
          explore = {
            description = "Explores codebase";
            mode = "subagent";
            subagent_type = "explore";
            model = "openai/gpt-5.4";
            prompt = "Explore agent. No edits. Find only relevant files, logic, tests, risks. Do not scan unrelated files. Do not repeat previous scans. Report concise.";
            permission = {
              edit = "deny";
              bash = "allow";
              tool = "allow";
            };
          };
          implement = {
            description = "Main implementor";
            mode = "subagent";
            subagent_type = "implement";
            model = "vl/implementor";
            prompt = "Implement assigned scope only. Minimal direct edits. No unrelated files. Simple > clever. Do not run tests. Do not run lint or type check.";
            permission = {
              edit = "allow";
              bash = "allow";
              tool = "allow";
            };
          };
          support = {
            description = "Main implementor";
            mode = "subagent";
            subagent_type = "implement";
            model = "openai/gpt-5.4";
            prompt = "Implement assigned scope only. Minimal direct edits. No unrelated files. Simple > clever. Do not run tests. Do not run lint or type check.";
            permission = {
              edit = "allow";
              bash = "allow";
              tool = "allow";
            };
          };
        };

        plugin = [
          "superpowers@git+https://github.com/obra/superpowers.git"
          "@open-pets/opencode@latest"
          "@dietrichgebert/ponytail"
        ];
      };
    })
  ];
}
