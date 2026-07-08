data = {
  ["GUID"] = "dc6d4e",
  ["memo"] = {
    ["number"] = 125,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Замішати монстрів",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeSetasideIntoMonster"
            }
          }
        },
        {
          ["title"] = "Додати карту 127",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 127
            }
          }
        },
        {
          ["title"] = "Пробудження Нюоґти",
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
