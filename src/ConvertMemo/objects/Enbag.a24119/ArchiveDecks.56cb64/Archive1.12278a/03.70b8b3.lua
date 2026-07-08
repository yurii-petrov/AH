data = {
  ["GUID"] = "70b8b3",
  ["memo"] = {
    ["number"] = 3,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 4",
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
          ["title"] = "Reveal cultist",
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
          ["title"] = "Add card 5",
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
