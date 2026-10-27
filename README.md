# brnrhq/homebrew-tap

Homebrew formulae for [brnr](https://github.com/brnrhq/brnr).

```sh
brew install brnrhq/tap/brnr
```

Or `brew tap brnrhq/tap` and then `brew install brnr`.

`Formula/brnr.rb` builds brnr from source (Rust is a build-only dependency).
The brnr release workflow updates it on every version tag.

## The adapters

```sh
brew install brnrhq/tap/brnr-claude-adapter   # for Claude Code
brew install brnrhq/tap/brnr-codex-adapter    # for Codex
brew install brnrhq/tap/brnr-muse-adapter     # for Muse Code
```

These are the community's ACP adapters, not brnr's work:

| Formula | Is | By | License |
|---|---|---|---|
| `brnr-claude-adapter` | [claude-agent-acp](https://github.com/agentclientprotocol/claude-agent-acp) | Zed Industries, Inc. and contributors | Apache-2.0; it includes Anthropic's Claude Agent SDK, under Anthropic's [Commercial Terms](https://www.anthropic.com/legal/commercial-terms) |
| `brnr-codex-adapter` | [codex-acp](https://github.com/agentclientprotocol/codex-acp) | JetBrains s.r.o. | Apache-2.0 |
| `brnr-muse-adapter` | [muse-acp](https://github.com/BrokkAi/muse-acp) | BrokkAi and contributors | Apache-2.0 |

Each formula compiles its adapter on your machine, unchanged, and links it
next to `brnr`. Claude Code's and Codex's are built with bun into standalone
executables that need no Node.js; brnr's part is a small launcher in front (it
finds your own `claude` or `codex`, and answers `--version`) and the build, from
brnr's `adapters/`. Muse Code's is built with Cargo from its pinned Rust source
tag, which the formula checksums; it finds your own `muse` and answers
`--version` itself. The commands have names of their own, apart from the npm
packages' `claude-agent-acp`, `codex-acp` and `muse-acp`. Each formula's
version is its adapter's, so `brew upgrade` rebuilds an adapter when it moves.
