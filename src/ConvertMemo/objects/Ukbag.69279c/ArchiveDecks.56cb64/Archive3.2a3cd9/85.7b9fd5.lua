data = {
  ["GUID"] = "7b9fd5",
  ["memo"] = {
    ["number"] = 85,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Жетони міту",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Виконати дії",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 89,
              ["location"] = "Hall School"
            }
          }
        },
        {
          ["title"] = "Повернути кодекс",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["numbers"] = {
                77,
                78,
                79,
                80,
                81,
                82,
                83,
                84
              }
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 86
            }
          }
        }
      }
    }
  }
}
