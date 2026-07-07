data = {
  ["GUID"] = "0a4b7c",
  ["memo"] = {
    ["number"] = 82,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Отримати ліхтар",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeItemFromArchive",
              ["number"] = 90
            }
          }
        },
        {
          ["title"] = "Бос",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 89,
              ["location"] = "Hall School"
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 83
            }
          }
        }
      }
    }
  }
}