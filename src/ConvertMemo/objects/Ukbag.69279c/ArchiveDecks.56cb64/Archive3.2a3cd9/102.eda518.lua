data = {
  ["GUID"] = "eda518",
  ["memo"] = {
    ["number"] = 102,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Прикликати Ітакву",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 105
            }
          }
        },
        {
          ["title"] = "Повернути картки 93–101",
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