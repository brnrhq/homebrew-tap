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

The ACP adapters for Claude Code and Codex, as `brnr-claude-adapter` and
`brnr-codex-adapter` (names of their own, apart from the npm packages'
`claude-agent-acp` and `codex-acp`), compiled on your machine with bun from
brnr's `adapters/`, and linked next to `brnr`. Each formula's version is the
npm package's, so `brew upgrade` rebuilds an adapter when its package moves.
They run your own `claude` and `codex`. brnr-claude-adapter includes the
Claude Agent SDK, which is licensed under Anthropic's Commercial Terms.
