data = {
  ["GUID"] = "cc967a",
  ["memo"] = {
    ["number"] = 142,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Place on top",
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
          ["title"] = "Shuffle",
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
          ["title"] = "Add card 144",
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
