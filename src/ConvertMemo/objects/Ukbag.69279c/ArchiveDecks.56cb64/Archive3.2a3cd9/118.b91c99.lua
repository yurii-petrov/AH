data = {
  ["GUID"] = "b91c99",
  ["memo"] = {
    ["reversed"] = true,
    ["number"] = 118,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Назва дії",
          ["description"] = "Опис дії",
          ["steps"] = {
            {
              ["type"] = "contextSetup",
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
                  ["name"] = "Central Kingsport",
                  ["pos"] = 9
                },
                {
                  ["type"] = "encounter",
                  ["name"] = "Kingsport Harbor",
                  ["pos"] = 12
                }
              }
            },
            {
              ["type"] = "mergeEventDeck",
              ["deck"] = {
                ["type"] = "event",
                ["name"] = "DoR Innsmouth"
              }
            }
          }
        }
      }
    }
  }
}