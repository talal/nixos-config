# Agent Development Guide

Conventions and instructions for coding agents.

## Directory Structure

- Shared re-usable functions: `lib/`
- Hosts: `hosts/`
- Modules: `modules/`
- Profiles: `modules/profiles/`

## Commands

- Evaluate flake and run tests: `nix flake check --option allow-import-from-derivation false`
- Format all files using treefmt: `nix fmt`

## Core Rules

- **Do not install packages globally.** Add the program/service to the relevant profile.
- **Never run a `nixos-rebuild` command.**
- Never create Git commits unless explicitly asked.
- Never push to Git remotes.
- Never create a GitHub issue.
- Never create a GitHub pull request.

## Coding Standards

- When adding a package add it to the relevant `packages.nix` file within a profile, e.g. `modules/profiles/desktop/packages.nix`.
- If a package also needs to be configured via nix options, home-manager options, or custom configuration then create a separate directory for that package within the relevant profile, e.g. `modules/profiles/desktop/zed/`.
- Reusable functions in `lib` should carry a nixdoc comment with their arguments and type signature. This form is the doc-comment standard from [RFC 145](https://github.com/NixOS/rfcs/blob/master/rfcs/0145-doc-strings.md). The body uses CommonMark for `# Arguments` and `# Type` sections.
