data = {
  ["GUID"] = "bd82a4",
  ["memo"] = {
    ["number"] = 48,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Reckoning",
          ["steps"] = {
            {
              ["type"] = "findMonsterByName",
              ["monsterName"] = "Corben Bouchard"
            }
          }
        },
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeMonstersByType",
              ["monsterType"] = "O'Bannion"
            },
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Bridge1",
                "Bridge2",
                "Residential1",
                "Residential2"
              },
              ["tokens"] = {
                {
                  ["type"] = "White Marker",
                  ["count"] = 4
                }
              },
              ["face_up"] = true
            },
            {
              ["type"] = "activateMarkersOnLocations",
              ["tokenMemo"] = "White Marker"
            }
          }
        }
      }
    }
  }
}