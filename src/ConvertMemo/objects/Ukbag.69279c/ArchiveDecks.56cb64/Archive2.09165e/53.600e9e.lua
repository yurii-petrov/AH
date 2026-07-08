data = {
  ["GUID"] = "600e9e",
  ["memo"] = {
    ["number"] = 53,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Знайти монстра",
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
          ["title"] = "Додати карту 57",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 57
            }
          }
        },
        {
          ["title"] = "Додати карту 59",
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
