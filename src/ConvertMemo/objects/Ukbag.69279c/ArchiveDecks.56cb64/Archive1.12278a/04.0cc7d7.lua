data = {
  ["GUID"] = "0cc7d7",
  ["memo"] = {
    ["number"] = 4,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "5 Маркерів",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Arkham Advertiser",
                "Black Cave",
                "Independence Square",
                "Unvisited Isle",
                "Velma's Diner"
              },
              ["tokens"] = {
                {
                  ["type"] = "White Marker",
                  ["count"] = 3
                },
                {
                  ["type"] = "Red Marker",
                  ["count"] = 1
                },
                {
                  ["type"] = "Blue Marker",
                  ["count"] = 1
                }
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Синій Маркер",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findAndRemoveTokenOnLocation",
              ["token"] = {
                ["type"] = "Blue Marker"
              },
              ["removeToken"] = false
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 6
            }
          }
        },
        {
          ["title"] = "Червоний Маркер",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findAndRemoveTokenOnLocation",
              ["token"] = {
                ["type"] = "Red Marker"
              },
              ["removeToken"] = false
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 7,
              ["faceFromCodex"] = 6
            }
          }
        }
      }
    }
  }
}