data = {
  ["GUID"] = "8871f6",
  ["memo"] = {
    ["number"] = 103,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add tokens",
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
          ["title"] = "Add card 102",
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