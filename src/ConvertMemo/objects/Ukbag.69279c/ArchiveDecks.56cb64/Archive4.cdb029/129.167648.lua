data = {
  ["GUID"] = "167648",
  ["memo"] = {
    ["number"] = 129,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Виконати дії",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeOneFromSetasideIntoMonster",
              ["count"] = 3
            }
          }
        },
        {
          ["title"] = "Маркери",
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
              }
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
