data = {
  ["GUID"] = "f6995d",
  ["memo"] = {
    ["number"] = 128,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Ворожість Ложі",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnRandomSetasideMonsters",
              ["count"] = 2
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spawn Monster"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            }
          }
        },
        {
          ["title"] = "Маркери в Домі Відьми",
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
        },
        {
          ["title"] = "Розплата",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = "Lodge"
            }
          }
        }
      }
    }
  }
}
