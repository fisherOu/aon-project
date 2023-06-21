// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {IWorld} from "solecs/interfaces/IWorld.sol";
import {TreasureConfigComponent, ID as TreasureConfigComponentID, TreasureConfig, PropertyConfig} from "components/TreasureConfigComponent.sol";
// import {MoveConfigComponent, ID as MoveConfigComponentID, MoveConfig} from "components/MoveConfigComponent.sol";
// import {VisionConfigComponent, ID as VisionConfigComponentID, VisionConfig} from "components/VisionConfigComponent.sol";
// import {TerrainComponent, ID as TerrainComponentID} from "components/TerrainComponent.sol";
// import {ResourceDistributionComponent, ID as ResourceDistributionComponentID} from "components/ResourceDistributionComponent.sol";
// import {SingletonID} from "solecs/SingletonID.sol";

library TreasureConfigInitializer {
    function init(IWorld world) internal {
        TreasureConfigComponent treasureConfig = TreasureConfigComponent(
            world.getComponent(TreasureConfigComponentID)
        );
        // ObstructionComponent obstruction = ObstructionComponent(world.getComponent(ObstructionComponentID));
        // EncounterTriggerComponent encounterTrigger = EncounterTriggerComponent(
        //   world.getComponent(EncounterTriggerComponentID)
        // );

        // // Alias these to make it easier to draw the terrain treasure
        // TerrainType O = TerrainType.None;
        // TerrainType T = TerrainType.TallGrass;
        // TerrainType B = TerrainType.Boulder;
        uint256[7][6] memory treasureTypes = [
            [0, 1, 1, 2001, 1001, 3001],
            [1, 1, 1, 2002, 1002, 3002],
            [2, 1, 1, 2003, 1003, 0],
            [3, 1, 0, 0, 1501, 0],
            [4, 1, 0, 0, 1502, 0],
            [5, 1, 0, 0, 1503, 3003],
            [6, 1, 0, 0, 1504, 0]
        ];
        uint32 treasureHeight = uint32(treasureTypes.length);
        // uint32 width = uint32(42);
        bytes memory types = new bytes();

        for (uint32 x = 0; x < treasureHeight; x++) {
            types = abi.encodePacked(types,
                bytes8(uint64(treasureTypes[x][0])),
                bytes1(uint8(treasureTypes[x][1])),
                bytes1(uint8(treasureTypes[x][2])),
                bytes8(uint64(treasureTypes[x][3])),
                bytes8(uint64(treasureTypes[x][4])),
                bytes8(uint64(treasureTypes[x][5]))
            );
        }

        uint256[13][11] memory treasureProperties = [
            [1001, 1, 1, 10, 20, 1, 10, 20, 1, 30, 0],
            [1002, 1, 0, 10, 20, 1, 2, 20, 1, 0, 0],
            [1003, 1, 3, 10, 20, 1, 35, 20, 1, 0, 0],
            [1501, 0, 4, 10, 20, 1, 50, 20, 1, 0, 0],
            [1502, 0, 5, 10, 20, 1, 2, 20, 1, 30, 0],
            [1503, 0, 6, 10, 20, 1, 3, 20, 1, 0, 0],
            [1504, 0, 7, 10, 20, 1, 5, 20, 1, 30, 0],
            [2001, 2, 1, 10, 20, 1, 10, 20, 1, 30, 0],
            [2002, 2, 0, 10, 20, 1, 2, 20, 1, 0, 0],
            [2003, 2, 8, 10, 20, 1, 5, 20, 1, 0, 0],
            [3001, 3, 1, 10, 20, 1, 10, 20, 1, 30, 0],
            [3002, 3, 0, 10, 20, 1, 2, 20, 1, 0, 0],
            [3003, 3, 9, 10, 20, 1, 2, 20, 1, 0, 0]
        ];

        uint32 height = uint32(treasureProperties.length);
        // uint32 width = uint32(42);
        bytes memory properties = new bytes();

        for (uint32 y = 0; y < height; y++) {
            properties = abi.encodePacked(properties,
                bytes8(uint64(treasureProperties[y][0])),
                bytes1(uint8(treasureProperties[y][1])),
                bytes1(uint8(treasureProperties[y][2])),
                bytes4(uint32(treasureProperties[y][3])),
                bytes4(uint32(treasureProperties[y][4])),
                bytes4(uint32(treasureProperties[y][5])),
                bytes4(uint32(treasureProperties[y][6])),
                bytes4(uint32(treasureProperties[y][7])),
                bytes4(uint32(treasureProperties[y][8])),
                bytes4(uint32(treasureProperties[y][9])),
                bytes4(uint32(treasureProperties[y][10]))
            );
        }

        treasureConfig.set(TreasureConfig({ energyMax: 200, energyMin: 50, treasureTypes: types, properties: properties }));
        // treasureConfig.set(
        //     TreasureConfig({
        //         resourceDifficulty: 5,
        //         treasureDifficulty: 3,
        //         gameOriginX: 50,
        //         gameOriginY: 100,
        //         gameRadiusX: 50,
        //         gameRadiusY: 100,
        //         decimals: 1
        //     })
        // );
        // moveConfig.set(
        //     MoveConfig({
        //         initPoints: 5,
        //         increaseCooldown: 12 * 60 * 60 * 1000,
        //         maxPoints: 10,
        //         maxDistance: 20
        //     })
        // );
        // visionConfig.set(
        //     VisionConfig({remainTime: 30 * 1000, maxDistance: 30})
        // );
    }
}
