data = {
  ["GUID"] = "902e88",
  ["memo"] = {
    ["number"] = 106,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Дослідження архіву",
          ["description"] = "Скинь білий маркер зі своєї клітинки, щоб взяти випадкову карту з колоди дослідження і повернути її до архіву.",
          ["steps"] = {
            {
              ["type"] = "removeToken",
              ["token"] = {
                ["type"] = "White Marker"
              },
              ["placement"] = {
                ["type"] = "playerLocation"
              }
            },
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
                ["random"] = true
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
