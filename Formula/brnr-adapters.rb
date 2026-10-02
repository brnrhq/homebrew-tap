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
    # Names of their own, apart from the npm packages' commands. brnr 0.2.0's
    # build.sh still used the npm names.
    { "brnr-claude-adapter" => "claude-agent-acp", "brnr-codex-adapter" => "codex-acp" }.each do |name, old|
      built = File.exist?("out/#{name}") ? "out/#{name}" : "out/#{old}"
      bin.install built => name
    end
    (pkgshare/"licenses").install Dir["out/licenses/*"]
  end

  def caveats
    <<~EOS
      The adapters run your own Claude Code (claude) and Codex (codex); install
      those separately. brnr finds the adapters by name:
        brnr proxy -- brnr-claude-adapter
        brnr proxy -- brnr-codex-adapter

      brnr-claude-adapter includes the Claude Agent SDK, which is licensed under
      Anthropic's Commercial Terms: https://www.anthropic.com/legal/commercial-terms
      The licenses of everything compiled in are in:
        #{opt_pkgshare}/licenses
    EOS
  end

  test do
    # The adapters exit at once if they can't find the user's agent: a
    # stand-in will do. With it, claude's adapter answers initialize, and
    # codex's answers with an error (it starts the agent to initialize); both
    # show the executable runs and speaks ACP.
    agent = testpath/"agent"
    agent.write "#!/bin/sh\nexit 1\n"
    agent.chmod 0755
    ENV["CLAUDE_CODE_EXECUTABLE"] = agent
    ENV["CODEX_PATH"] = agent
    request = '{"jsonrpc":"2.0","id":1,"method":"initialize",' \
              '"params":{"protocolVersion":1,"clientCapabilities":{}}}'
    %w[brnr-claude-adapter brnr-codex-adapter].each do |adapter|
      # Stdin stays open until the answer is in: the codex adapter exits at EOF.
      IO.popen(bin/adapter, "r+") do |io|
        io.puts request
        assert_match '{"jsonrpc":"2.0","id":1,', io.gets
        io.close_write
      end
    end
    IO.popen(bin/"brnr-claude-adapter", "r+") do |io|
      io.puts request
      assert_match '"protocolVersion":1', io.gets
      io.close_write
    end
  end
end
