data = {
  ["GUID"] = "fcf135",
  ["memo"] = {
    ["number"] = 121,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Lodge",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addRandomSetasideToMonsterBottom"
            }
          }
        },
        {
          ["title"] = "Add card 124",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 124
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 122",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 122
            },
            {
              ["type"] = "attachRandomCodexWithMat",
              ["targetNumber"] = 122,
              ["numbers"] = {
                131,
                132,
                133,
                134
              }
            }
          }
        },
        {
          ["title"] = "Add card 124",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 124
            }
          }
        }
      }
    }
  }
}
