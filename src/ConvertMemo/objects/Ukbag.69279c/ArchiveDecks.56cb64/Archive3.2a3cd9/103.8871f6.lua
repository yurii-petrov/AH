data = {
  ["GUID"] = "8871f6",
  ["memo"] = {
    ["number"] = 103,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Додати жетони",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Gate Burst"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Terror"
              }
            }
          }
        },
        {
          ["title"] = "Додати карту 102",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 102
            }
          }
        }
      }
    }
  }
}
