data = {
  ["GUID"] = "bed22a",
  ["memo"] = {
    ["number"] = 157,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Hide card 158",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "attachRandomCodexUnderNumber",
              ["targetNumber"] = 157,
              ["number"] = 158,
              ["underCard"] = true
            }
          }
        },
        {
          ["title"] = "Hide card 159",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "attachRandomCodexUnderNumber",
              ["targetNumber"] = 157,
              ["number"] = 159,
              ["underCard"] = true
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 160",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 160,
              ["random_face"] = true
            }
          }
        }
      }
    }
  }
}
