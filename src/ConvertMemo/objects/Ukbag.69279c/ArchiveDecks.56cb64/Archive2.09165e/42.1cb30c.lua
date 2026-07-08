data = {
  ["GUID"] = "1cb30c",
  ["memo"] = {
    ["number"] = 42,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Без альянсу",
          ["steps"] = {
            {
              ["type"] = "mergeOneFromSetasideIntoMonster",
              ["fromDeck"] = "setaside2"
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
              ["fromDeck"] = "setaside2"
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
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
                    ["value"] = "legbreaker"
                  }
                }
              }
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 44,
              ["face_down"] = false
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 45,
              ["face_down"] = false
            },
            {
              ["type"] = "showScenarioCounter",
              ["counter"] = "hp"
            }
          }
        }
      }
    }
  }
}
