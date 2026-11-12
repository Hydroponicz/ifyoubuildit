# ifyoubuildit: guide for Claude

Solo-developed medieval voxel sandbox / village sim, built in Godot.

## Pillars

1. **Solo project.** One developer. Prefer simple, readable systems over clever ones. No multiplayer.
2. **Smooth procedural terrain.** SDF voxels meshed with Transvoxel (godot_voxel), not blocky cubes.
3. **Valheim-style building.** Pieces (walls, beams, floors, roofs) snap together, with structural support/stability. *(later)*
4. **Villagers with needs** and a **shared job board**. Classic game AI only: FSMs, utility scoring, behavior trees, GOAP-style planning, A*/navmesh. No ML/LLM agents. *(later)*
5. **Production chains** (lumberyard, sawmill, etc.) where **layout affects speed**: walking distance, storage placement, road access. *(later)*
6. **Three cameras:** first person, third person, and a bird's-eye command/blueprint camera.
7. **Combat much later.** Keep every character's **brain** (decision-making) separate from its **body** (movement, physics, animation), so combat and AI can each plug into the same body later.

## Tech

- **Godot 4.7.2 (official build)**, GDScript with **static typing everywhere** (typed vars, params, returns; `:=` only where the type is obvious).
- **godot_voxel as a GDExtension** in `addons/zylann.voxel/`. Use the GDExtension docs, not the module docs. Differences that matter:
  - `FastNoise2` is **not** in GDExtension builds. `ZN_FastNoiseLite` **is** present, but it inherits `Resource`, not Godot's `Noise`, so it can't go into `VoxelGeneratorNoise2D.noise`. That property takes Godot's built-in `FastNoiseLite`, which is what we use. `ZN_FastNoiseLite` is for `VoxelGeneratorGraph` noise nodes, if we switch to a graph generator later.
  - Docs note `Noise2D` generation is a bit slower in the GDExtension edition. Fine for now; revisit with `VoxelGeneratorGraph` if generation becomes a bottleneck.
- Terrain: `VoxelTerrain` + `VoxelGeneratorNoise2D` (channel SDF) + `VoxelMesherTransvoxel`, `generate_collisions = true`. Terrain only builds around `VoxelViewer` nodes.

## Layout

- `scenes/`: `.tscn` scenes and shaders/materials that belong to them.
- `scripts/`: gameplay scripts. One small class per file, `class_name` when other code refers to it.
- `autoload/`: autoload singletons only. None in Milestone 1 (input actions are registered at runtime by `InputActions`).
- `docs/`: roadmap and design notes.

## Conventions

- Bodies never read input. Brains (`PlayerBrain`, later NPC brains) write intent (`move_intent`, `jump_intent`, `look()`) into a body (`HumanoidBody`).
- Physics layers: 1 = terrain/world, 2 = characters. Terrain raycasts use mask 1.
- Input actions are defined in `scripts/input_actions.gd` and only added if missing, so Project Settings → Input Map can override them.
- Wire nodes with typed `@export` references set in the scene, not hard-coded `get_node` paths.
- Keep scripts small. Split rather than grow past ~150 lines.
- Only work on the current milestone in `docs/ROADMAP.md`. Don't add building, NPCs, or combat early.
