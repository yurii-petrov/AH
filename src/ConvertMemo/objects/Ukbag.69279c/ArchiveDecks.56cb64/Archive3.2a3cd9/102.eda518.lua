data = {
  ["GUID"] = "eda518",
  ["memo"] = {
    ["number"] = 102,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Ітаква",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 105
            }
          }
        },
        {
          ["title"] = "Повернути карти",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["numbers"] = {
                93,
                94,
                95,
                96,
                97,
                98,
                99,
                100,
                101
              }
            }
          }
        }
      }
    }
  }
}
