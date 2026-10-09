# Versioned by the npm package it builds (codex-acp), which the brnr release
# workflow writes from adapters/package.json: brew upgrade rebuilds the
# adapter when that moves, not on every brnr release.
class BrnrCodexAdapter < Formula
  desc "JetBrains' ACP adapter for Codex (codex-acp), needing no Node.js"
  homepage "https://brnrhq.github.io/brnr/"
  url "https://github.com/brnrhq/brnr/releases/download/v0.7.0/brnr-0.7.0.tar.gz"
  version "2.1.1"
  sha256 "0cc4cf1794faf84be4f2b1d7c7e4a0b6d3979b3b4af0a1788ccaa793cf1c0fae"
  license "Apache-2.0"
  revision 1
  head "https://github.com/brnrhq/brnr.git", branch: "main"

  depends_on "bun" => :build

  def install
    # brnr's own build (pinned by adapters/bun.lock), as a single-file
    # executable. It leaves out the agent the npm package would bring along:
    # the adapter runs the user's codex.
    system "adapters/build.sh", buildpath/"out", "codex"
    bin.install "out/brnr-codex-adapter"
    (pkgshare/"licenses").install Dir["out/licenses/*"]
  end

  def caveats
    <<~EOS
      brnr-codex-adapter is codex-acp, by JetBrains s.r.o. (Apache-2.0):
        https://github.com/agentclientprotocol/codex-acp
      brnr compiles it, unchanged, into a standalone executable that needs no
      Node.js, with a small launcher of its own in front.

      It runs your own Codex (codex); install that separately. In an editor,
      or with brnr start:
        brnr acp -- brnr-codex-adapter

      The licenses of everything compiled in are in:
        #{opt_pkgshare}/licenses
    EOS
  end

  test do
    assert_equal "brnr-codex-adapter #{version} (@agentclientprotocol/codex-acp)",
                 shell_output("#{bin}/brnr-codex-adapter --version").strip
    # The adapter exits at once if it can't find codex. With a stand-in it
    # answers initialize with an error (it starts the agent to initialize),
    # which still shows it runs and speaks ACP.
    agent = testpath/"agent"
    agent.write "#!/bin/sh\nexit 1\n"
    agent.chmod 0755
    ENV["CODEX_PATH"] = agent
    request = '{"jsonrpc":"2.0","id":1,"method":"initialize",' \
              '"params":{"protocolVersion":1,"clientCapabilities":{}}}'
    # Stdin stays open until the answer is in: an adapter may exit at EOF.
    IO.popen(bin/"brnr-codex-adapter", "r+") do |io|
      io.puts request
      assert_match '{"jsonrpc":"2.0","id":1,', io.gets
      io.close_write
    end
  end
end
