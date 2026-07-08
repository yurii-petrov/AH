data = {
  ["GUID"] = "70b8b3",
  ["memo"] = {
    ["number"] = 3,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 4",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 4
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Знайти Культиста",
          ["removeAfterUse"] = true,
          ["description"] = "",
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Cultist"
              },
              ["deckType"] = "monster"
            }
          }
        },
        {
          ["title"] = "Додати карту 5",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 5
            }
          }
        }
      }
    }
  }
}
