// SPDX-License-Identifier: MIT
// components: ["HiddenPositionComponent", "MoveCooldownComponent"]
pragma solidity >=0.8.0;
import { addressToEntity } from "solecs/utils.sol";
import { System, IWorld } from "solecs/System.sol";
import { getAddressById } from "solecs/utils.sol";
import { MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig } from "components/MapConfigv2Component.sol";
import { MoveConfigComponent, ID as MoveConfigComponentID, MoveConfig } from "components/MoveConfigComponent.sol";
import { ZkCheckComponent, ID as ZkCheckComponentID } from "components/ZkCheckComponent.sol";
import { SingletonID } from "solecs/SingletonID.sol";

import { PlayerComponent, ID as PlayerComponentID } from "components/PlayerComponent.sol";
import { HiddenPositionComponent, ID as HiddenPositionComponentID } from "components/HiddenPositionComponent.sol";
import { WarshipComponent, ID as WarshipComponentID, Warship } from "components/WarshipComponent.sol";
import { MoveCooldownComponent, ID as MoveCooldownComponentID, MoveCooldown } from "components/MoveCooldownComponent.sol";
import { Verifier } from "libraries/Verifier.sol";

uint256 constant ID = uint256(keccak256("system.Movev2"));

struct MoveInfo {
  uint256 coord_hash;
  uint256 perlin;
  uint256 radius;
  uint256 seed;
  uint256 old_hash;
  uint256 distance;
  uint256[2] a;
  uint256[2][2] b;
  uint256[2] c;
}

contract Movev2System is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory args) public returns (bytes memory) {
    MoveInfo memory moveInfo = abi.decode(args, (MoveInfo));
    return executeTyped(moveInfo);
  }

  function executeTyped(MoveInfo memory moveInfo) public returns (bytes memory) {
    ZkCheckComponent zkCheck = ZkCheckComponent(getAddressById(components, ZkCheckComponentID));
    if (zkCheck.getValue(SingletonID)) {
      uint256[6] memory input = new uint256[](6);
      input[0] = moveInfo.coord_hash;
      input[1] = moveInfo.perlin;
      input[2] = moveInfo.radius;
      input[3] = moveInfo.seed;
      input[4] = moveInfo.old_hash;
      input[5] = moveInfo.distance;
      require(Verifier.verifyMoveProof(moveInfo.a, moveInfo.b, moveInfo.c, input), "Failed move proof check");
    }
    uint256 entityId = addressToEntity(msg.sender);

    PlayerComponent player = PlayerComponent(getAddressById(components, PlayerComponentID));
    require(player.has(entityId), "not joined");

    MoveCooldownComponent moveCooldown = MoveCooldownComponent(getAddressById(components, MoveCooldownComponentID));
    MoveConfig memory moveConfig = MoveConfigComponent(getAddressById(components, MoveConfigComponentID)).getValue();
    MoveCooldown movable = moveCooldown.getValue(entityId);
    require(
      movable.remainingMovePoints > 0 || uint64(now) - movable.lastMoveTime > moveConfig.increaseCooldown,
      "no move points"
    );
    require(moveInfo.distance <= moveConfig.maxDistance, "move too far");

    // Constrain position to map size, wrapping around if necessary
    MapConfig memory mapConfig = MapConfigv2Component(getAddressById(components, MapConfigv2ComponentID)).getValue();
    require(moveInfo.radius <= mapConfig.gameRadiusX && moveInfo.radius <= mapConfig.gameRadiusY, "radius over limit");

    HiddenPositionComponent(getAddressById(components, HiddenPositionComponentID)).set(entityId, moveInfo.coord_hash);
    uint64 remainPoints = movable.remainingMovePoints +
      (uint64(now) - movable.lastMoveTime) /
      moveConfig.increaseCooldown -
      1;
    if (remainPoints > moveConfig.maxPoints) {
      remainPoints = moveConfig.maxPoints;
    }
    moveCooldown.set(entityId, MoveCooldown(uint64(uint64(now)), remainPoints));
  }
}
