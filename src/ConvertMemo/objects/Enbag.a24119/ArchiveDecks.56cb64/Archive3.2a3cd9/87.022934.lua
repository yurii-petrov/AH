data = {
  ["GUID"] = "022934",
  ["memo"] = {
    ["number"] = 87,
    ["type"] = "codex",
    ["keepDoom"] = true,
    ["spawnDoom"] = 3,
    ["back"] = {
      ["actions"] = {
        {
          ["type"] = "skillGate",
          ["threshold"] = 3
        },
        {
          ["title"] = "Add card 88",
          ["removeAfterUse"] = true,
          ["requiresGate"] = 1,
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 88
            }
          }
        }
      }
    }
  }
}