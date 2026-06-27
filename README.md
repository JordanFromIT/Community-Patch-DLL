> ## 🔱 Personal fork — Jordan's Vox Populi
>
> This is a **personal fork** of [LoneGazebo/Community-Patch-DLL](https://github.com/LoneGazebo/Community-Patch-DLL)
> (Vox Populi for Civilization V). The **`jordan-customizations`** branch is a clean upstream
> VP release plus **one commit** of personal balance tweaks, so pulling a newer VP is just a
> cherry-pick that can only conflict inside my own handful of files.
>
> **Currently based on:** Release-5.2.7 (latest stable VP).
>
> **What this fork changes** (full details in [`JORDAN-CUSTOMIZATIONS.md`](JORDAN-CUSTOMIZATIONS.md)):
>
> **New game-setup options** — checkboxes with mouse-over tooltips on the Advanced Setup screen
> (all default ON; untick to disable per game):
> - **Extra Palace Bonuses** — every capital gets +30% Worker build speed, +150 Happiness and
>   +10% Food (growth) in all cities; untick for a standard Palace
> - **Capture Great People** — defeated enemy civilian Great People are captured (like a Worker), not killed
> - **No Futuristic Units** — the Mech and XCOM Squad cannot be built or trained
>
> **Baked-in mods:**
> - **Forum of Rome** — a Medieval-era World Wonder (free Social Policy, free Market + extra Trade Route,
>   Happiness/Culture/Gold) that provides the "Roman Statues" luxury
> - **Reforestation** — Workers can plant Forests once Fertilizer is researched
>
> **Always-on balance tweaks:**
> - **Slower research** across all game speeds (`ResearchPercent` Quick 500 / Standard 1500 /
>   Epic 2000 / Marathon 2500) — slow tech, normal production and everything else
> - **3 units per tile**, including inside cities
> - **Bigger city work radius** (3 → 5) and **wider spacing** between cities (3 → 5) and city-states (2 → 3)
> - **Submarines may enter rival territory** (ignore borders — no Open Borders needed)
> - **Captured cities keep more buildings** (~80% survival on key infrastructure)
> - **Trading Posts/Villages restricted to flat land** (stops the AI spamming them on hills)
> - **Wonder rebalance** — Pyramid gives **2 free Workers** (was a Settler) plus worker/culture yields;
>   Notre Dame's flat Happiness trimmed (its old +150 now rides the Extra Palace Bonuses toggle);
>   Petra, Temple of Artemis and Roman Forum tweaks
> - **Natural-wonder rework** — rebalanced tile yields, **+5 in-border Happiness**, **+1000 first-finder Gold**
> - **Petra buildable in every city, unlimited**; **Rome** gets +25% Production toward buildings
>   already present in its Capital
> - **Barbarians heal faster**, the **AI keeps a smaller gold reserve** (150 → 50),
>   **marrying city-states grants Great-Person points** (0 → 15), and **building investments are disabled**
> - **Assorted option toggles** — balanced city-state traits, passable forts, +100% city forest growth,
>   grateful settlers, separate Great-Person counters, and more
>
> Exact per-file behaviour and caveats live in [`JORDAN-CUSTOMIZATIONS.md`](JORDAN-CUSTOMIZATIONS.md).
>
> Built and run on Linux (Steam pinned to the Windows build under Proton). Not affiliated with
> the Vox Populi team — please report VP bugs upstream, not here.
>
> ---

# Community-Patch-DLL

This is the repository for the Civ V SDK + Vox Populi Mod. 

## What is Vox Populi

Started in 2014, Vox Populi (formerly known as the "Community Balance Patch/Overhaul") is a collaborative effort to improve Civilization V's AI and gameplay. It consists of a collection of mods (see below) that are designed to work together seamlessly.

* The Community Patch (CP) is the base mod
	* Contains the gamecore DLL, which is based on C++ code linked against the official Civ V SDK
    * Contains bugfixes (also for multiplayer), performance improvements and many AI enhancements, but minimal gameplay changes
    * Can be used standalone and is the basis for many other mods
* Vox Populi
	* Expands and changes the core mechanics of the game, offering an entirely new Civilization V experience that feels and plays like an evolution of the series
	* Includes City-State Diplomacy by Gazebo, Civ 4 Diplomacy Features by Putmalk and More Luxuries by Barathor
* EUI (optional)
	* Enhanced User Interface

## Where can I learn more

Check out the [forum](https://forums.civfanatics.com/forums/community-patch-project.497/). 

## How can I play this

* You need the latest version of Civilization V (1.0.3.279) with all expansions and DLC.
* [This thread](https://forums.civfanatics.com/threads/community-patch-how-to-install.528034/) on CivFanatics contains a link to the latest release, along with installation instructions.
* You may also download the automatic installer for your desired version from the [Releases page](https://github.com/LoneGazebo/Community-Patch-DLL/releases).

## Development and debugging

See `DEVELOPMENT.md` file for more information.