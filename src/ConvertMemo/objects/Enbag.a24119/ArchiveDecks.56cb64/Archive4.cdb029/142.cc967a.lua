data = {
  ["GUID"] = "cc967a",
  ["memo"] = {
    ["number"] = 142,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Place on top of deck",
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
          ["title"] = "Shuffle into deck top",
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
          ["title"] = "Add card 144",
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
