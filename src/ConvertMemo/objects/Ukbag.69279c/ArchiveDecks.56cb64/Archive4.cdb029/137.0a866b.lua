data = {
  ["GUID"] = "0a866b",
  ["memo"] = {
    ["number"] = 137,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Жетони міту",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spawn Monster"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Blank"
              }
            }
          }
        },
        {
          ["title"] = "Додати карту 138",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 138
            }
          }
        }
      }
    }
  }
}
