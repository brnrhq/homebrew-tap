class Brnr < Formula
  desc "Burner phone for your coding agents: run ACP agents behind a reachable host"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/releases/download/v0.12.0/brnr-0.12.0.tar.gz"
  sha256 "4d2f2bbb3f0015a33932398656454e1d310bea4de772df72a534bade74c112a3"
  license "Apache-2.0"
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  def caveats
    <<~EOS
      For Claude Code, Codex and Muse Code, brnr needs their ACP adapters:
        brew install brnrhq/tap/brnr-claude-adapter
        brew install brnrhq/tap/brnr-codex-adapter
        brew install brnrhq/tap/brnr-muse-adapter
      or from npm: @agentclientprotocol/claude-agent-acp, @agentclientprotocol/codex-acp,
      @brokkai/muse-acp
    EOS
  end

  test do
    assert_match(/^brnr \d+\.\d+\.\d+$/, shell_output("#{bin}/brnr --version").strip)
    ENV["BRNR_DIR"] = testpath/"run"
    ENV["BRNR_HOME"] = testpath/"home"
    # A list is an object since 0.10.0: {"sessions": [...]}.
    assert_equal({ "sessions" => [] }, JSON.parse(shell_output("#{bin}/brnr session list --json")))
  end
end
