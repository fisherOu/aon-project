// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {IWorld} from "solecs/interfaces/IWorld.sol";
import {MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig} from "components/MapConfigv2Component.sol";
import {MoveConfigComponent, ID as MoveConfigComponentID, MoveConfig} from "components/MoveConfigComponent.sol";
import {VisionConfigComponent, ID as VisionConfigComponentID, VisionConfig} from "components/VisionConfigComponent.sol";
import {TerrainComponent, ID as TerrainComponentID} from "components/TerrainComponent.sol";
import {ResourceDistributionComponent, ID as ResourceDistributionComponentID} from "components/ResourceDistributionComponent.sol";
import {TreasureDistributionComponent, ID as TreasureDistributionComponentID} from "components/TreasureDistributionComponent.sol";
import {SingletonID} from "solecs/SingletonID.sol";

library MapConfigv2Initializer {
    function init(IWorld world) internal {
        MapConfigv2Component mapConfig = MapConfigv2Component(
            world.getComponent(MapConfigv2ComponentID)
        );
        MoveConfigComponent moveConfig = MoveConfigComponent(
            world.getComponent(MoveConfigComponentID)
        );
        VisionConfigComponent visionConfig = VisionConfigComponent(
            world.getComponent(VisionConfigComponentID)
        );
        TerrainComponent terrain = TerrainComponent(
            world.getComponent(TerrainComponentID)
        );
        ResourceDistributionComponent resourceDistribution = ResourceDistributionComponent(
            world.getComponent(ResourceDistributionComponentID)
        );
        TreasureDistributionComponent treasureDistribution = TreasureDistributionComponent(
            world.getComponent(TreasureDistributionComponentID)
        );
        terrain.set(SingletonID, 11111);
        resourceDistribution.set(SingletonID, 22222);
        treasureDistribution.set(SingletonID, 33333);
        // ObstructionComponent obstruction = ObstructionComponent(world.getComponent(ObstructionComponentID));
        // EncounterTriggerComponent encounterTrigger = EncounterTriggerComponent(
        //   world.getComponent(EncounterTriggerComponentID)
        // );

        // // Alias these to make it easier to draw the terrain map
        // TerrainType O = TerrainType.None;
        // TerrainType T = TerrainType.TallGrass;
        // TerrainType B = TerrainType.Boulder;

        // TerrainType[20][20] memory map = [
        //   [O, O, O, O, O, O, T, O, O, O, O, O, O, O, O, O, O, O, O, O],
        //   [O, O, T, O, O, O, O, O, T, O, O, O, O, B, O, O, O, O, O, O],
        //   [O, T, T, T, T, O, O, O, O, O, O, O, O, O, O, T, T, O, O, O],
        //   [O, O, T, T, T, T, O, O, O, O, B, O, O, O, O, O, T, O, O, O],
        //   [O, O, O, O, T, T, O, O, O, O, O, O, O, O, O, O, O, T, O, O],
        //   [O, O, O, B, B, O, O, O, O, O, O, O, O, O, O, O, O, O, O, O],
        //   [O, T, O, O, O, B, B, O, O, O, O, T, O, O, O, O, O, B, O, O],
        //   [O, O, T, T, O, O, O, O, O, T, O, B, O, O, T, O, B, O, O, O],
        //   [O, O, T, O, O, O, O, T, T, T, O, B, B, O, O, O, O, O, O, O],
        //   [O, O, O, O, O, O, O, T, T, T, O, B, T, O, T, T, O, O, O, O],
        //   [O, B, O, O, O, B, O, O, T, T, O, B, O, O, T, T, O, O, O, O],
        //   [O, O, B, O, O, O, T, O, T, T, O, O, B, T, T, T, O, O, O, O],
        //   [O, O, B, B, O, O, O, O, T, O, O, O, B, O, T, O, O, O, O, O],
        //   [O, O, O, B, B, O, O, O, O, O, O, O, O, B, O, T, O, O, O, O],
        //   [O, O, O, O, B, O, O, O, O, O, O, O, O, O, O, O, O, O, O, O],
        //   [O, O, O, O, O, O, O, O, O, O, B, B, O, O, T, O, O, O, O, O],
        //   [O, O, O, O, T, O, O, O, T, B, O, O, O, T, T, O, B, O, O, O],
        //   [O, O, O, T, O, T, T, T, O, O, O, O, O, T, O, O, O, O, O, O],
        //   [O, O, O, T, T, T, T, O, O, O, O, T, O, O, O, T, O, O, O, O],
        //   [O, O, O, O, O, T, O, O, O, O, O, O, O, O, O, O, O, O, O, O]
        // ];

        // uint32 height = uint32(map.length);
        // uint32 width = uint32(map[0].length);
        // bytes memory terrain = new bytes(width * height);

        // for (uint32 y = 0; y < height; y++) {
        //   for (uint32 x = 0; x < width; x++) {
        //     TerrainType terrainType = map[y][x];
        //     if (terrainType == TerrainType.None) continue;

        //     terrain[(y * width) + x] = bytes1(uint8(terrainType));

        //     if (terrainType == TerrainType.Boulder) {
        //       uint256 entity = world.getUniqueEntityId();
        //       position.set(entity, Coord(int32(x), int32(y)));
        //       obstruction.set(entity);
        //     } else if (terrainType == TerrainType.TallGrass) {
        //       uint256 entity = world.getUniqueEntityId();
        //       position.set(entity, Coord(int32(x), int32(y)));
        //       encounterTrigger.set(entity);
        //     }
        //   }
        // }

        mapConfig.set(
            MapConfig({
                resourceDifficulty: 5,
                treasureDifficulty: 7,
                gameOriginX: 50,
                gameOriginY: 100,
                gameRadiusX: 50,
                gameRadiusY: 100,
                decimals: 1
            })
        );
        moveConfig.set(
            MoveConfig({
                initPoints: 5,
                increaseCooldown: 1 * 60 * 60 * 1000,
                maxPoints: 10,
                maxDistance: 20
            })
        );
        visionConfig.set(
            VisionConfig({remainTime: 30 * 1000, maxDistance: 30})
        );
    }
}
