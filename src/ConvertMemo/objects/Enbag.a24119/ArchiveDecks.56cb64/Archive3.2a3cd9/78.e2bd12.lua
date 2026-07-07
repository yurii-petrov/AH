data = {
  ["GUID"] = "e2bd12",
  ["memo"] = {
    ["number"] = 78,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Declan Pearce",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnSetasideMonster",
              ["attachUnderCodex"] = 0
            }
          }
        },
        {
          ["title"] = "Add cards 79 and 82",
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