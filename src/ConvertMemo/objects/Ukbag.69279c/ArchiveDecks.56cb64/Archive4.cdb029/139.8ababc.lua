data = {
  ["GUID"] = "8ababc",
  ["memo"] = {
    ["number"] = 139,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Розмістити Гуга",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 145
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
          ["title"] = "Додати карту 140",
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
