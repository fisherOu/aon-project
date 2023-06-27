// SPDX-License-Identifier: MIT
// components: ["ResourcePositionComponent"]
pragma solidity >=0.8.0;
import {addressToEntity} from "solecs/utils.sol";
import {System, IWorld} from "solecs/System.sol";
import {getAddressById} from "solecs/utils.sol";
import {MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig} from "components/MapConfigv2Component.sol";
import {ResourceConfigComponent, ID as ResourceConfigComponentID, ResourceConfig} from "components/ResourceConfigComponent.sol";
import {ZKConfigComponent, ID as ZKConfigComponentID, ZKConfig} from "components/ZKConfigComponent.sol";
// import {SingletonID} from "solecs/SingletonID.sol";

import {ResourcePositionComponent, ID as ResourcePositionComponentID} from "components/ResourcePositionComponent.sol";
import {ResourceMiningComponent, ID as ResourceMiningComponentID, ResourceMining} from "components/ResourceMiningComponent.sol";
import {ResourceComponent, ID as ResourceComponentID, Resource} from "components/ResourceComponent.sol";
// import {PlayerComponent, ID as PlayerComponentID} from "components/PlayerComponent.sol";
import {HiddenPositionComponent, ID as HiddenPositionComponentID} from "components/HiddenPositionComponent.sol";
// import {WarshipComponent, ID as WarshipComponentID, Warship} from "components/WarshipComponent.sol";
// import {MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown} from "components/MoveCooldownComponent.sol";
import {IResourceVerifier} from "libraries/ResourceVerifier.sol";

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
    uint256 realHash;
    uint256 perlin;
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
            uint256[6] memory input = [attackInfo.coordHash, attackInfo.seed, attackInfo.resourceSeed, attackInfo.perlin, attackInfo.width, attackInfo.height];
            require(
                IResourceVerifier(zkConfig.resourceVerifyAddress).verifyProof(
                    attackInfo.a,
                    attackInfo.b,
                    attackInfo.c,
                    input
                ),
                "Failed resource proof check"
            );
        }
        uint256 entityId = addressToEntity(msg.sender);
        require(attackInfo.coordHash == HiddenPositionComponent(getAddressById(components, HiddenPositionComponentID)).getValue(entityId), "not standing on resource");

        // Constrain position to map size, wrapping around if necessary
        MapConfig memory mapConfig = MapConfigv2Component(
            getAddressById(components, MapConfigv2ComponentID)
        ).getValue();
        require(
            attackInfo.width <= mapConfig.gameRadiusX &&
                attackInfo.height <= mapConfig.gameRadiusY,
            "radius over limit"
        );
        require(
            // hash <= resourceDifficulty <= resourceDifficulty || resourceDifficulty < hash <= resourceDifficulty
            (attackInfo.coordHash <= mapConfig.resourceDifficulty &&
                mapConfig.resourceDifficulty <= mapConfig.resourceDifficulty) || (attackInfo.coordHash <= mapConfig.resourceDifficulty &&
                attackInfo.coordHash > mapConfig.resourceDifficulty),
            "no resource to dig"
        );
        ResourcePositionComponent resourcePosition = ResourcePositionComponent(
            getAddressById(components, ResourcePositionComponentID)
        );
        uint256[] memory resourceIds =  resourcePosition.getEntitiesWithValue(attackInfo.coordHash);
        uint256 resourceId = 0;
        if (resourceIds.length > 0) {
            resourceId = resourceIds[0];
        }
        if (resourceId == 0) {
            resourceId = world.getUniqueEntityId();
        }
        // ResourceComponent resource = ResourceComponent(
        //     getAddressById(components, ResourceComponentID)
        // );
        ResourceMiningComponent resourceMining = ResourceMiningComponent(
            getAddressById(components, ResourceMiningComponentID)
        );
        (uint256 remain, uint256 cache, uint256 difficulty) = getRemainAndCache(resourceId);
        require(remain == attackInfo.remain && cache == attackInfo.cache, "remain value invalid");
        require(attackInfo.powResult / 16 	** (64 - difficulty) == 0, "pow value invalid");
        resourceMining.set(resourceId, ResourceMining({remain: remain-1, cache: cache+1}));
    }

    function getRemainAndCache(uint256 resourceId) internal returns (uint256 remain, uint256 cache, uint256 difficulty) {
        ResourceComponent resource = ResourceComponent(
            getAddressById(components, ResourceComponentID)
        );
        ResourceMiningComponent resourceMining = ResourceMiningComponent(
            getAddressById(components, ResourceMiningComponentID)
        );
        remain = 0;
        cache = 0;
        difficulty = 0;
        if (resourceMining.has(resourceId)) {
            difficulty = resource.getValue(resourceId).difficuly;
            ResourceMining memory miningState = resourceMining.getValue(resourceId);
            remain = miningState.remain;
            cache = miningState.cache;
        }
        if (!resource.has(resourceId)) {
            ResourceConfig memory resourceConfig = ResourceConfigComponent(
                getAddressById(components, ResourceConfigComponentID)
            ).getValue();
            uint256 value = attackInfo.perlin % (resourceConfig.valueMax - resourceConfig.valueMin) + resourceConfig.valueMin;
            difficulty = uint8(attackInfo.perlin / (resourceConfig.valueMax - resourceConfig.valueMin)) % (resourceConfig.difficultMax - resourceConfig.difficultMin) + resourceConfig.difficultMin;
            resource.set(resourceId, Resource({value: value, difficulty: difficulty}));
            remain = value;
        }
        return (remain, cache, difficulty);
    }
}
