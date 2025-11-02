## AGDToolbox — Copilot instructions

Short, focused guidance for AI coding agents working in this repository.

- Project type: a small Windows-focused toolbox implemented as batch scripts (.cmd) plus a helper PowerShell script.
- Key files:
  - `AGD.cmd` — the main entrypoint. Implements parameter parsing (:parse) and many labeled actions (//ANCHOR - <name>). Read this first.
  - `AGD-ok.cmd` — variant/copy of the main script; useful as a reference for alternate behavior.
  - `get.activated.win.ps1` — PowerShell helper downloaded/executed by `AGD.cmd` for activation tasks.

What to expect (big picture)
- Single-file orchestration: `AGD.cmd` is the primary surface. Commands are implemented as labels (e.g. `:ip`, `:install`, `:update`, `:nosleep`) and invoked by passing the parameter matching the label name. Parameter parsing uses the `:parse` / `goto` pattern.
- Self-updating flow: the script determines a version by file size (`fileSize`) and uses `%AGDToolbox-URL%` + `curl.exe` to download updates or helper binaries (`speedtest.exe`). Update flow uses `AGD-update.cmd` and moves files into `%windir%`.
- Privilege handling: `:getadmin` auto-elevates via a temporary `.vbs` that shell-executes the same batch with `runas`. Many actions require elevation (schtasks, registry edits, DISM, installing binaries).
- External integrations: uses `curl.exe`, `powershell.exe`, `schtasks`, `dism.exe`, and remote resources at `raw.githubusercontent.com` and `massgravel` URLs. Be explicit about network calls when editing.

Important repo conventions & patterns
- Anchors: sections are annotated with `REM //ANCHOR - <Name>` — new features should follow this pattern and place the label (e.g. `:myfeature`) immediately after the anchor comment.
- Parameter mapping: command-line token -> `:parse` mapping. Add new parameters by adding `IF "%~1"=="<cmd>" goto <cmd>` near the other IF lines and implement a label `:<cmd>`.
- Admin flag: the script sets `AGD-admin` when elevated (via `admin` param) — preserve and check that variable when adding actions that require elevation.
- Versioning: the script uses the file size as a cheap version token (`for %%F in ("%~f0") do set "fileSize=%%~zF"`). When changing behavior, be aware update logic relies on the updated file size.

Developer workflows (how to run / debug)
- Quick help locally: run `AGD.cmd help` (from PowerShell or CMD). To run a specific command: `AGD.cmd ip` or `AGD.cmd internet`.
- Test without installing: run `cmd /c .\AGD.cmd <command>` from repository root. For interactive steps the script often `pause`s — remove or keep `pause` when writing automated tests.
- Emulate scheduled behavior: the script creates scheduled tasks via `schtasks`; to test update flow simulate by running `AGD.cmd sched` which sets `AGD-Scheduled` and jumps to update logic.
- Debugging tips: enable more output by inserting `echo on` or adding verbose `echo` lines; observe `%TEMP%` for the temporary `.vbs` used to elevate; check Windows Event Viewer or run commands (e.g., `dism.exe`) manually when a step fails.

Safety & external dependencies
- Network calls are central. `AGD.cmd` pulls remote scripts/binaries (e.g. `MAS_AIO.cmd`, `speedtest.exe`). Do not change remote URLs silently; prefer adding a configurable constant at top (`AGDToolbox-URL`) when altering defaults.
- The repository contains many hard-coded product keys and system-level registry changes — treat these as sensitive operations. Do not modify activation logic or serials unless you understand the legal/operational implications.

Examples (concrete snippets to reference)
- Parameter parsing pattern (in `AGD.cmd`):

  IF "%~1"=="help" goto %~1

  :help
  echo  * AYUDA *

- Auto-elevation pattern (in `:getadmin`): creates `%TEMP%\%~n0.vbs` which runs Shell.Application.shellExecute to re-run the batch as administrator.

What to change when adding a new command
1. Add an `IF "%~1"=="<name>" goto <name>` line in the `:parse` block (follow existing spacing/style).
2. Add a `REM //ANCHOR - <Name>` comment and the `:<name>` label implementation below (use the same echo/exit conventions).
3. If the command needs elevation, call `call :getadmin` early inside the label.
4. If it downloads remote assets, add them under the existing `curl.exe` usage and honor `AGDToolbox-URL` when possible.

When merging/update guidance
- No existing `.github/copilot-instructions.md` was found; preserve any future human-written guidance. If merging with an existing file, keep the short patterns above and retain the examples referencing `AGD.cmd` anchors and `:getadmin`.

If anything here is unclear or you want more examples (e.g., more label templates or a test harness), tell me which commands you plan to edit and I will add a focused example or a small test script.
