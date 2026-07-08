data = {
  ["GUID"] = "f76918",
  ["memo"] = {
    ["reversed"] = true,
    ["number"] = 117,
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
                  ["name"] = "Innsmouth Village",
                  ["pos"] = 6
                },
                {
                  ["type"] = "encounter",
                  ["name"] = "Innsmouth Shore",
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
            }
          }
        }
      }
    }
  }
}
