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
import {HPComponent, ID as HPComponentID} from "components/HPComponent.sol";
// import {WarshipComponent, ID as WarshipComponentID, Warship} from "components/WarshipComponent.sol";
// import {MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown} from "components/MoveCooldownComponent.sol";
import {IInitVerifier} from "libraries/InitVerifier.sol";

uint256 constant ID = uint256(keccak256("system.AttackFinish"));

struct AttackFinishInfo {
    uint256[50] input;
    uint256[2] a;
    uint256[2][2] b;
    uint256[2] c;
}

contract AttackFinishSystem is System {
    constructor(
        IWorld _world,
        address _components
    ) System(_world, _components) {}

    function execute(bytes memory args) public returns (bytes memory) {
        AttackFinishInfo memory attackInfo = abi.decode(args, (AttackFinishInfo));
        return executeTyped(attackInfo);
    }

    function executeTyped(
        AttackFinishInfo memory attackInfo
    ) public returns (bytes memory) {
        ZKConfig memory zkConfig = ZKConfigComponent(
            getAddressById(components, ZKConfigComponentID)
        ).getValue();
        if (zkConfig.open) {
            require(
                IInitVerifier(zkConfig.initVerifyAddress).verifyProof(
                    attackInfo.a,
                    attackInfo.b,
                    attackInfo.c,
                    attackInfo.input
                ),
                "Failed attack proof check"
            );
        }
        uint256 entityId = addressToEntity(msg.sender);
        // require(attackInfo.coordHash == HiddenPositionComponent(getAddressById(components, HiddenPositionComponentID)).getValue(entityId), "not standing on required tile");

        // Constrain position to map size, wrapping around if necessary
        MapConfig memory mapConfig = MapConfigv2Component(
            getAddressById(components, MapConfigv2ComponentID)
        ).getValue();
        AttackTimerComponent attackTimer = AttackTimerComponent(
            getAddressById(components, AttackTimerComponentID)
        );
        require(attackTimer.has(entityId), "not charging");
        require(attackTimer.getValue(entityId).chargingTimeout <= block.timestamp, "charging not finished");
        // AttackTimer memory timer = attackTimer.getValue(entityId);
        // require((timer.cooldownTimeout == 0 || block.timestamp > timer.cooldownTimeout) && (timer.chargingTimeout == 0 || block.timestamp > timer.chargingTimeout), "already attacking");
        AttackChargeComponent attackCharge = AttackChargeComponent(
            getAddressById(components, AttackChargeComponentID)
        );
        HiddenPositionComponent position = HiddenPositionComponent(
            getAddressById(components, HiddenPositionComponentID)
        );
        HPComponent hp = HPComponent(
            getAddressById(components, HPComponentID)
        );
        require(attackCharge.has(entityId) && attackCharge.getValue(entityId).coord_hash == attackInfo.input[0], "attack not from begining");
        for (uint i=0; i<10; i++) {
            if (attackInfo.input[30+i] <= mapConfig.gameRadiusX &&
                    attackInfo.input[40+i] <= mapConfig.gameRadiusY) {
                if (i > 0) {
                    uint256[] memory entities = position.getEntitiesWithValue(attackInfo.input[i]);
                    if (entities.length == 0) {
                        continue;
                    }
                    uint256 hitPlayer = entities[0];
                    uint256 hitHP = hp.getValue(hitPlayer);
                    if (hp.has(hitPlayer) && hitHP > 0) {
                        hp.set(hitPlayer, hitHP - 1);
                        if (hitHP - 1 == 0) {
                            position.set(hitPlayer, 0);
                        }
                        break;
                    }
                }
            }
        }
        attackCharge.remove(entityId);
        // attackTimer.set(entityId, AttackTimer({cooldownTimeout: }));
    }
}
