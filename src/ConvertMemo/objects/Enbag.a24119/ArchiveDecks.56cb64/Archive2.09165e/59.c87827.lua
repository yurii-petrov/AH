data = {
  ["GUID"] = "c87827",
  ["memo"] = {
    ["number"] = 59,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Return bridge",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnBridge"
            }
          }
        },
        {
          ["title"] = "Mythos tokens",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "removeBlankMythosToken"
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Gate Burst"
              }
            }
          }
        }
      }
    },
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Actions",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 60,
              ["location"] = "Curiositie Shoppe"
            },
            {
              ["type"] = "attachMarkerToMonster",
              ["monsterType"] = "formless spawn",
              ["token"] = {
                ["type"] = "White Marker"
              }
            },
            {
              ["type"] = "removeBlankMythosToken"
            },
            {
              ["type"] = "addMythosToken",
              ["token"] = {
                ["type"] = "Spread Doom"
              }
            },
            {
              ["type"] = "removeDoomFromScenarioSheet"
            }
          }
        },
        {
          ["title"] = "Add card 58",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 58
            }
          }
        }
      }
    }
  }
}