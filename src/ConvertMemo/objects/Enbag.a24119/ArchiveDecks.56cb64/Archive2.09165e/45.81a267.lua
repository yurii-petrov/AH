data = {
  ["GUID"] = "81a267",
  ["memo"] = {
    ["number"] = 45,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 46",
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
          ["title"] = "Reckoning",
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
          ["title"] = "Add card 46",
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
          ["title"] = "Reckoning",
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