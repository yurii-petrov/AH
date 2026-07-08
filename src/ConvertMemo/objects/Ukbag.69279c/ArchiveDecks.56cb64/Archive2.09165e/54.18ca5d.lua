data = {
  ["GUID"] = "18ca5d",
  ["memo"] = {
    ["number"] = 54,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Покласти маркери",
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
          ["title"] = "Зелений маркер",
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
          ["title"] = "Синій маркер",
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
