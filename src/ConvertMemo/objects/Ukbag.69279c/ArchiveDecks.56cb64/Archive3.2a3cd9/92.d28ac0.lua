data = {
  ["GUID"] = "d28ac0",
  ["memo"] = {
    ["number"] = 92,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Знайти Інуксук",
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
                    ["value"] = "Inuksuk"
                  }
                }
              }
            }
          }
        },
        {
          ["title"] = "Обрати дві картки з 93, 94, 95",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addRandomCodexFromArchive",
              ["numbers"] = {
                93,
                94,
                95
              },
              ["count"] = 2
            }
          }
        }
      }
    }
  }
}