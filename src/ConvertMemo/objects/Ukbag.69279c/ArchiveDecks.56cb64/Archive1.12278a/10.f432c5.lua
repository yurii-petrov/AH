data = {
  ["GUID"] = "f432c5",
  ["memo"] = {
    ["number"] = 10,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Виконати дії",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnCardBelowCodex",
              ["board"] = {
                ["query"] = {
                  {
                    ["field"] = "type",
                    ["op"] = "eq",
                    ["value"] = "ShopMat"
                  }
                }
              },
              ["deck"] = "special",
              ["card"] = {
                ["query"] = {
                  {
                    ["field"] = "name",
                    ["op"] = "eq",
                    ["value"] = "lita chantler"
                  },
                  {
                    ["field"] = "type",
                    ["op"] = "eq",
                    ["value"] = "special"
                  }
                }
              }
            },
            {
              ["type"] = "spawnCardBelowCodex",
              ["board"] = {
                ["query"] = {
                  {
                    ["field"] = "type",
                    ["op"] = "eq",
                    ["value"] = "LocationMat"
                  }
                }
              },
              ["deck"] = "setaside",
              ["card"] = {
                ["query"] = {
                  {
                    ["field"] = "type",
                    ["op"] = "eq",
                    ["value"] = "Monster"
                  },
                  {
                    ["field"] = "name",
                    ["op"] = "eq",
                    ["value"] = "Masked Hunter"
                  }
                }
              }
            },
            {
              ["type"] = "seedCodexEncounters",
              ["numbers"] = {
                13,
                14,
                15,
                16,
                17
              },
              ["token"] = "White Marker"
            }
          }
        },
        {
          ["title"] = "Додати карту 12",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 12
            }
          }
        }
      }
    }
  }
}