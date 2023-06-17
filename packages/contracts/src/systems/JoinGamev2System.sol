// SPDX-License-Identifier: MIT
// components: ["PlayerComponent", "HiddenPositionComponent", "WarshipComponent", "MoveCooldownComponent"]
pragma solidity >=0.8.0;
import {addressToEntity} from "solecs/utils.sol";
import {System, IWorld} from "solecs/System.sol";
import {getAddressById} from "solecs/utils.sol";
import {MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig} from "components/MapConfigv2Component.sol";
import {MoveConfigComponent, ID as MoveConfigComponentID, MoveConfig} from "components/MoveConfigComponent.sol";
import {ZkCheckComponent, ID as ZkCheckComponentID} from "components/ZkCheckComponent.sol";
import {SingletonID} from "solecs/SingletonID.sol";

import {PlayerComponent, ID as PlayerComponentID} from "components/PlayerComponent.sol";
import {HiddenPositionComponent, ID as HiddenPositionComponentID} from "components/HiddenPositionComponent.sol";
import {WarshipComponent, ID as WarshipComponentID, Warship} from "components/WarshipComponent.sol";
import {MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown} from "components/MoveCooldownComponent.sol";
// import {Verifier} from "libraries/Verifier.sol";

uint256 constant ID = uint256(keccak256("system.JoinGamev2"));

struct JoinInfo {
    uint256 coord_hash;
    uint256 perlin;
    uint256 radius;
    uint256 seed;
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
}

contract JoinGamev2System is System {
    constructor(
        IWorld _world,
        address _components
    ) System(_world, _components) {}

    function execute(bytes memory args) public returns (bytes memory) {
        JoinInfo memory joinInfo = abi.decode(args, (JoinInfo));
        return executeTyped(joinInfo);
    }

    function executeTyped(
        JoinInfo memory joinInfo
    ) public returns (bytes memory) {
        // ZkCheckComponent zkCheck = ZkCheckComponent(
        //     getAddressById(components, ZkCheckComponentID)
        // );
        // if (zkCheck.getValue(SingletonID)) {
        //     uint256[4] memory input = [joinInfo.coord_hash, joinInfo.perlin, joinInfo.radius, joinInfo.seed];
        //     require(
        //         Verifier.verifyInitProof(
        //             joinInfo.a,
        //             joinInfo.b,
        //             joinInfo.c,
        //             input
        //         ),
        //         "Failed init proof check"
        //     );
        // }
        uint256 entityId = addressToEntity(msg.sender);

        PlayerComponent player = PlayerComponent(
            getAddressById(components, PlayerComponentID)
        );
        require(!player.has(entityId), "already joined");

        // Constrain position to map size, wrapping around if necessary
        MapConfig memory mapConfig = MapConfigv2Component(
            getAddressById(components, MapConfigv2ComponentID)
        ).getValue();
        require(
            joinInfo.radius <= mapConfig.gameRadiusX &&
                joinInfo.radius <= mapConfig.gameRadiusY,
            "radius over limit"
        );
        MoveConfig memory moveConfig = MoveConfigComponent(
            getAddressById(components, MoveConfigComponentID)
        ).getValue();

        player.set(entityId);
        HiddenPositionComponent(
            getAddressById(components, HiddenPositionComponentID)
        ).set(entityId, joinInfo.coord_hash);
        // WarshipComponent
        // MoveCooldownComponent
        // uint256 warshipId = world.getUniqueEntityId();
        WarshipComponent(getAddressById(components, WarshipComponentID)).set(
            entityId,
            Warship("warship", uint64(block.timestamp))
        );
        MoveCooldownComponent(
            getAddressById(components, MoveCooldownComponentID)
        ).set(entityId, MoveCooldown(uint64(block.timestamp), moveConfig.initPoints));
    }
}
