data = {
  ["GUID"] = "eb75a7",
  ["memo"] = {
    ["number"] = 130,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeMonstersByType",
              ["monsterType"] = "Lodge"
            },
            {
              ["type"] = "spawnCardBelowCodex",
              ["board"] = {
                ["query"] = {
                  {
                    ["field"] = "type",
                    ["op"] = "eq",
                    ["value"] = "ShopMat"
                  }
                }
              },
              ["deck"] = "special",
              ["card"] = {
                ["query"] = {
                  {
                    ["field"] = "name",
                    ["op"] = "eq",
                    ["value"] = "Steward of the Order"
                  }
                }
              }
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
                "Independence Square",
                "Unvisited Isle",
                "Graveyard",
                "Bayfriar Gardens",
                "Hangman's Hill",
                "Historical Society"
              },
              ["tokens"] = {
                {
                  ["type"] = "Red Marker",
                  ["count"] = 2
                },
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 2
                },
                {
                  ["type"] = "Green Marker",
                  ["count"] = 2
                }
              }
            }
          }
        }
      }
    }
  }
}
