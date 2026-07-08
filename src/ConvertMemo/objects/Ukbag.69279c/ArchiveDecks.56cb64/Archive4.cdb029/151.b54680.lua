data = {
  ["GUID"] = "b54680",
  ["memo"] = {
    ["number"] = 151,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Розставити зачіпки",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 161,
              ["neighborhood"] = "Easttown"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 162,
              ["neighborhood"] = "French Hill"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 163,
              ["neighborhood"] = "Merchant District"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 164,
              ["neighborhood"] = "Rivertown"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 165,
              ["neighborhood"] = "Uptown"
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Easttown",
                "French Hill",
                "Merchant District",
                "Rivertown",
                "Uptown"
              },
              ["tokens"] = {
                {
                  ["type"] = "White Marker",
                  ["count"] = 5
                }
              }
            }
          }
        },
        {
          ["title"] = "Додати карту 152",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 152
            }
          }
        }
      }
    }
  }
}
