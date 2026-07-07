data = {
  ["GUID"] = "45d7df",
  ["memo"] = {
    ["number"] = 20,
    ["type"] = "codex",
    ["back"] = {
      ["actions"] = {
        {
          ["title"] = "Join Lodge",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "lodge",
          ["steps"] = {
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 24
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 25
            }
          }
        },
        {
          ["title"] = "Reject",
          ["description"] = "",
          ["removeAfterUse"] = true,
          ["removeGroup"] = "lodge",
          ["steps"] = {
            {
              ["type"] = "mergeSetasideIntoMonster"
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
                ["type"] = "Gate Burst"
              }
            },
            {
              ["type"] = "takeCodexFromArchive",
              ["number"] = 22
            }
          }
        }
      }
    }
  }
}