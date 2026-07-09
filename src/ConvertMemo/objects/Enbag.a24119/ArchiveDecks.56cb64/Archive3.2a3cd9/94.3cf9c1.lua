data = {
  ["GUID"] = "3cf9c1",
  ["memo"] = {
    ["number"] = 94,
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
                93,
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
          ["title"] = "Add card 100",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "94",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 100
            }
          }
        },
        {
          ["title"] = "Add card 96",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "94",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 96
            }
          }
        },
        {
          ["title"] = "Add card 97",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "94",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 97
            }
          }
        }
      }
    }
  }
}
