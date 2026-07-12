data = {
  ["GUID"] = "167648",
  ["memo"] = {
    ["number"] = 129,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeOneFromSetasideIntoMonster",
              ["count"] = 3
            }
          }
        },
        {
          ["title"] = "Markers",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "The Witch House",
                "The Witch House",
                "The Witch House"
              },
              ["tokens"] = {
                {
                  ["type"] = "Red Marker",
                  ["count"] = 1
                },
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 1
                },
                {
                  ["type"] = "Green Marker",
                  ["count"] = 1
                }
              },
              ["face_up"] = true
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 123,
              ["face_down"] = true
            }
          }
        }
      }
    }
  }
}
