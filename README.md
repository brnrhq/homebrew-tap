# brnrhq/homebrew-tap

Homebrew formulae for [brnr](https://github.com/brnrhq/brnr).

```sh
brew install brnrhq/tap/brnr
```

Or `brew tap brnrhq/tap` and then `brew install brnr`.

`Formula/brnr.rb` builds brnr from source (Rust is a build-only dependency).
The brnr release workflow updates it on every version tag.

## brnr-adapters

```sh
brew install brnrhq/tap/brnr-adapters
```

The ACP adapters for Claude Code and Codex, as `brnr-claude-adapter` and
`brnr-codex-adapter` (names of their own, apart from the npm packages'
commands), compiled on your machine with bun from brnr's `adapters/` at the
same version, and linked next to `brnr`. They run your own `claude` and `codex`.
claude-agent-acp includes the Claude Agent SDK, which is licensed under
Anthropic's Commercial Terms.
