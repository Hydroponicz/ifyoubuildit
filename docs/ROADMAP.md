# Roadmap

## Milestone 1: Walk around a smooth world *(current)*

- [x] `CLAUDE.md` with pillars, this roadmap
- [x] Main scene: `VoxelTerrain` + `VoxelGeneratorNoise2D` (built-in `FastNoiseLite`) + `VoxelMesherTransvoxel`, collisions, `VoxelViewer` on the player
- [x] Player `CharacterBody3D`: WASD, mouse look, jump, gravity (body/brain split)
- [x] One key (V) cycles first person → third person → bird's-eye (pan / zoom / rotate)
- [x] Folders: `scenes/`, `scripts/`, `autoload/`, `docs/`

Not in scope: building, NPCs, combat, saving.

## Milestone 2: Better ground *(next)*

- Seeded world settings (seed, scale) in one resource
- Terrain material: triplanar textures (grass/rock/dirt) instead of flat colors
- Possibly move to `VoxelGeneratorGraph` for biomes/flat village areas; `VoxelLodTerrain` if view distance needs to grow
- Save/load terrain edits (`VoxelStream`)

## Milestone 3: Piece-based building

- Build pieces as scenes with snap points
- Placement ghost from first/third person and from the bird's-eye blueprint camera
- Structural support: stability propagates from ground contact, weak pieces collapse

## Milestone 4: Villagers

- `HumanoidBody` reused for NPCs, each with its own brain (FSM/utility AI)
- Needs (hunger, rest, warmth) and a shared job board that villagers pull tasks from
- Navigation over voxel terrain

## Milestone 5: Production chains

- Lumberyard → sawmill → storage; work speed depends on layout (distances, roads, storage)
- Commands and blueprints from the bird's-eye camera

## Later

- Combat (new brains and actions on the same bodies)
