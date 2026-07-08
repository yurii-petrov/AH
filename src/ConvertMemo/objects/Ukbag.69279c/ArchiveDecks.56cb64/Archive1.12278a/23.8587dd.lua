data = {
  ["GUID"] = "8587dd",
  ["memo"] = {
    ["number"] = 23,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Дослідники перемогли",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "broadcastMessage",
              ["message"] = "Дослідники перемогли!",
              ["color"] = {
                ["r"] = 0.2,
                ["g"] = 1,
                ["b"] = 0.2
              }
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
