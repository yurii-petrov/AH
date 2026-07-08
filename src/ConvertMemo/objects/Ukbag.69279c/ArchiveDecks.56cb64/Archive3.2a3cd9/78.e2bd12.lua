data = {
  ["GUID"] = "e2bd12",
  ["memo"] = {
    ["number"] = 78,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Деклан Пірс",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnSetasideMonster",
              ["attachUnderCodex"] = 0
            }
          }
        },
        {
          ["title"] = "Додати картки 79 і 82",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 79,
              ["face_down"] = true
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 82
            }
          }
        }
      }
    }
  }
}
