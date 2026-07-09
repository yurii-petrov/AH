data = {
  ["GUID"] = "0f0ad1",
  ["memo"] = {
    ["number"] = 95,
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
                94
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 101",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "95",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 101
            }
          }
        },
        {
          ["title"] = "Add card 97",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "95",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 97
            }
          }
        },
        {
          ["title"] = "Add card 98",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "95",
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
