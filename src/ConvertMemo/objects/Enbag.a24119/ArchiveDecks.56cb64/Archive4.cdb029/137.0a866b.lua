data = {
  ["GUID"] = "0a866b",
  ["memo"] = {
    ["number"] = 137,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add tokens",
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
          ["title"] = "Add card 138",
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
