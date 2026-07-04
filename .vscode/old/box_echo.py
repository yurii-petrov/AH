import sys

# Prints its argv (joined) centered in a box-drawing frame, e.g.:
#   ╔══════════════════════════╗
#   ║     MOD BUILD SUCCESS     ║
#   ╚══════════════════════════╝
# Used by .vscode/tasks.json as a final, hard-to-miss step after a task chain,
# since several of the underlying tools (TTSModManager's `go run`) print
# nothing at all on success.


def main():
    message = " ".join(sys.argv[1:]) or "DONE"
    pad = 5
    width = len(message) + pad * 2

    print()
    print("╔" + "═" * width + "╗")
    print("║" + " " * pad + message + " " * pad + "║")
    print("╚" + "═" * width + "╝")
    print()


if __name__ == "__main__":
    main()
