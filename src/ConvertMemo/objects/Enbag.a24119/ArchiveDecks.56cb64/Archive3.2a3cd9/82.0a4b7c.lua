data = {
  ["GUID"] = "0a4b7c",
  ["memo"] = {
    ["number"] = 82,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Get lantern",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeItemFromArchive",
              ["number"] = 90
            }
          }
        },
        {
          ["title"] = "Boss",
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
