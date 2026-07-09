data = {
  ["GUID"] = "176e57",
  ["memo"] = {
    ["number"] = 93,
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
          ["title"] = "Додати карту 99",
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
          ["title"] = "Додати карту 96",
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
          ["title"] = "Додати карту 98",
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
