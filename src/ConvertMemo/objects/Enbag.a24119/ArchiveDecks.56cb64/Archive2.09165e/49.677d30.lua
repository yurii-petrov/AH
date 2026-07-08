data = {
  ["GUID"] = "677d30",
  ["memo"] = {
    ["number"] = 49,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Reckoning",
          ["steps"] = {
            {
              ["type"] = "findMonsterByName",
              ["monsterName"] = "Siobhan Riley"
            }
          }
        },
        {
          ["title"] = "Actions",
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
