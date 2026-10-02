class Brnr < Formula
  desc "Burner phone for your coding agents: run ACP agents behind a reachable host"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d0d76cd7a83c2b03da95137d3a0584376ed8a0bdad66056bcae2922ef0f9ad20"
  license "Apache-2.0"
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      For Claude Code and Codex, brnr needs their ACP adapters:
        brew install brnrhq/tap/brnr-adapters
      or from npm: @agentclientprotocol/claude-agent-acp, @agentclientprotocol/codex-acp
    EOS
  end

  test do
    assert_match "brnr proxy", shell_output("#{bin}/brnr --help")
    ENV["BRNR_DIR"] = testpath/"run"
    ENV["BRNR_HOME"] = testpath/"home"
    assert_equal "[]", shell_output("#{bin}/brnr list --json").strip
  end
end
