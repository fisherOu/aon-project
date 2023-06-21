// SPDX-License-Identifier: MIT
// components: ["ResourcePositionComponent"]
pragma solidity >=0.8.0;
import {addressToEntity} from "solecs/utils.sol";
import {System, IWorld} from "solecs/System.sol";
import {getAddressById} from "solecs/utils.sol";
import {MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig} from "components/MapConfigv2Component.sol";
import {TreasureConfigComponent, ID as TreasureConfigComponentID, TreasureConfig, PropertyConfigRange, TreasureTypes} from "components/TreasureConfigComponent.sol";
import {ZkCheckComponent, ID as ZkCheckComponentID} from "components/ZkCheckComponent.sol";
import {SingletonID} from "solecs/SingletonID.sol";

import {ResourcePositionComponent, ID as ResourcePositionComponentID} from "components/ResourcePositionComponent.sol";
import {PlayerBelongingComponent, ID as PlayerBelongingComponentID} from "components/PlayerBelongingComponent.sol";
import {TreasureComponent, ID as TreasureComponentID, Treasure} from "components/TreasureComponent.sol";
// import {PlayerComponent, ID as PlayerComponentID} from "components/PlayerComponent.sol";
// import {HiddenPositionComponent, ID as HiddenPositionComponentID} from "components/HiddenPositionComponent.sol";
// import {WarshipComponent, ID as WarshipComponentID, Warship} from "components/WarshipComponent.sol";
// import {MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown} from "components/MoveCooldownComponent.sol";
// import {Verifier} from "libraries/Verifier.sol";

uint256 constant ID = uint256(keccak256("system.PickUpTreasure"));

struct PickUpInfo {
    uint256 coordHash;
    uint256 perlin;
    uint256 radius;
    uint256 seed;
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
    string treasureType;
    uint64 typeId;
    uint256 energy;
}

contract PickUpTreasureSystem is System {
    constructor(
        IWorld _world,
        address _components
    ) System(_world, _components) {}

    function execute(bytes memory args) public returns (bytes memory) {
        PickUpInfo memory pickUpInfo = abi.decode(args, (PickUpInfo));
        return executeTyped(pickUpInfo);
    }

    function executeTyped(
        PickUpInfo memory pickUpInfo
    ) public returns (bytes memory) {
        // ZkCheckComponent zkCheck = ZkCheckComponent(
        //     getAddressById(components, ZkCheckComponentID)
        // );
        // if (zkCheck.getValue(SingletonID)) {
        //     uint256[4] memory input = [pickUpInfo.coordHash, pickUpInfo.perlin, pickUpInfo.radius, pickUpInfo.seed];
        //     require(
        //         Verifier.verifyInitProof(
        //             pickUpInfo.a,
        //             pickUpInfo.b,
        //             pickUpInfo.c,
        //             input
        //         ),
        //         "Failed init proof check"
        //     );
        // }
        uint256 entityId = addressToEntity(msg.sender);

        // Constrain position to map size, wrapping around if necessary
        MapConfig memory mapConfig = MapConfigv2Component(
            getAddressById(components, MapConfigv2ComponentID)
        ).getValue();
        require(
            pickUpInfo.radius <= mapConfig.gameRadiusX &&
                pickUpInfo.radius <= mapConfig.gameRadiusY,
            "radius over limit"
        );
        ResourcePositionComponent resourcePosition = ResourcePositionComponent(
            getAddressById(components, ResourcePositionComponentID)
        );
        uint256[] memory treasureIds =  resourcePosition.getEntitiesWithValue(pickUpInfo.coordHash);
        uint256 treasureId = 0;
        if (treasureIds.length > 0) {
            treasureId = treasureIds[0];
        }
        if (treasureId == 0) {
            treasureId = world.getUniqueEntityId();
        }
        PlayerBelongingComponent playerBelonging = PlayerBelongingComponent(
            getAddressById(components, PlayerBelongingComponentID)
        );
        require(!playerBelonging.has(treasureId), "Already pickedUp");
        TreasureConfig memory moveConfig = TreasureConfigComponent(
            getAddressById(components, TreasureConfigComponentID)
        ).getValue();

        // generate treasure properties
        TreasureComponent(getAddressById(components, TreasureComponentID)).set(
            entityId,
            Treasure(pickUpInfo.energy, pickUpInfo.treasureType)
        );
        // MoveCooldownComponent(
        //     getAddressById(components, MoveCooldownComponentID)
        // ).set(entityId, MoveCooldown(uint64(block.timestamp), moveConfig.initPoints));
    }
}
