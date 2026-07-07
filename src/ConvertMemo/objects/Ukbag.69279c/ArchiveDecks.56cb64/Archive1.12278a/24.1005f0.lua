data = {
  ["GUID"] = "1005f0",
  ["memo"] = {
    ["number"] = 24,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 26",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "24",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 26
            }
          }
        },
        {
          ["title"] = "Зворот карти 26",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "24",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 26,
              ["face_down"] = true
            }
          }
        }
      }
    }
  }
}