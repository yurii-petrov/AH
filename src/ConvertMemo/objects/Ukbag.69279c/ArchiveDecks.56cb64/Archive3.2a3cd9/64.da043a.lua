data = {
  ["GUID"] = "da043a",
  ["memo"] = {
    ["number"] = 64,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Зустріч",
          ["steps"] = {
            {
              ["type"] = "resolveResearchEncounter",
              ["addToCodexNumbers"] = {
                71
              },
              ["itemNumbers"] = {
                68,
                69,
                70
              },
              ["extraMatNumbers"] = {
                68
              }
            }
          }
        },
        {
          ["title"] = "Додати картку 65",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 65
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Прибирання",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnResearchDeckToArchive"
            },
            {
              ["type"] = "removeMythosToken",
              ["token"] = {
                ["type"] = "Spawn Monster"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Blank"
              }
            }
          }
        }
      }
    }
  }
}