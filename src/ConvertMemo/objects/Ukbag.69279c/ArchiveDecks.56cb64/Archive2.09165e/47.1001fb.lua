data = {
  ["GUID"] = "1001fb",
  ["memo"] = {
    ["number"] = 47,
    ["type"] = "codex",
    ["front"] = {
      ["actions"] = {
        {
          ["title"] = "Прислужник",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "findMonsterByType",
              ["monsterType"] = {
                "Servitor"
              }
            }
          }
        },
        {
          ["title"] = "Білий маркер",
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
                ["z"] = 0.5
              },
              ["face_up"] = true
            }
          }
        }
      }
    }
  }
}