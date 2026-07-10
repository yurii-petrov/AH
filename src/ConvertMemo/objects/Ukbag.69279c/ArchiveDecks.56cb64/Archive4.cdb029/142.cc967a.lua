data = {
  ["GUID"] = "cc967a",
  ["memo"] = {
    ["number"] = 142,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Покласти зверху",
          ["removeGroup"] = "142f",
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
          ["title"] = "Замішати",
          ["removeGroup"] = "142f",
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
          ["removeGroup"] = "142b",
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
