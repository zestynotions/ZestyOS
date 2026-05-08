# ZestyOS

```
  _____         _          ___  ____
 |__  /___  ___| |_ _   _ / _ \/ ___|
   / // _ \/ __| __| | | | | | \___ \
  / /|  __/\__ \ |_| |_| | |_| |___) |
 /____\___||___/\__|\__, |\___/|____/
                    |___/
            a.k.a. RustyAlpine
```

A lean, **systemd-free** Linux desktop built on Alpine, glued together
with **OpenRC**, and driven almost entirely by **Rust-based userland
tools** under the **MangoWC** Wayland compositor.

## Intention

Most modern desktop distros ship a heavy init, a sprawling service
manager, GNU coreutils everywhere, and a compositor stack written in C.
ZestyOS goes the other direction:

- **No systemd.** OpenRC handles init and services. Service management
  is done through `zestyos_services`, a small `skim`-driven fuzzy picker
  that wraps `rc-service` and `rc-update`.
- **musl + BusyBox base.** Alpine's tiny footprint is the foundation —
  fast boot, small RAM, small disk, predictable behaviour.
- **Rust over C wherever sane.** Coreutils replacements, search,
  navigation, monitoring, prompts, and TUIs all favour Rust ports.
  Faster, safer, friendlier output, and consistently good defaults.
- **MangoWC as compositor.** A lightweight, tiling-friendly Wayland
  compositor — keeps the graphical session minimal and keyboard-first,
  in keeping with the rest of the system.

The result is a desktop that boots fast, stays out of the way, and is
small enough to understand end-to-end.

## Stack at a glance

| Layer        | Choice                                       |
|--------------|----------------------------------------------|
| Base distro  | Alpine Linux (edge: main + community + testing) |
| libc / utils | musl + BusyBox                               |
| Init         | OpenRC (parallel boot enabled)               |
| Privilege    | `doas` (not sudo)                            |
| Seat / input | `seatd` + `eudev`                            |
| Compositor   | MangoWC (Wayland)                            |
| Terminal     | Alacritty                                    |
| Shell        | Zsh + Starship prompt                        |
| Launcher     | Wofi                                         |

## Rust-based userland

Installed by `zestyos_finish`:

| Tool         | Replaces / role                         |
|--------------|-----------------------------------------|
| `bat`        | `cat` with syntax highlighting          |
| `exa`        | `ls`                                    |
| `fd`         | `find`                                  |
| `ripgrep`    | `grep`                                  |
| `procs`      | `ps`                                    |
| `skim` (`sk`)| fuzzy finder (drives `zestyos_services`)|
| `zoxide`     | smarter `cd`                            |
| `starship`   | shell prompt                            |
| `macchina`   | system info (`neofetch`-style)          |
| `tealdeer`   | `tldr` client                           |
| `alacritty`  | GPU-accelerated terminal                |

Optional: `rustup` for a local toolchain when building or hacking on
more Rust tools.

## Repository layout

| File                | Purpose                                                      |
|---------------------|--------------------------------------------------------------|
| `alpine`            | Answers file for `setup-alpine` — fast, scripted base install |
| `zestyos`           | Stage 1 — runs as root after base install: repos, user, doas, seatd, eudev |
| `zestyos_finish`    | Stage 2 — runs as the new user on first login: compositor, fonts, Rust tools, dotfiles |
| `zestyos_services`  | Interactive OpenRC service manager (skim picker, status preview, runlevel-aware) |

## Install flow

1. Boot the Alpine ISO.
2. Run `setup-alpine -f alpine` using this repo's `alpine` answers file
   (or run `setup-alpine` interactively and pick equivalents).
3. As root, fetch and run `zestyos`:
   ```sh
   sh <(wget -qO- https://raw.githubusercontent.com/zestynotions/ZestyOS/main/alpine/zestyos)
   ```
   It enables the edge repos, installs base tools (`doas`, `git`, `zsh`,
   `seatd`, `eudev`, …), creates your wheel-group user, and reboots.
4. Log in as that user. The seeded `~/.zshrc` runs `zestyos_finish`,
   which installs MangoWC + the Rust userland + fonts and chains into
   the dotfiles bootstrap.

## Managing services

Service state is managed through `zestyos_services` rather than raw
`rc-service` / `rc-update` calls:

```sh
zestyos_services
```

It will:
- prompt for an action (`status` / `start` / `stop` / `restart` /
  `add to runlevel` / `del from runlevel` / `show all`),
- present a fuzzy, multi-select picker of services with a live
  `rc-service ... status` preview pane,
- annotate each entry with the runlevels it already belongs to
  (green = enabled, dim = not in any runlevel),
- re-exec under `doas` so it can actually mutate state.

## Philosophy

- **Small surface area.** Fewer moving parts means fewer footguns.
- **Composable shell-first tooling.** Pickers, pipes, and plain text.
- **Keyboard over mouse.** Tiling compositor, fuzzy pickers, terminal-centric flow.
- **Boring init, exciting userland.** OpenRC for the boring stuff;
  Rust tools where they actually improve daily ergonomics.

## Status

Personal daily-driver project. Expect rough edges, opinionated
defaults, and breaking changes when something better shows up upstream.
