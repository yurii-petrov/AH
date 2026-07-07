data = {
  ["GUID"] = "a740bc",
  ["memo"] = {
    ["number"] = 43,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Без альянсу",
          ["steps"] = {
            {
              ["type"] = "mergeOneFromSetasideIntoMonster",
              ["fromDeck"] = "setaside"
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Виконати дії",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeSetasideIntoMonster",
              ["fromDeck"] = "setaside"
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spawn Monster"
              }
            },
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
                    ["value"] = "cleaner"
                  }
                }
              }
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 44,
              ["face_down"] = true
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 45,
              ["face_down"] = true
            },
            {
              ["type"] = "showScenarioCounter",
              ["counter"] = "sanity"
            }
          }
        }
      }
    }
  }
}