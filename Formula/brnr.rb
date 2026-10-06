class Brnr < Formula
  desc "Burner phone for your coding agents: run ACP agents behind a reachable host"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "443c7415782414c179cdbcbe8aadd29055af48442b6b82297eda2573efb485d6"
  license "Apache-2.0"
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      For Claude Code and Codex, brnr needs their ACP adapters:
        brew install brnrhq/tap/brnr-claude-adapter
        brew install brnrhq/tap/brnr-codex-adapter
      or from npm: @agentclientprotocol/claude-agent-acp, @agentclientprotocol/codex-acp
    EOS
  end

  test do
    assert_match(/^brnr \d+\.\d+\.\d+$/, shell_output("#{bin}/brnr --version").strip)
    ENV["BRNR_DIR"] = testpath/"run"
    ENV["BRNR_HOME"] = testpath/"home"
    assert_equal "[]", shell_output("#{bin}/brnr list --json").strip
  end
end
