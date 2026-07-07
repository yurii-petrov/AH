data = {
  ["GUID"] = "c571e1",
  ["memo"] = {
    ["number"] = 76,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати картку 84",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 84
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати картку 77",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 77
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 84,
              ["face_down"] = true
            }
          }
        },
        {
          ["title"] = "Додати картку 78",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 78
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 84,
              ["face_down"] = true
            }
          }
        }
      }
    }
  }
}