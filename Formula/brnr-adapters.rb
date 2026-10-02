class BrnrAdapters < Formula
  desc "ACP adapters for Claude Code and Codex, compiled locally for brnr"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "d0d76cd7a83c2b03da95137d3a0584376ed8a0bdad66056bcae2922ef0f9ad20"
  # The adapters are Apache-2.0, but claude-agent-acp compiles in the Claude
  # Agent SDK, which is under Anthropic's Commercial Terms.
  license :cannot_represent
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "bun" => :build

  def install
    # brnr's own build of the adapters (pinned by adapters/bun.lock), as
    # single-file executables. It leaves out the agents the adapters' npm
    # packages would bring along: they run the user's claude and codex.
    system "adapters/build.sh", buildpath/"out"
    bin.install "out/claude-agent-acp", "out/codex-acp"
    (pkgshare/"licenses").install Dir["out/licenses/*"]
  end

  def caveats
    <<~EOS
      The adapters run your own Claude Code (claude) and Codex (codex); install
      those separately. brnr finds the adapters by name:
        brnr proxy -- claude-agent-acp

      claude-agent-acp includes the Claude Agent SDK, which is licensed under
      Anthropic's Commercial Terms: https://www.anthropic.com/legal/commercial-terms
      The licenses of everything compiled in are in:
        #{opt_pkgshare}/licenses
    EOS
  end

  test do
    request = '{"jsonrpc":"2.0","id":1,"method":"initialize",' \
              '"params":{"protocolVersion":1,"clientCapabilities":{}}}'
    %w[claude-agent-acp codex-acp].each do |adapter|
      # Stdin stays open until the answer is in: codex-acp exits at EOF.
      IO.popen(bin/adapter, "r+") do |io|
        io.puts request
        assert_match '"protocolVersion":1', io.gets
        io.close_write
      end
    end
  end
end
