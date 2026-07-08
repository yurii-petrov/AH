data = {
  ["GUID"] = "18ca5d",
  ["memo"] = {
    ["number"] = 54,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "3 markers",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Black Cave",
                "Science Building",
                "Unvisited Isle"
              },
              ["tokens"] = {
                {
                  ["type"] = "Green Marker",
                  ["count"] = 1
                },
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 1
                },
                {
                  ["type"] = "Red Marker",
                  ["count"] = 1
                }
              },
              ["face_up"] = false
            }
          }
        },
        {
          ["title"] = "Green Marker",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "moveMarkerToLocation",
              ["token"] = {
                ["type"] = "Green Marker"
              },
              ["location"] = "Northside"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 55,
              ["neighborhood"] = "Northside"
            }
          }
        },
        {
          ["title"] = "Blue Marker",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "moveMarkerToLocation",
              ["token"] = {
                ["type"] = "Blue Marker"
              },
              ["location"] = "Uptown"
            },
            {
              ["type"] = "placeCodexAtEncounterDeck",
              ["number"] = 56,
              ["neighborhood"] = "Uptown"
            }
          }
        }
      }
    }
  }
}
