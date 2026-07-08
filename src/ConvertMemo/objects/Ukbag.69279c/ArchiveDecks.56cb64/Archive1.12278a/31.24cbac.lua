data = {
  ["GUID"] = "24cbac",
  ["memo"] = {
    ["number"] = 31,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Знайти місце",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["sourceDeck"] = "codexDeck",
              ["map"] = {
                {
                  ["number"] = 32,
                  ["neighborhood"] = "Rivertown"
                },
                {
                  ["number"] = 33,
                  ["neighborhood"] = "Downtown"
                },
                {
                  ["number"] = 34,
                  ["neighborhood"] = "Northside"
                },
                {
                  ["number"] = 35,
                  ["neighborhood"] = "Miskatonic University"
                }
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 36",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 36
            }
          }
        }
      }
    }
  }
}
