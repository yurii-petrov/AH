data = {
  ["GUID"] = "8ababc",
  ["memo"] = {
    ["number"] = 139,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Mummified Gug",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 145
            }
          }
        },
        {
          ["title"] = "Place markers",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Northside",
                "Easttown",
                "French Hill",
                "Southside",
                "Uptown",
                "Miskatonic University"
              },
              ["tokens"] = {
                {
                  ["type"] = "Green Marker",
                  ["count"] = 2
                },
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 2
                },
                {
                  ["type"] = "Red Marker",
                  ["count"] = 2
                }
              }
            }
          }
        },
        {
          ["title"] = "Add card 140",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 140
            }
          }
        }
      }
    }
  }
}
