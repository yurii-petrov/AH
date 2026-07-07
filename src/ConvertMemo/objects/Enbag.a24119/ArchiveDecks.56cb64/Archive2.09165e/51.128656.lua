data = {
  ["GUID"] = "128656",
  ["memo"] = {
    ["number"] = 51,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Blank token",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Blank"
              }
            }
          }
        },
        {
          ["title"] = "Add card 50",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 50
            }
          }
        }
      }
    }
  }
}