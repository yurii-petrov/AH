data = {
  ["GUID"] = "bed22a",
  ["memo"] = {
    ["number"] = 157,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Get card 158",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "157_158_159",
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
          ["title"] = "Get card 159",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "157_158_159",
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
