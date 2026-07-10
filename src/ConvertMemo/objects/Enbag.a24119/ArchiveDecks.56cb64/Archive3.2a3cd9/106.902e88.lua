data = {
  ["GUID"] = "902e88",
  ["memo"] = {
    ["number"] = 106,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Дослідження архіву",
          ["steps"] = {
            {
              ["type"] = "takeCard",
              ["card"] = {
                ["source"] = {
                  ["board"] = {
                    ["query"] = {
                      {
                        ["field"] = "type",
                        ["op"] = "eq",
                        ["value"] = "locationMat"
                      }
                    }
                  },
                  ["deck"] = "codexDeck"
                },
                ["query"] = {},
                ["random"] = true,
                ["mythosTokenOnDraw"] = {
                  ["type"] = "Blank"
                }
              },
              ["placement"] = {
                ["type"] = "deck",
                ["board"] = {
                  ["query"] = {
                    {
                      ["field"] = "type",
                      ["op"] = "eq",
                      ["value"] = "locationMat"
                    }
                  }
                },
                ["deck"] = "archive"
              }
            }
          }
        }
      }
    }
  }
}
