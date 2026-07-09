data = {
  ["GUID"] = "3cf9c1",
  ["memo"] = {
    ["number"] = 94,
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
          ["title"] = "Додати карту 100",
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
          ["title"] = "Додати карту 96",
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
          ["title"] = "Додати карту 97",
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
