data = {
  ["GUID"] = "fcf135",
  ["memo"] = {
    ["number"] = 121,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Член Ложі",
          ["steps"] = {
            {
              ["type"] = "addRandomSetasideToMonsterBottom"
            }
          }
        },
        {
          ["title"] = "Додати карту 124",
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
          ["title"] = "Додати карту 122",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 122
            },
            {
              ["type"] = "attachRandomCodexUnderNumber",
              ["targetNumber"] = 122,
              ["underCard"] = true,
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
          ["title"] = "Додати карту 124",
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
