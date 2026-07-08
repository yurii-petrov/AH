data = {
  ["GUID"] = "ae7869",
  ["memo"] = {
    ["number"] = 123,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Find a spirit",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Troubled Spirit",
                "Angry Spirit",
                "Hostile Spirit"
              }
            }
          }
        }
      }
    }
  }
}
