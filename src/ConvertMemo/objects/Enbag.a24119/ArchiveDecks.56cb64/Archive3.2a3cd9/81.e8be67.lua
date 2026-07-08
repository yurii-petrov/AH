data = {
  ["GUID"] = "e8be67",
  ["memo"] = {
    ["number"] = 81,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Discard markers",
          ["steps"] = {
            {
              ["type"] = "clearMarkersOnLocations",
              ["removeMarkers"] = {
                "Blue Marker",
                "Green Marker",
                "White Marker"
              },
              ["onlyFaceDown"] = true
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 82",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = "Moon-beast"
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 82
            }
          }
        }
      }
    }
  }
}
