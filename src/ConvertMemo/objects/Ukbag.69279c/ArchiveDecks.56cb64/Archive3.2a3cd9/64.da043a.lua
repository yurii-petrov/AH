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
              ["skillNumbers"] = {
                68,
                70
              },
              ["extraMatNumbers"] = {
                68
              }
            }
          }
        },
        {
          ["title"] = "Додати карту 65",
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
          ["title"] = "Виконати дії",
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
