# AoC Godot

This repo contains my [Advent of Code](https://adventofcode.com/) scripts that are written in GDScript. These scripts are meant to be executed individually (with a headless editor). They also automatically fetch the input string, though they require a cookie to do so, which is supplied via environment variables.

# Usage
If you want to use these scripts to get free stars in AoC for some reason, you're free to do so. But first, please consider the following:
<details>
  <summary>Click to reveal</summary>
  
  You cheated not only the game, but yourself. You didn't grow. You didn't improve. You took a shortcut and gained nothing. You experienced a hollow victory. Nothing was risked and nothing was gained. It's sad that you don't know the difference.
  
</details>

To run any of these scripts, use the following command
```bash
AOC_COOKIE=<COOKIE> godot --headless -s <SCRIPT>
```
Replace `<COOKIE>` with your cookie and `<SCRIPT>` with the script you want to run. If you're using Godot Mono, you'll also need to replace `godot` with `godot-mono`.
