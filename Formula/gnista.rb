# Written by update-formula.sh from Gnista 0.2.1's release; edit the
# script, not this file.
class Gnista < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/Gnista-Editor/gnista"
  version "0.2.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.1/gnista-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "9997a479a3d07d94a05e46022d1d93be1113fd5b80f559767e74ad471811d5c6"

      resource "app" do
        url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.1/Gnista-0.2.1-aarch64-apple-darwin.app.tar.gz"
        sha256 "6c09e350e0fbc1e61f12347effe1be3e96cfe1718e354ef3641995610e403bec"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.1/gnista-0.2.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "2a5f1dd117272c82c4f6f9898cdf97bd744660e213054f762797fc968b74a806"
    end
  end

  def install
    bin.install "gnista", "gnista-mcp"
    resource("app").stage { prefix.install "Gnista.app" } if OS.mac? && resources.any? { |r| r.name == "app" }
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
