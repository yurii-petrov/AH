data = {
  ["GUID"] = "04d074",
  ["memo"] = {
    ["number"] = 115,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Mythos Tokens",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeBlankMythosToken",
              ["matFirst"] = true
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spawn Monster"
              }
            }
          }
        }
      }
    }
  }
}
