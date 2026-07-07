data = {
  ["GUID"] = "600e9e",
  ["memo"] = {
    ["number"] = 53,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Spawn monster",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "attachMarkerToMonster",
              ["monsterType"] = "aberration",
              ["token"] = {
                ["type"] = "White Marker"
              }
            }
          }
        },
        {
          ["title"] = "Add card 57",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 57
            }
          }
        },
        {
          ["title"] = "Add card 59",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 59
            }
          }
        }
      }
    }
  }
}