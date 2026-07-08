data = {
  ["GUID"] = "c87827",
  ["memo"] = {
    ["number"] = 59,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Прибрати міст",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "returnBridge"
            }
          }
        },
        {
          ["title"] = "Жетони мітів",
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
          ["title"] = "Виконати дії",
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
          ["title"] = "Додати карту 58",
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
