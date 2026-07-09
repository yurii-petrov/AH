data = {
  ["GUID"] = "da043a",
  ["memo"] = {
    ["number"] = 64,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Encounter",
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
          ["title"] = "Add card 65",
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
          ["title"] = "Actions",
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
