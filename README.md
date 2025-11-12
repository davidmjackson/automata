# CrashColony (Automata) — Godot 4 Project Plan

A concise, structured plan to build a 2D top‑down factory/exploration game in Godot 4 using GDScript. This document organizes the provided notes, adds missing glue, and tracks changes via an embedded changelog.

> Note on naming: the folder is `Automata` while the intended project name in notes is “CrashColony”. Please confirm if you want the Godot project name to be CrashColony and whether to rename the Windows folder/repo for consistency.

---

## 1) Project Overview

- Genre: 2D top‑down factory + exploration.
- Engine: Godot 4.3+ (GDScript only; no external plugins).
- Visuals: minimalist (lines for belts, simple icons for machines).
- Core loop (MVP): explore → mine → transport → smelt → store; powered by solar; research unlocks Splitter; save/load supports round‑trip.
- Control surface: player interacts via a crashed ship UI with multiple tabs.

## 2) Constraints and Global Rules

- Godot 4.3+, GDScript only; no external plugins.
- 2D orthographic, fixed top‑down camera.
- Deterministic simulation tick at 10 Hz; rendering decoupled.
- Signals for UI updates (no polling).
- Keep functions short, single responsibility; use constants for tunables.
- Data files: JSON under `res://data/`.
- Scenes under `res://scenes/`, scripts under `res://scripts/`.
- MVP belts: aggregate counts per segment (object pooling later).
- Provide full file contents on each edit during development workflow.

## 3) MVP Scope (Feature Checklist)

- Fog of war with a scout robot revealing tiles while moving.
- World with one iron vein near crash site.
- Chain: Miner → Belt → Smelter → Storage, with item flow and counts.
- Solar power generation; power panel shows generation vs load.
- Research tab unlocks Splitter (behavior can be stubbed for MVP).
- Save/Load round‑trip of entire state without errors.
- Fixed 10 Hz tick verified via debug overlay (stable production rates).

## 4) Target Directory Structure (Workspace Scaffold)

```
project.godot
scenes/
  Main.tscn
  ShipUI.tscn
  Map.tscn
  Robot.tscn
  Miner.tscn
  Smelter.tscn
  Storage.tscn
  BeltSegment.tscn
  PowerGrid.tscn
scripts/
  Main.gd
  GameState.gd
  TickLoop.gd
  Map.gd
  FogOfWar.gd
  ShipUI.gd
  Robot.gd
  JobSystem.gd
  Miner.gd
  Smelter.gd
  Storage.gd
  BeltSegment.gd
  PowerGrid.gd
  Research.gd
  SaveLoad.gd
  Items.gd
  Recipes.gd
  IMachine.gd
data/
  items.json
  recipes.json
  machines.json
  tech.json
assets/
  icons/ (placeholder PNGs)
  fonts/
```

## 5) Core Systems (Design Summary)

- TickLoop.gd
  - Fixed step 0.1s using accumulator in `_process(delta)`; emit `tick(dt_fixed)`.
  - Order per tick: power → machines → belts → robots → alerts; clamp 5 steps/frame.
- GameState.gd (Autoload)
  - Holds: entities, belts, machines, robots, inventories, research_state, power_state, world_seed.
  - Helpers: `register_entity`, `get_entity`, `each_in_chunk`, `rng(seed_offset)`.
- Map.gd + FogOfWar.gd
  - 128×128 tilemap; noise‑based biomes; fog mask reveals around scout and beacons.
  - Resource veins via noise threshold; ensure iron near origin.
- Items.gd / Recipes.gd
  - Load JSON; lookups `get_item(id)`, `get_recipe(id)`; define stack sizes.
- PowerGrid.gd
  - Producers/consumers graph; compute available power; proportional throttling under deficit; expose live numbers.
- BeltSegment.gd
  - Connects output→input; aggregated per‑item rates; push/pull per tick with throughput.
- Machines (IMachine.gd interface; Miner.gd, Smelter.gd, Storage.gd)
  - Uniform interface: `request_power()`, `process_tick(dt)`, `get_io_ports()`.
  - Miner: consumes power, outputs ore if on vein; Smelter: ore→ingots per recipe; Storage: capacities, any item.
- Robot.gd + JobSystem.gd
  - Robot states: Idle → Plan → Move → Act → Return/Recharge; battery drain; recharge at ship/dock.
  - A* grid pathfinding on Map; MVP robot type: Scout (reveal).
  - Job queue with priorities: Explore(radius), PlaceMiner(pos), PlaceBeltChain(points), PlaceSmelter(pos).
- Research.gd
  - Tech unlocks from `tech.json`; MVP: Splitter unlock.
- SaveLoad.gd
  - JSON save of world, entities, inventories, research, power nets; autosave every 120s and on quit.
- Ship UI (ShipUI.tscn + ShipUI.gd)
  - Tabs: Overview, Map, Robots, Factory, Research, Power, Alerts.
  - Provide KPIs, map interactions, robot/job assignment, factory placement, research queue, power control, alerts list.

## 6) Data Specifications (Initial)

- data/items.json
  - `iron_ore`, `iron_ingot`, `coal`, `plate`, `wire` (example set) with stack sizes.
- data/recipes.json
  - `iron_smelt`: 1 ore → 1 ingot, time 2.0, power 2.0.
- data/machines.json
  - `miner_v1`, `smelter_v1`, `storage_small`, `belt_t1`, `solar_panel`, `battery_bank`.
- data/tech.json
  - `splitter` unlock gated by ingots/time; appears in Research UI.

## 7) Acceptance Criteria

