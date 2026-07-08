data = {
  ["GUID"] = "85b321",
  ["memo"] = {
    ["number"] = 152,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 157",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 157
            }
          }
        },
        {
          ["title"] = "Add card 153",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 153
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Mythos tokens",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Blank"
              }
            }
          }
        }
      }
    }
  }
}
