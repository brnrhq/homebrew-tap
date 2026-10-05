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
```

These are the community's ACP adapters, not brnr's work:

| Formula | Is | By | License |
|---|---|---|---|
| `brnr-claude-adapter` | [claude-agent-acp](https://github.com/agentclientprotocol/claude-agent-acp) | Zed Industries, Inc. and contributors | Apache-2.0; it includes Anthropic's Claude Agent SDK, under Anthropic's [Commercial Terms](https://www.anthropic.com/legal/commercial-terms) |
| `brnr-codex-adapter` | [codex-acp](https://github.com/agentclientprotocol/codex-acp) | JetBrains s.r.o. | Apache-2.0 |

Each formula compiles its adapter on your machine, unchanged, with bun into a
standalone executable that needs no Node.js, and links it next to `brnr`.
brnr's part is a small launcher in front (it finds your own `claude` or
`codex`, and answers `--version`) and the build, from brnr's `adapters/`. The
commands have names of their own, apart from the npm packages'
`claude-agent-acp` and `codex-acp`. Each formula's version is the npm
package's, so `brew upgrade` rebuilds an adapter when its package moves.