- Launches to `Main.tscn`; Ship UI visible with tabs.
- Fog of war renders; Scout reveals tiles while moving.
- One iron vein near crash; place Miner via simple build.
- Belt chain from Miner → Smelter → Storage with item counts updating.
- Solar panel provides power; Power tab shows generation vs load; pausing Smelter affects ingot/min immediately.
- Research tab can unlock Splitter (behavior stub acceptable).
- Save/Load round‑trip of entire state without errors.
- Fixed 10 Hz tick verified by debug overlay and stable rates.

## 8) Implementation Plan (Phased)

Phase 0 — Environment & Repo
- Confirm project name (CrashColony vs Automata) and GitHub URL.
- Install Godot 4.3+ and Git; clone repo into `D:\\Development\\Projects\\Game\\Automata`.

Phase 1 — Project Scaffold
- Create Godot project (`project.godot`); add folders per scaffold; add placeholder icons/fonts.
- Add autoloads: `GameState.gd`, `TickLoop.gd`.
- Create `Main.tscn`; instantiate `Map.tscn`, `ShipUI.tscn`, `PowerGrid.tscn`; connect TickLoop signals.

Phase 2 — Tick + State Backbone
- Implement `TickLoop.gd` with 0.1s fixed step and clamped catch‑up.
- Implement `GameState.gd` storage, registration helpers, and deterministic RNG.

Phase 3 — Data Loaders + Files
- Implement `Items.gd`, `Recipes.gd`; create minimal JSON files under `res://data/`.

Phase 4 — World Gen + Fog
- Implement `Map.tscn` with TileMap and `Map.gd` world gen (noise biomes, iron near origin).
- Implement `FogOfWar.gd` mask; reveal around scout and beacons.

Phase 5 — Machines + Belts + Power
- Implement `IMachine.gd` contract; `Miner.gd`, `Smelter.gd`, `Storage.gd`.
- Implement `BeltSegment.gd` (aggregated throughput) and port linkage.
- Implement `PowerGrid.gd` with proportional throttling and live metrics.

Phase 6 — Robots + Jobs
- Implement `Robot.gd` state machine with battery and A* pathfinding.
- Implement `JobSystem.gd` with Explore/Place* jobs and priority ordering.

Phase 7 — Ship UI
- Build tabs: Overview, Map, Robots, Factory, Research, Power, Alerts.
- Wire signals: `tick(dt_fixed)`, `power_changed`, `inventory_changed`, `job_added`, `job_completed`.

Phase 8 — Research
- Implement `Research.gd`; load `tech.json`; queue and unlock Splitter.

Phase 9 — Save/Load
- Implement `SaveLoad.gd`; write/read `user://saves/slot1.json`; autosave (120s, on quit).

Phase 10 — Debug & Demo
- Add debug overlay (tick count, power balance, ore/min, ingot/min).
- Add menu action “Run Demo” to auto‑place basic production line and report totals after 60s.

Phase 11 — QA & Polishing
- Verify acceptance criteria; fix runtime errors; profile tick cadence stability.

## 9) Run Instructions (MVP)

- Open the project in Godot 4.3+.
- Press Play: use Ship UI to place Miner, Smelter, Storage, and draw a Belt.
- Use the Demo menu to auto‑place a minimal production loop and sanity‑check rates.

## 10) Windows Setup (Godot + Git)

Godot 4.3+
1) Download the Godot 4.3 (or newer 4.x) stable Windows editor from the official site.
2) Extract, then run the editor; choose or create the project at `D:\\Development\\Projects\\Game\\Automata`.

Git for Windows
1) Download “Git for Windows” from the official site and run the installer.
2) Accept defaults (enables `git` on PATH). Optionally enable “Git Credential Manager”.
3) Clone your GitHub repo into `D:\\Development\\Projects\\Game\\Automata` or initialize in place and set the remote:
   - Existing empty folder, set remote:
	 - `git init`
	 - `git remote add origin https://github.com/<you>/<repo>.git`
	 - `git add . && git commit -m "chore: bootstrap readme"`
	 - `git push -u origin main`
   - Or clone directly into `D:\\Development\\Projects\\Game\\`:
	 - `git clone https://github.com/<you>/<repo>.git Automata`

Godot Autoloads
- In Project Settings → Autoload, add `res://scripts/GameState.gd` and `res://scripts/TickLoop.gd` as singletons.

## 11) Risks, Assumptions, and Notes

- Determinism: fixed tick and JSON data should yield deterministic production; RNG seeding must be consistent in `GameState.gd`.
- Performance: belts are aggregated in MVP; per‑item entities and pooling deferred.
- UI Latency: prefer signals over polling to keep Ship UI responsive.
- Assets: use placeholder icons first; refine later.
- Licensing: please specify a license (MIT recommended) and asset sources.

## 12) Open Questions (Please Confirm)

- Project name: use “CrashColony” (notes) or “Automata” (folder/repo)?
- GitHub URL: what is the repo URL so we can set the remote?
- Godot version: confirm exact version (4.3.x) to target.
- Target resolution and UI scale (e.g., 1920×1080, 100% scale)?
- Any preferences for input bindings or are mouse‑only placements sufficient for MVP?

## 13) Next Actions

- You: confirm the naming, provide repo URL, install Godot and Git.
- Me (after confirmation): scaffold the Godot project, folders, scenes, and scripts; add autoloads and placeholders; begin Phase 2 implementation.

---

## Changelog

- 2025-11-12 — Initial plan and README created; organized requirements, added phased implementation plan, setup steps, and open questions.
