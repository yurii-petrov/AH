data = {
  ["GUID"] = "9a645e",
  ["memo"] = {
    ["number"] = 124,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Place markers",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokensOnLocations",
              ["locations"] = {
                "Residential1",
                "Residential2",
                "Residential3",
                "Scenic1"
              },
              ["tokens"] = {
                {
                  ["type"] = "White Marker",
                  ["count"] = 4
                }
              },
              ["face_up"] = true
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Add card 125",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 125
            }
          }
        }
      }
    }
  }
}
