data = {
  ["GUID"] = "b91c99",
  ["memo"] = {
    ["reversed"] = true,
    ["number"] = 118,
    ["type"] = "codex",
    ["keepDoom"] = true,
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Neighborhoods",
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
                  ["Train Platform2"] = {
                    ["position"] = {
                      ["x"] = -0.609,
                      ["y"] = 0.2,
                      ["z"] = -0.19
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 300,
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
                "Congregational Hospital"
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
                "North Point Lighthouse"
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
                "Hall School"
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
              ["location"] = "The Rope and Anchor"
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 108",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 108
            }
          }
        },
        {
          ["title"] = "Add card 114",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 114
            }
          }
        }
      }
    }
  }
}
