data = {
  ["GUID"] = "cc967a",
  ["memo"] = {
    ["number"] = 142,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Покласти зверху колоди",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeRandomOnEncounterDeck",
              ["numbers"] = {
                147,
                148,
                149
              },
              ["deck"] = {
                ["type"] = "encounter",
                ["name"] = "The Underworld"
              }
            }
          }
        },
        {
          ["title"] = "Замішати у верх колоди",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeRandomOnEncounterDeck",
              ["numbers"] = {
                147,
                148,
                149
              },
              ["deck"] = {
                ["type"] = "encounter",
                ["name"] = "The Underworld"
              },
              ["seed"] = true
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 144",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 144
            }
          }
        }
      }
    }
  }
}
