data = {
  ["GUID"] = "0f0ad1",
  ["memo"] = {
    ["number"] = 95,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Повернути карти",
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
          ["title"] = "Додати карту 101",
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
          ["title"] = "Додати карту 97",
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
          ["title"] = "Додати карту 98",
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
