data = {
  ["GUID"] = "241131",
  ["memo"] = {
    ["number"] = 37,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Виконати дії",
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["number"] = 36
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 38
            },
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 40,
              ["location"] = "River Docks"
            }
          }
        }
      }
    }
  }
}