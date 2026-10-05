# Versioned by the npm package it builds (claude-agent-acp), which the brnr release
# workflow writes from adapters/package.json: brew upgrade rebuilds the
# adapter when that moves, not on every brnr release.
class BrnrClaudeAdapter < Formula
  desc "Zed's ACP adapter for Claude Code (claude-agent-acp), needing no Node.js"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/archive/refs/tags/v0.2.0.tar.gz"
  version "0.85.1"
  sha256 "d0d76cd7a83c2b03da95137d3a0584376ed8a0bdad66056bcae2922ef0f9ad20"
  # claude-agent-acp is Apache-2.0, but it compiles in the Claude Agent SDK,
  # which is under Anthropic's Commercial Terms.
  license :cannot_represent
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "bun" => :build

  def install
    # brnr's own build (pinned by adapters/bun.lock), as a single-file
    # executable. It leaves out the agent the npm package would bring along:
    # the adapter runs the user's claude.
    system "adapters/build.sh", buildpath/"out", "claude"
    # brnr 0.2.0's build.sh builds both adapters, under the npm names.
    built = File.exist?("out/brnr-claude-adapter") ? "out/brnr-claude-adapter" : "out/claude-agent-acp"
    bin.install built => "brnr-claude-adapter"
    (pkgshare/"licenses").install Dir["out/licenses/*"]
  end

  def caveats
    <<~EOS
      brnr-claude-adapter is claude-agent-acp, by Zed Industries, Inc. and
      contributors (Apache-2.0): https://github.com/agentclientprotocol/claude-agent-acp
      brnr compiles it, unchanged, into a standalone executable that needs no
      Node.js, with a small launcher of its own in front.

      It runs your own Claude Code (claude); install that separately. In an
      editor, or with brnr start:
        brnr acp -- brnr-claude-adapter

      It includes the Claude Agent SDK, which is licensed under Anthropic's
      Commercial Terms: https://www.anthropic.com/legal/commercial-terms
      The licenses of everything compiled in are in:
        #{opt_pkgshare}/licenses
    EOS
  end

  test do
    # The adapter exits at once if it can't find claude, but answering
    # initialize needs no real one: a stand-in will do.
    agent = testpath/"agent"
    agent.write "#!/bin/sh\nexit 1\n"
    agent.chmod 0755
    ENV["CLAUDE_CODE_EXECUTABLE"] = agent
    request = '{"jsonrpc":"2.0","id":1,"method":"initialize",' \
              '"params":{"protocolVersion":1,"clientCapabilities":{}}}'
    # Stdin stays open until the answer is in: an adapter may exit at EOF.
    IO.popen(bin/"brnr-claude-adapter", "r+") do |io|
      io.puts request
      assert_match '"protocolVersion":1', io.gets
      io.close_write
    end
  end
end
