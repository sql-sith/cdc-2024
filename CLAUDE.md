# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Educational repository for the Cedar Rapids Area Homeschools IT Club's Cyber Defense competition (2023-2024 season). Contains cryptography implementations, shell scripting exercises, and meeting/homework documentation.

## Running Code

There is no build system — all scripts run directly.

### Diffie-Hellman (Python)

```bash
cd src/diffie_hellman

# Install dependencies (first time)
python -m pip install -r requirements.txt

# Interactive version (user supplies p, g, private keys)
python diffie_hellman.py

# Automated version with 2048-bit RFC 3526 primes (requires gmpy2)
python diffie_hellman_gmpy.py

# Refactored variants follow the same pattern
python diffie_hellman_refactored.py
python diffie_hellman_refactored_gmpy.py
```

Python 3.10.4+ required. Platform-specific gmpy2 wheels are pre-vendored in `src/diffie_hellman/vendor/` for Windows and Linux.

### Bash / Shell scripts

```bash
cd src/filter_files
bash bash-is-fun-solved-better.sh
```

### PowerShell

```powershell
cd src/filter_files
.\Get-FilteredFiles.ps1
```

## Architecture

### `src/diffie_hellman/`

Demonstrates the Diffie-Hellman key exchange protocol with narrative output showing what Alice, Bob, and Eve each know at every step.

- `diffie_hellman.py` — interactive: prompts user for `p`, `g`, and each party's private key
- `diffie_hellman_gmpy.py` — automated: uses hardcoded 2048-bit RFC 3526 group parameters and random private keys; uses `gmpy2` for fast modular exponentiation
- `diffie_hellman_refactored*.py` — cleaner rewrites of the above two
- `diffie_hellman_idna.py` — variant exploring IDNA encoding
- `calutils/strings/` — shared I/O helpers (`get_string`, `get_int`, text-box formatting)

The central abstraction is the `Person` class, which tracks each participant's knowledge state. `tell_everyone()` broadcasts a value to all parties; `tell_all()` prints what a given person knows.

### `src/filter_files/`

Shell scripting exercises around filtering/sorting a directory listing by filename, filename length, or vowel count. Each file represents a teaching stage:

| File | Purpose |
|------|---------|
| `bash-is-fun.sh` | Partial skeleton for students |
| `bash-is-fun-solved.sh` | Simple complete solution |
| `bash-is-fun-solved-better.sh` | Best-practice solution (arrays, named variables) |
| `bash-is-buggy.sh` | Intentionally broken — debugging exercise |
| `bash-is-buggy-solved.sh` | Corrected version |
| `Get-FilteredFiles.ps1` | PowerShell equivalent |

### `documentation/`

Setup guides for the ISERink VM platform (`documentation/iseage/`) and repository contribution instructions (`documentation/repo/`).

### `meeting-notes/`

Chronological meeting notes and homework assignments for the 2023-2024 season.

## Dependencies

`src/diffie_hellman/requirements.txt`:
- `primePy==1.3` — primality testing
- `gmpy2` — high-precision arithmetic (optional; pre-built wheels in `vendor/` cover Windows and Linux)

## Repository Conventions

- Student solutions go in a personal subfolder (e.g., `src/filter_files/your-name/`) — see `documentation/repo/AddingYourSolutions.md`
- `vypy/` (PyPy virtual environment) and `_wip/` directories are git-ignored
