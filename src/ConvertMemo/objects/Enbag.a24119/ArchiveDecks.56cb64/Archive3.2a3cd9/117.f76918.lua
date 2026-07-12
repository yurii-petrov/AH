data = {
  ["GUID"] = "f76918",
  ["memo"] = {
    ["reversed"] = true,
    ["number"] = 117,
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
                  ["Innsmouth Village"] = {
                    ["position"] = {
                      ["x"] = 0.22,
                      ["y"] = 0.2,
                      ["z"] = -0.469
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  },
                  ["Innsmouth Shore"] = {
                    ["position"] = {
                      ["x"] = -0.218,
                      ["y"] = 0.2,
                      ["z"] = -0.469
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
                      ["x"] = 0.001,
                      ["y"] = 0.2,
                      ["z"] = -0.469
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 180,
                      ["z"] = 0
                    }
                  }
                },
                ["Travel Routes"] = {
                  ["Country Road2"] = {
                    ["position"] = {
                      ["x"] = 0.331,
                      ["y"] = 0.2,
                      ["z"] = -0.281
                    },
                    ["rotation"] = {
                      ["x"] = 0,
                      ["y"] = 120,
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
                  ["guid"] = "50dd49",
                  ["pos"] = 6
                },
                {
                  ["type"] = "encounter",
                  ["guid"] = "1385db",
                  ["pos"] = 5
                }
              }
            },
            {
              ["type"] = "mergeEventDeck",
              ["deck"] = {
                ["type"] = "event",
                ["name"] = "DoR Innsmouth"
              }
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Falcon Point"
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
                "Esoteric Order of Dagon"
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
                "Gilman House"
              },
              ["tokens"] = {
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 1
                }
              },
              ["face_up"] = true
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
          ["title"] = "Add card 113",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 113
            }
          }
        }
      }
    }
  }
}
