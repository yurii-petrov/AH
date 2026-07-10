data = {
  ["GUID"] = "4a22a3",
  ["memo"] = {
    ["number"] = 153,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add Underworld",
          ["description"] = "Опис дії",
          ["steps"] = {
            {
              ["type"] = "contextSetup",
              ["keepCodexMat"] = true,
              ["tiles"] = {
                ["Neighborhood"] = {
                  ["The Underworld"] = {
                    ["position"] = {
                      ["x"] = -0.437,
                      ["y"] = 0.4,
                      ["z"] = 0
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  }
                },
                ["Threshold"] = {
                  ["Derelict Portal"] = {
                    ["position"] = {
                      ["x"] = -0.22,
                      ["y"] = 0.2,
                      ["z"] = 0
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  }
                }
              }
            },
            {
              ["type"] = "placeScenarioDecks",
              ["decks"] = {
                {
                  ["type"] = "encounter",
                  ["guid"] = "e1528f",
                  ["pos"] = 11
                },
                {
                  ["type"] = "encounter",
                  ["guid"] = "f6e52b",
                  ["pos"] = 12
                }
              }
            },
            {
              ["type"] = "replaceEventDeck",
              ["deck"] = {
                ["type"] = "event",
                ["name"] = "TKaTG Underworld"
              },
              ["removeFromTop"] = 4
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Markers",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "City of the Gugs",
                "Vale of Pnath",
                "Vaults of Zin"
              },
              ["tokens"] = {
                {
                  ["type"] = "Red Marker",
                  ["count"] = 2
                },
                {
                  ["type"] = "Green Marker",
                  ["count"] = 1
                }
              }
            }
          }
        },
        {
          ["title"] = "Add card 154",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 154
            }
          }
        }
      }
    }
  }
}
