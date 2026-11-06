#!/bin/sh
# Writes Formula/gnista.rb for a release of Gnista-Editor/gnista, the newest
# unless a tag is given, from the checksums the release carries:
#
#   ./update-formula.sh [v0.2.1]
#
# The tap's workflow runs it each day and commits the formula if it changed.
set -eu

repo=Gnista-Editor/gnista
tag=${1:-$(gh release view --repo "$repo" --json tagName -q .tagName)}
version=${tag#v}
base="https://github.com/$repo/releases/download/$tag"

sum() {
	gh release download "$tag" --repo "$repo" --pattern "$1.sha256" --output - | cut -d' ' -f1
}

mac=$(sum "gnista-$version-aarch64-apple-darwin.tar.gz")
# Gnista.app is in releases since 0.2.1.
app=$(sum "Gnista-$version-aarch64-apple-darwin.app.tar.gz" 2>/dev/null || true)
linux=$(sum "gnista-$version-x86_64-unknown-linux-gnu.tar.gz")

mkdir -p Formula
cat > Formula/gnista.rb <<RUBY
# Written by update-formula.sh from Gnista $version's release; edit the
# script, not this file.
class Gnista < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/$repo"
  version "$version"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "$base/gnista-$version-aarch64-apple-darwin.tar.gz"
      sha256 "$mac"
$(if [ -n "$app" ]; then cat <<APP

      resource "app" do
        url "$base/Gnista-$version-aarch64-apple-darwin.app.tar.gz"
        sha256 "$app"
      end
APP
fi)
    end
  end

  on_linux do
    on_intel do
      url "$base/gnista-$version-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "$linux"
    end
  end

  def install
    bin.install "gnista", "gnista-mcp"
    # Homebrew strips the one folder at the top of the tarball, Gnista.app,
    # when it unpacks it, so the app is staged into a folder of that name.
    resource("app").stage(prefix/"Gnista.app") if OS.mac? && resources.any? { |r| r.name == "app" }
  end

  def caveats
    return unless (opt_prefix/"Gnista.app").exist?

    <<~EOS
      The window version is Gnista.app, in #{opt_prefix}. To open it from
      Launchpad and Spotlight, link it into /Applications:
        ln -sf #{opt_prefix}/Gnista.app /Applications/Gnista.app
    EOS
  end

  test do
    output = shell_output("#{bin}/gnista --batch --eval 'gnista.message(gnista.variable(\"gnista-version\"))' 2>&1")
    assert_equal version.to_s, output.strip
  end
end
RUBY
echo "Formula/gnista.rb: Gnista $version"
