data = {
  ["GUID"] = "dc6d4e",
  ["memo"] = {
    ["number"] = 125,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Merge monsters",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeSetasideIntoMonster"
            }
          }
        },
        {
          ["title"] = "Add card 127",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 127
            }
          }
        },
        {
          ["title"] = "Nyogtha Awakes",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["numbers"] = {
                121,
                122,
                123
              }
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 126
            }
          }
        }
      }
    }
  }
}
