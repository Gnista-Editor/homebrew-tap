# Homebrew tap for Gnista

[Gnista](https://github.com/Gnista-Editor/gnista) for Homebrew, on Apple silicon Macs and on Linux:

```bash
brew install gnista-editor/tap/gnista
```

That installs `gnista`, the editor in a terminal, and `gnista-mcp`, which lets an agent such as Claude Code use Gnista. On a Mac it also installs `Gnista.app`, the editor in a window; to open it from Launchpad and Spotlight, link it into `/Applications`:

```bash
ln -sf "$(brew --prefix)/opt/gnista/Gnista.app" /Applications/Gnista.app
```

Homebrew downloads the release with `curl`, so macOS does not quarantine it, and the app opens though it is not signed with an Apple Developer ID.

`brew upgrade gnista` brings it up to date. The formula follows Gnista's releases: a workflow here rewrites it from the newest release each day, with `update-formula.sh`.

GPL-3.0-or-later, as Gnista.
