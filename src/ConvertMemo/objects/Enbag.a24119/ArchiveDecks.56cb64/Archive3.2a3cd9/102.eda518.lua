data = {
  ["GUID"] = "eda518",
  ["memo"] = {
    ["number"] = 102,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Summon Ithaqua",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 105
            }
          }
        },
        {
          ["title"] = "Return cards 93–101",
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
