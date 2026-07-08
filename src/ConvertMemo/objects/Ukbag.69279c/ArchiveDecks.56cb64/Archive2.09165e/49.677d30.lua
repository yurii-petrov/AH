data = {
  ["GUID"] = "677d30",
  ["memo"] = {
    ["number"] = 49,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Розплата",
          ["steps"] = {
            {
              ["type"] = "findMonsterByName",
              ["monsterName"] = "Siobhan Riley"
            }
          }
        },
        {
          ["title"] = "Виконати дії",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeMonstersByType",
              ["monsterType"] = "Sheldon"
            },
            {
              ["type"] = "activateMarkersOnLocations",
              ["tokenMemo"] = "Red Marker"
            }
          }
        }
      }
    }
  }
}
