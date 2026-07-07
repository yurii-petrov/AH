data = {
  ["GUID"] = "8eac34",
  ["memo"] = {
    ["number"] = 6,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Two cultist",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Cultist"
              },
              ["deckType"] = "monster"
            },
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Cultist"
              },
              ["deckType"] = "monster"
            }
          }
        }
      }
    }
  }
}