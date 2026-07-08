data = {
  ["GUID"] = "853d88",
  ["memo"] = {
    ["number"] = 44,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 49
            },
            {
              ["type"] = "resetScenarioCounter",
              ["counter"] = "hp"
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 48
            },
            {
              ["type"] = "resetScenarioCounter",
              ["counter"] = "sanity"
            }
          }
        }
      }
    }
  }
}
