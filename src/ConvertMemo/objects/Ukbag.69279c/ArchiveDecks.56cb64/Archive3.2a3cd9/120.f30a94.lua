data = {
  ["GUID"] = "f30a94",
  ["memo"] = {
    ["reversed"] = true,
    ["number"] = 120,
    ["type"] = "codex",
    ["keepDoom"] = true,
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати райони",
          ["description"] = "Опис дії",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "contextSetup",
              ["keepCodexMat"] = true,
              ["tiles"] = {
                ["Neighborhood"] = {
                  ["Central Kingsport"] = {
                    ["position"] = {
                      ["x"] = -0.5,
                      ["y"] = 0.2,
                      ["z"] = 0
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  },
                  ["Kingsport Harbor"] = {
                    ["position"] = {
                      ["x"] = -0.718,
                      ["y"] = 0.2,
                      ["z"] = 0.38
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  }
                },
                ["Street"] = {
                  ["Scenic2"] = {
                    ["position"] = {
                      ["x"] = -0.609,
                      ["y"] = 0.2,
                      ["z"] = 0.189
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 240,
                      ["z"] = 0
                    }
                  }
                },
                ["Travel Routes"] = {
                  ["Ferry Terminal2"] = {
                    ["position"] = {
                      ["x"] = -0.938,
                      ["y"] = 0.2,
                      ["z"] = 0.38
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 0,
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
                  ["guid"] = "683066",
                  ["pos"] = 5
                },
                {
                  ["type"] = "encounter",
                  ["guid"] = "b26132",
                  ["pos"] = 6
                }
              }
            },
            {
              ["type"] = "mergeEventDeck",
              ["deck"] = {
                ["type"] = "event",
                ["name"] = "DoR Kingsport"
              }
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "North Point Lighthouse"
              },
              ["tokens"] = {
                {
                  ["type"] = "Doom Token",
                  ["count"] = 1
                }
              }
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Congregational Hospital"
              },
              ["tokens"] = {
                {
                  ["type"] = "Red Marker",
                  ["count"] = 1
                }
              },
              ["face_up"] = true
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "St. Erasmus's Home"
              },
              ["tokens"] = {
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 1
                }
              },
              ["face_up"] = true
            },
            {
              ["type"] = "spawnMonsterFromDeck",
              ["location"] = "Hall School"
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 108",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 108
            }
          }
        },
        {
          ["title"] = "Додати карту 114",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 116
            }
          }
        }
      }
    }
  }
}
