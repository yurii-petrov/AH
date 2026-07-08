data = {
  ["GUID"] = "6852c7",
  ["memo"] = {
    ["number"] = 73,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add bosses",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 74,
              ["location"] = "Devil Reef"
            },
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 75,
              ["location"] = "Devil Reef"
            }
          }
        },
        {
          ["title"] = "Return codex",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnAllCodexExcept",
              ["exceptNumbers"] = {
                61,
                73
              }
            }
          }
        },
        {
          ["title"] = "Add card 72",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 72
            }
          }
        }
      }
    }
  }
}
