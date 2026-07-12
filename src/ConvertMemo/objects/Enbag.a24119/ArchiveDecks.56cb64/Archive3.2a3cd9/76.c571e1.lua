data = {
  ["GUID"] = "c571e1",
  ["memo"] = {
    ["number"] = 76,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 84",
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
          ["title"] = "Add card 77",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "76",
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
          ["title"] = "Add card 78",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "76",
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
