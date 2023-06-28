// SPDX-License-Identifier: MIT
// components: ["AttackChargeComponent", "AttackTimerComponent"]
pragma solidity >=0.8.0;
import {addressToEntity} from "solecs/utils.sol";
import {System, IWorld} from "solecs/System.sol";
import {getAddressById} from "solecs/utils.sol";
import {MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig} from "components/MapConfigv2Component.sol";
import {ResourceConfigComponent, ID as ResourceConfigComponentID, ResourceConfig} from "components/ResourceConfigComponent.sol";
import {ZKConfigComponent, ID as ZKConfigComponentID, ZKConfig} from "components/ZKConfigComponent.sol";
// import {SingletonID} from "solecs/SingletonID.sol";

import {AttackChargeComponent, ID as AttackChargeComponentID, AttackCharge} from "components/AttackChargeComponent.sol";
import {AttackTimerComponent, ID as AttackTimerComponentID, AttackTimer} from "components/AttackTimerComponent.sol";
// import {ResourceComponent, ID as ResourceComponentID, Resource} from "components/ResourceComponent.sol";
// import {PlayerComponent, ID as PlayerComponentID} from "components/PlayerComponent.sol";
import {HiddenPositionComponent, ID as HiddenPositionComponentID} from "components/HiddenPositionComponent.sol";
// import {WarshipComponent, ID as WarshipComponentID, Warship} from "components/WarshipComponent.sol";
// import {MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown} from "components/MoveCooldownComponent.sol";
import {IInitVerifier} from "libraries/InitVerifier.sol";

uint256 constant ID = uint256(keccak256("system.AttackCharge"));

struct AttackChargeInfo {
    uint256 coordHash;
    uint256 width;
    uint256 height;
    uint256 seed;
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
    uint256 direction;
}

contract AttackChargeSystem is System {
    constructor(
        IWorld _world,
        address _components
    ) System(_world, _components) {}

    function execute(bytes memory args) public returns (bytes memory) {
        AttackChargeInfo memory attackInfo = abi.decode(args, (AttackChargeInfo));
        return executeTyped(attackInfo);
    }

    function executeTyped(
        AttackChargeInfo memory attackInfo
    ) public returns (bytes memory) {
        ZKConfig memory zkConfig = ZKConfigComponent(
            getAddressById(components, ZKConfigComponentID)
        ).getValue();
        if (zkConfig.open) {
            uint256[4] memory input = [attackInfo.coordHash, attackInfo.seed, attackInfo.width, attackInfo.height];
            require(
                IInitVerifier(zkConfig.initVerifyAddress).verifyProof(
                    attackInfo.a,
                    attackInfo.b,
                    attackInfo.c,
                    input
                ),
                "Failed attack proof check"
            );
        }
        uint256 entityId = addressToEntity(msg.sender);
        require(attackInfo.coordHash == HiddenPositionComponent(getAddressById(components, HiddenPositionComponentID)).getValue(entityId), "not standing on required tile");

        // Constrain position to map size, wrapping around if necessary
        MapConfig memory mapConfig = MapConfigv2Component(
            getAddressById(components, MapConfigv2ComponentID)
        ).getValue();
        require(
            attackInfo.width <= mapConfig.gameRadiusX &&
                attackInfo.height <= mapConfig.gameRadiusY,
            "radius over limit"
        );
        AttackTimerComponent attackTimer = AttackTimerComponent(
            getAddressById(components, AttackTimerComponentID)
        );
        if (attackTimer.has(entityId)) {
            AttackTimer memory timer = attackTimer.getValue(entityId);
            require((timer.cooldownTimeout == 0 || block.timestamp > timer.cooldownTimeout) && (timer.chargingTimeout == 0 || block.timestamp > timer.chargingTimeout), "already attacking");
        }
        AttackChargeComponent attackCharge = AttackChargeComponent(
            getAddressById(components, AttackChargeComponentID)
        );
        require(!attackCharge.has(entityId), "already charging");
        attackCharge.set(entityId, AttackCharge({coord_hash: attackInfo.coordHash, direction: attackInfo.direction}));
        attackTimer.set(entityId, AttackTimer({cooldownTimeout: uint64(block.timestamp + 10), attackTimeout: uint64(block.timestamp + 10)}));
    }
}
