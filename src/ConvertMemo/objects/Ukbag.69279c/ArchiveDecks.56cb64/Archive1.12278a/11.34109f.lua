data = {
  ["GUID"] = "34109f",
  ["memo"] = {
    ["number"] = 11,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Викликати Умордота",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["steps"] = {
            {
              ["type"] = "spawnMonsterOnLocation",
              ["number"] = 19,
              ["location"] = "Hangman's Hill"
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 18
            }
          }
        }
      }
    }
  }
}