data = {
  ["GUID"] = "8587dd",
  ["memo"] = {
    ["number"] = 23,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Investigators win!",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "broadcastMessage",
              ["message"] = "Investigators win!",
              ["color"] = {
                ["r"] = 0.2,
                ["g"] = 1,
                ["b"] = 0.2
              }
            }
          }
        },
        {
          ["title"] = "Add card 26",
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
