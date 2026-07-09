data = {
  ["GUID"] = "176e57",
  ["memo"] = {
    ["number"] = 93,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Return cards",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["numbers"] = {
                94,
                95
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 99",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "93",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 99
            }
          }
        },
        {
          ["title"] = "Add card 96",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "93",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 96
            }
          }
        },
        {
          ["title"] = "Add card 98",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "93",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 98
            }
          }
        }
      }
    }
  }
}
