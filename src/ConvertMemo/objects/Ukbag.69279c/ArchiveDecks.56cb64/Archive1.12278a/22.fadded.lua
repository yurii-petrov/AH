data = {
  ["GUID"] = "fadded",
  ["memo"] = {
    ["number"] = 22,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Додати карту 23",
          ["description"] = "",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 23
            },
            {
              ["type"] = "returnCodexToArchive"
            }
          }
        },
        {
          ["title"] = "Додати карту 26",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 26
            }
          }
        }
      }
    }
  }
}