data = {
  ["GUID"] = "fcf135",
  ["memo"] = {
    ["number"] = 121,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Add a monster",
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
              ["type"] = "attachRandomCodexUnderNumber",
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
