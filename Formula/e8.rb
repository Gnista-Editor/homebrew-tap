# Written by update-formula.sh from E8 0.3.1's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.3.1"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.3.1/e8-0.3.1-aarch64-apple-darwin.tar.gz"
      sha256 "6d34769b18adf3bc701c742b1e939a7d59633739649f7a457baab631325edb0b"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.3.1/E8-0.3.1-aarch64-apple-darwin.app.tar.gz"
        sha256 "7ed1fd2fc320d2e474d658e0a93cde991bd5d8b4647cf0345a16cdc9accb5157"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.3.1/e8-0.3.1-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "e8086a80ec0c8b4c001e5d065a0691757f1d8e3a20ccd3485050f18d9a7fbf29"
    end
  end

  def install
    bin.install "e8", "e8-mcp"
    # Homebrew strips the one folder at the top of the tarball, E8.app,
    # when it unpacks it, so the app is staged into a folder of that name.
    resource("app").stage(prefix/"E8.app") if OS.mac? && resources.any? { |r| r.name == "app" }
  end

  def caveats
    return unless (opt_prefix/"E8.app").exist?

    <<~EOS
      The window version is E8.app, in #{opt_prefix}. To open it from
      Launchpad and Spotlight, link it into /Applications:
        ln -sf #{opt_prefix}/E8.app /Applications/E8.app
    EOS
  end

  test do
    output = shell_output("#{bin}/e8 --batch --eval 'e8.message(e8.variable(\"e8-version\"))' 2>&1")
    assert_equal version.to_s, output.strip
  end
end
