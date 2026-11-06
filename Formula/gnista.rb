# Written by update-formula.sh from Gnista 0.2.2's release; edit the
# script, not this file.
class Gnista < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/Gnista-Editor/gnista"
  version "0.2.2"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.2/gnista-0.2.2-aarch64-apple-darwin.tar.gz"
      sha256 "5982291e09ff06fc1eca641b8de2bef24324ad871410c720309f7b295eed2a29"

      resource "app" do
        url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.2/Gnista-0.2.2-aarch64-apple-darwin.app.tar.gz"
        sha256 "2cb76a308f4f70ee503fd3e31e408692d58407e3f8a5d234fe36bff2fbb26018"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/Gnista-Editor/gnista/releases/download/v0.2.2/gnista-0.2.2-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "ed20e1dfebb556f922548b34136c99e321c2b158b424b29272d6e4be7f4da1eb"
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
