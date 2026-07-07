data = {
  ["GUID"] = "c7664c",
  ["memo"] = {
    ["number"] = 46,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Shuffle monsters",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "mergeSetasideIntoMonster",
              ["fromDeck"] = "setaside"
            },
            {
              ["type"] = "mergeSetasideIntoMonster",
              ["fromDeck"] = "setaside2"
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "White Marker",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "placeTokenOnScenarioMat",
              ["token"] = {
                ["type"] = "White Marker"
              },
              ["target"] = "scenarioSheet",
              ["position"] = {
                ["x"] = -0.4,
                ["y"] = 0.3,
                ["z"] = 0.0
              },
              ["face_up"] = true
            }
          }
        },
        {
          ["title"] = "Add card 47",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 47
            }
          }
        }
      }
    }
  }
}