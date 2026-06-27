# Jordan's Vox Populi customizations

Personal fork of [LoneGazebo/Community-Patch-DLL](https://github.com/LoneGazebo/Community-Patch-DLL)
(Vox Populi for Civ 5).

The **`jordan-customizations`** branch is structured so updating VP stays painless:

```
Jordan's gameplay customizations   <- the only commit that is "mine"
<Release-X.Y.Z>                    <- a clean upstream Vox Populi release
```

Everything personal lives in **one commit** on top of a clean upstream release, so a
`git merge`/`cherry-pick` of a newer VP can only ever conflict inside the ~11 hand-edited files
listed below (plus a self-contained `(2) Vox Populi/.../Jordan/` folder of brand-new files +
two `New Lua/Jordan*.lua` scripts, which are additions and never conflict) — never the other
~1,800.

Currently based on: **Release-5.2.7** (the latest *stable* VP release; previously tracked the
5.3.x development line but moved to stable on 2026-06-26).

## The customizations

### Community Patch
- **CoreGameOptionChanges.sql** — natural-wonder tile-yield rework. **Only Petra** is made
  **non-unique** (`MaxGlobalInstances` / `MaxPlayerInstances = -1`) so any civ can build it
  unlimited times; it becomes a regular building that keeps the wonder art/splash/desert yields,
  and was confirmed crash-safe with many copies. Pyramid / Notre Dame / Temple of Artemis are
  left as **normal one-per-world VP wonders** — duplicating *those* trips a divide-by-zero in the
  clean (un-rebuildable) DLL, so they stay capped at one in the world. The bonuses we wanted for
  every civ are instead baked onto `BUILDING_PALACE` (see BuildingChanges2). ⚠️ Never
  IGE-duplicate a real world wonder (Stonehenge, Pyramid, etc.) — it crashes.
- **Defines/CoreDefineChanges.sql** — city work radius `3 → 5` (plus added buy `5` /
  acquire `8` plot distances); AI gold reserve `150 → 50`; marriage great-person points
  `0 → 15`; minimum distance between cities `MIN_CITY_RANGE 3 → 5` (the fallback; the *effective*
  value is `MinDistanceCities` in WorldChanges, also 5); **unit stacking `PLOT_UNIT_LIMIT 1 → 3`
  and `CITY_UNIT_LIMIT 1 → 3`** (3 units per tile, including inside cities; replaces the
  standalone "3 Units per Tile" mod). Works with VP's `GLOBAL_STACKING_RULES` already on.
- **NewCustomModOptions.xml** — option toggles: balanced city-state traits & personalities,
  tile stacking rules, passable forts, city forest bonus (100%), grateful settlers,
  quick routes, subs invisible under ice, separate Great-Person counters, precise movement
  display, hovering units heal over land only, land-units adjacent blockade, alternate
  Assyria trait, era restriction. (The last three were renamed with a `BALANCE_` prefix in
  5.3.3 — see notes.)

### Vox Populi
- **CommunityOptions.sql** — barbarians heal faster (`1 → 2`).
- **BuildingChanges2.sql** — wonder rebalance: Pyramid +30% worker speed / +5 culture / **2 free
  Workers** (was 1 Settler), Petra desert food+production, Temple of Artemis +5 culture, Notre
  Dame happiness (`UnmoddedHappiness` **150 → 10**), Roman Forum +5 league votes. The three
  **Extra Palace Bonuses** — Pyramid's **+30% worker speed**, Temple of Artemis's **+10% Food in
  all cities**, and Notre Dame's old **+150 flat happiness** — used to be baked directly onto
  `BUILDING_PALACE` right here, but are now a **toggleable game-setup option** (carried by a hidden
  `BUILDING_JORDAN_PALACE_BONUS` granted at runtime; see *Game-setup options* below). The palace
  block was removed from this file; Notre Dame itself still gives `UnmoddedHappiness = 10`. Plus
  **less-damaged captured cities** (replaces the standalone
  "War - Less Damaged Captured Cities" mod): `ConquestProb = 80` on ~40 infrastructure
  buildings so they more often survive a city capture. (That mod also set
  `CITY_CAPTURE_POPULATION_PERCENT = 75`, but VP already defaults to 75, so it was a no-op.)
  Also **submarines ignore borders** (replaces the standalone "Submarines Ignore Borders"
  mod): grants VP's existing `PROMOTION_RIVAL_TERRITORY` free to `UNIT_SUBMARINE` and
  `UNIT_NUCLEAR_SUBMARINE` so they can enter rival territory without Open Borders. Also
  fixed a pre-existing stray-comma SQL error in the Roman Forum `UPDATE` (`ExtraLeagueVotes`).
- **Civilizations/Rome.sql** — Capital building bonus bumped: `CapitalBuildingModifier`
  **15 → 25** (+25% Production toward buildings already present in the Capital). On 5.2.7 Rome
  still has the classic capital-buildings-cheaper trait, so this is a simple value bump on the
  existing line. (On the 5.3.x dev line this trait was redesigned and the bonus had to be
  re-added as a separate `UPDATE` — not needed on stable 5.2.7.)
- **CustomModOptionChanges.sql** — building investments disabled.
- **GameSpeedChanges.sql** — research rate slowed across all game speeds (`ResearchPercent`:
  Quick `500`, Standard `1500`, Epic `2000`, Marathon `2500`); replaces the standalone
  "Slower Research +300%" mod.
- **WorldChanges.sql** — min distance between cities `3 → 5` (`MinDistanceCities`, the effective
  city-founding spacing), city-states `2 → 3`. Plus
  **Trading Posts (Villages) restricted to flat land** (`IMPROVEMENT_TRADING_POST.RequiresFlatlands = 1`)
  so the AI stops spamming them on hills; replaces the standalone "Global - Trading Posts Flat
  Land" mod. That mod also disabled Forts — intentionally **not** ported, since it would
  conflict with the `GLOBAL_PASSABLE_FORTS` option enabled above.
- **WorldMap/Features/FeatureSweeps.sql** — natural-wonder base yields rebalanced.
- **WorldMap/Features/NaturalWonderChanges.sql** — natural-wonder per-era yields, plus
  +5 in-border happiness and +1000 first-finder gold.

## Game-setup options (toggleable)

Three custom checkboxes now appear on the **Advanced Setup** screen, each with a mouse-over
tooltip. They are defined in `(2) Vox Populi/Database Changes/Jordan/JordanGameOptions.xml`
(rows in the `GameOptions` table + their `Language_en_US` label/help text) and applied at runtime
by `(2) Vox Populi/Core Files/New Lua/JordanGameOptions.lua` (registered as an `InGameUIAddin`).
EUI does **not** override the setup screen, so the stock `AdvancedSetup.lua` renders them
automatically from `GameOptions{Visible=1}` and wires each `Help` string as the tooltip. All
three default **ON** (i.e. preserve the behaviour these baked-in mods gave before).

- **Extra Palace Bonuses** (`GAMEOPTION_EXTRA_PALACE_BONUSES`) — grants every **major** civ's
  capital a hidden carrier building, `BUILDING_JORDAN_PALACE_BONUS` ("Capital Bonuses"; defined in
  `Jordan/JordanPalaceBonus.xml`) worth **+30% Worker build speed**, **+150 Happiness** and
  **+10% Food in all cities**. Granted via `City:SetNumRealBuilding` on `GameEvents.PlayerDoTurn`
  (capitals don't exist at game-init, so per-turn also covers turn-1 founding, loaded saves and
  capital relocation; the `GetNumRealBuilding` guard makes it a no-op once granted). `NeverCapture`
  destroys it on capture so the bonus never leaks to a conqueror. Untick = a standard VP Palace.
  *This is why the old `BUILDING_PALACE` block was removed from `BuildingChanges2.sql`* — a static
  SQL edit to the Palace can't be switched off per game; a granted building can.
- **Capture Great People** (`GAMEOPTION_CAPTURE_GREAT_PEOPLE`) — bakes in the *Capture Great People*
  mod as a toggle. The mod's static `Units.Capture` column can't be turned off per game, so instead
  this uses the DLL's `GameEvents.UnitCaptureType` value hook: when ticked, a defeated **civilian**
  Great Person (Writer / Artist / Musician / Scientist / Merchant / Engineer / Diplomat, plus
  Venice's Merchant of Venice → a plain Merchant) is captured as that unit instead of being killed;
  when unticked, the hook returns nothing and the unit dies as in stock VP. Requires CP
  CustomModOption **`EVENTS_UNIT_CAPTURE = 1`** (flipped on in
  `(1) Community Patch/Database Changes/NewCustomModOptions.xml`). Great Generals/Admirals are
  never capturable (deliberately excluded, matching the original mod).
- **No Futuristic Units** (`GAMEOPTION_NO_FUTURISTIC_UNITS`) — bakes in the *No Futuristic Units*
  mod as a toggle. Rather than deleting the units from the database (irreversible), it vetoes
  training `UNIT_MECH` and `UNIT_XCOM_SQUAD` for the player **and** the AI via
  `GameEvents.CityCanTrain` when ticked. (VP has no Giant Death Robot, so those two are the set.)

## Baked-in mods (always on, no toggle)

- **Forum of Rome** — `(2) Vox Populi/Database Changes/Jordan/JordanForumOfRome.xml` (the Walid
  mod, with its Building / RomanStatue / IconAtlas / font-icon / Text XML merged into one file).
  A Medieval **World Wonder** (`BUILDING_FORUM`, Cost 250, prereq `TECH_CONSTRUCTION`, one per world)
  giving **1 free Social Policy**, a **free Market** + **+1 Trade Route** in its city, +3 Happiness,
  +4 Culture, +5 Gold, and **3 "Roman Statues"** luxury (`RESOURCE_ROMANSTATUE`). Art is in
  `Assets/Jordan/`. ⚠️ It is a true World Wonder — **never IGE-duplicate it** (wonder-dup crash).
  **Integration choice:** Roman Statues is made **building-provided only** (the mod's natural
  map-spawn fields were dropped) so it doesn't perturb VP's tuned resource distribution — flag for
  playtest if you'd rather it spawn on the map.
- **Reforestation** — `Database Changes/Jordan/JordanReforestation.sql` +
  `Jordan/JordanReforestationText.xml` + `Core Files/New Lua/JordanReforestation.lua` (the
  FramedArchitecture mod, copied verbatim). Once **Fertilizer** is researched, Workers gain a
  **Plant Forest** build on Plains/Grassland/Tundra/Snow and Marsh, with a small chance of a forest
  resource appearing. Art is in `Assets/Jordan/`. (`TECH_FERTILIZER` exists in VP; no collisions.)

## Known issues / to revisit

Flagged during a review of the customization commit. None of these crash the game, but several
don't match the original framing and are worth a look on the next pass:

1. **Natural-wonder yields are defined in two places — the CP copy is dead code.** The
   `Feature_YieldChanges` block in `CoreGameOptionChanges.sql` (Community Patch) is overridden:
   `(2) Vox Populi`'s `FeatureSweeps.sql` loads later, does `DELETE FROM Feature_YieldChanges`
   (whole table) and re-inserts, so it always wins. The values happen to match today, so there's
   no visible bug — but edits to the CP copy silently do nothing. Treat `FeatureSweeps.sql` as
   the single source of truth and consider deleting the NW block from `CoreGameOptionChanges.sql`.
2. **`MaxGlobalInstances = -1` strips World-Wonder status from Petra.** As an unlimited regular
   building it no longer counts toward "+X per World Wonder" effects, wonder tourism, or AI
   wonder-competition logic. Accepted trade-off for making Petra unlimited-buildable. (Pyramid /
   Notre Dame / Temple of Artemis remain true world wonders and are unaffected.)
3. **Min city distance now aligned at 5** (was a 4-vs-6 mismatch). `WorldChanges.sql`
   `MinDistanceCities = 5` is the effective city-founding spacing; `CoreDefineChanges.sql`
   `MIN_CITY_RANGE = 5` is the (never-triggered) fallback, kept in sync to avoid confusion.
4. **Research slowdown is ~15×, not "+300%".** Standard `100 → 1500` ≈ +1400%. Intended (slow
   tech / fast everything-else feel), but the "+300%" framing carried over from the old mod name
   is inaccurate — only `ResearchPercent` is scaled; production, XP and golden ages stay normal.

**Reviewed and confirmed intentional (not bugs):**
- **Petra is buildable in every city, unlimited** (`MaxGlobalInstances`/`MaxPlayerInstances = -1`,
  no `CapitalOnly`) — deliberate; civs may build it freely.
- **The +150 flat happiness lives on `BUILDING_PALACE`** (every capital), deliberately — it was
  moved off Notre Dame (which now gives `UnmoddedHappiness = 10`). Gives every civ a large
  capital happiness cushion.

## Updating to a newer Vox Populi release

```bash
git fetch upstream                                   # LoneGazebo/Community-Patch-DLL
git checkout -B vp-<new> Release-<new>               # clean new release
git cherry-pick jordan-customizations                # replay tweaks onto it
# resolve any conflicts (only possible in the files above), then:
git branch -f jordan-customizations HEAD
git push -f origin jordan-customizations
```

Resolve conflicts **per value**: keep your number on a line you changed, take upstream's on a
line you didn't. If upstream redesigned a mechanic, your tweak there may no longer apply
(see Rome below — its trait was redesigned in 5.3.3 and the bonus had to be re-expressed).

## Carry-forward notes (as of 5.3.3)

- **Rome trait** — 5.3.3 redesigned the ability (the old `CapitalBuildingModifier` was
  dropped in favour of yield-per-connected-city). The +25% capital-building production has
  been **re-added on top** via `CapitalBuildingModifier`, which the engine still applies, so
  Rome now gets both. NOTE: the in-game trait tooltip won't *mention* the +25% (it still
  describes only the new trade ability) — cosmetic only.
- **Option toggles renamed/removed in 5.3.3** — 8 of the toggles left `NewCustomModOptions.xml`.
  Resolved as follows:
  - **Renamed (`BALANCE_` prefix) and restored to ON:** `ADJACENT_BLOCKADE →
    BALANCE_LAND_UNITS_ADJACENT_BLOCKADE`, `ALTERNATE_ASSYRIA_TRAIT →
    BALANCE_ALTERNATE_ASSYRIA_TRAIT`, `ERA_RESTRICTION → BALANCE_ERA_RESTRICTION`.
  - **Survives as on/off only:** grateful settlers (ON) — its percentage and multipliers are
    now hard-coded in the DLL, so `GLOBAL_GRATEFUL_SETTLERS_PERCENT=100` is no longer settable.
  - **Removed as options entirely (no DLL flag):** `SHIPS_FIRE_IN_CITIES_IMPROVEMENTS` and
    `PROMOTIONS_GG_FROM_BARBARIANS` (you had these on); `PROMOTIONS_CROSS_MOUNTAINS` and
    `PROMOTIONS_CROSS_OCEANS` (you had these off anyway).

## Deploying (Linux / Steam Proton)

VP must first be installed into the Civ 5 Proton prefix. Then sync the two mod folders into:

```
~/.steam/steam/steamapps/compatdata/8930/pfx/drive_c/users/steamuser/Documents/My Games/Sid Meier's Civilization 5/MODS/
```

Copy `(1) Community Patch` and `(2) Vox Populi` from a clone of this branch into `MODS/`.
Use upstream's prebuilt `CvGameCore_Expansion2.dll` (do not track a custom DLL).

### Adding new files / regenerating the `.modinfo`

New mod content (the `Jordan/` folder, the `New Lua/Jordan*.lua` scripts, and the `Assets/Jordan/`
art) is registered in **`Vox Populi.civ5proj`** — the `.modinfo` is *generated* from it by
`scripts/generate_modinfo.py`, which lists every file (with md5 + VFS-import flag), the
`OnModActivated` `UpdateDatabase` order, and the `InGameUIAddin` entry points. After editing the
`.civ5proj`, regenerate with `python3 scripts/generate_modinfo.py "(2) Vox Populi"`.

> ⚠️ **Linux/Proton caveat:** the upstream `generate_modinfo.py` resolves file paths with Windows
> backslashes, so on **Linux** its existence check fails and it silently drops *every* file from the
> `<Files>` list (you'll see ~1,300 "File not found" warnings and an empty manifest). The script
> itself is left upstream-clean; to regenerate on Linux, run a copy with the one-line fix
> `file_path = Path(file_info['path'].replace('\\', '/'))` (works on Windows too), or just run the
> stock script on Windows. The **generated `.modinfo` is identical either way** — all paths are
> normalised to forward slashes, exactly what Civ 5 (under Proton) reads.

**Per-deploy refresh:** bump the changed mod's deployed `.modinfo` `version="…"` and rename the file
to match so the game reprocesses it (leave `MinCompatibleSaveVersion`; don't delete
`Civ5ModsDatabase.db`). The fork's own `.modinfo` keeps the upstream version number.
