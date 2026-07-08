data = {
  ["GUID"] = "d21b65",
  ["memo"] = {
    ["number"] = 8,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Markers and mythos",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Gate Burst"
              }
            },
            {
              ["type"] = "clearMarkersOnLocations",
              ["removeMarkers"] = {
                "White Marker",
                "Blue Marker"
              },
              ["ensureRedMarker"] = true
            }
          }
        },
        {
          ["title"] = "Return cards",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnCodexByNumber",
              ["numbers"] = {
                4,
                6,
                7
              }
            }
          }
        }
      }
    }
  }
}
