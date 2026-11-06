# Homebrew tap for E8

[E8](https://github.com/e8-editor/e8) for Homebrew, on Apple silicon Macs and on Linux:

```bash
brew install e8-editor/tap/e8
```

That installs `e8`, the editor in a terminal, and `e8-mcp`, which lets an agent such as Claude Code use E8. On a Mac it also installs `E8.app`, the editor in a window; to open it from Launchpad and Spotlight, link it into `/Applications`:

```bash
ln -sf "$(brew --prefix)/opt/e8/E8.app" /Applications/E8.app
```

Homebrew downloads the release with `curl`, so macOS does not quarantine it, and the app opens though it is not signed with an Apple Developer ID.

`brew upgrade e8` brings it up to date. The formula follows E8's releases: a workflow here rewrites it from the newest release each day, with `update-formula.sh`.

GPL-3.0-or-later, as E8.
