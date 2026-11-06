# Written by update-formula.sh from E8 0.3.0's release; edit the
# script, not this file.
class E8 < Formula
  desc "Editor that works the way Emacs works, extended in TypeScript"
  homepage "https://github.com/e8-editor/e8"
  version "0.3.0"
  license "GPL-3.0-or-later"

  on_macos do
    on_arm do
      url "https://github.com/e8-editor/e8/releases/download/v0.3.0/e8-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "2220f1ab8405ec28c3c84735521eaa54405913d14f501709c9a16f4322303bf1"

      resource "app" do
        url "https://github.com/e8-editor/e8/releases/download/v0.3.0/E8-0.3.0-aarch64-apple-darwin.app.tar.gz"
        sha256 "fc9abfd1f00d9487729cabe192df2644846f66c4b388e776a1054b198164421b"
      end
    end
  end

  on_linux do
    on_intel do
      url "https://github.com/e8-editor/e8/releases/download/v0.3.0/e8-0.3.0-x86_64-unknown-linux-gnu.tar.gz"
      sha256 "4eeb448ac7540f96f89e5ca24ba4eab6f3954d6ddb05b5c3505730932d393fb9"
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
