data = {
  ["GUID"] = "128656",
  ["memo"] = {
    ["number"] = 51,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Порожній жетон",
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
          ["title"] = "Додати карту 50",
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