data = {
  ["GUID"] = "6852c7",
  ["memo"] = {
    ["number"] = 73,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати босів",
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
          ["title"] = "Повернути кодекс",
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
          ["title"] = "Додати карту 72",
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