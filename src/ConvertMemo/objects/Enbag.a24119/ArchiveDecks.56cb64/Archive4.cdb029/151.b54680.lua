data = {
  ["GUID"] = "b54680",
  ["memo"] = {
    ["number"] = 151,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Place cards",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeCodexOnEncounterDeck",
              ["number"] = 161,
              ["neighborhood"] = "Easttown"
            },
            {
              ["type"] = "placeCodexOnEncounterDeck",
              ["number"] = 162,
              ["neighborhood"] = "French Hill"
            },
            {
              ["type"] = "placeCodexOnEncounterDeck",
              ["number"] = 163,
              ["neighborhood"] = "Merchant District"
            },
            {
              ["type"] = "placeCodexOnEncounterDeck",
              ["number"] = 164,
              ["neighborhood"] = "Rivertown"
            },
            {
              ["type"] = "placeCodexOnEncounterDeck",
              ["number"] = 165,
              ["neighborhood"] = "Uptown"
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["face_up"] = true,
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
          ["title"] = "Add card 152",
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
