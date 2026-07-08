data = {
  ["GUID"] = "81a267",
  ["memo"] = {
    ["number"] = 45,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 46",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 46
            },
            {
              ["type"] = "showScenarioCounter",
              ["counter"] = "sanity"
            }
          }
        },
        {
          ["title"] = "Розплата",
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "O'Bannion"
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 46",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 46
            },
            {
              ["type"] = "showScenarioCounter",
              ["counter"] = "hp"
            }
          }
        },
        {
          ["title"] = "Розплата",
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Sheldon"
              }
            }
          }
        }
      }
    }
  }
}
