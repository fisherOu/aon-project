// SPDX-License-Identifier: MIT
// components: ["SpaceTimeMarkerComponent"]
pragma solidity >=0.8.0;
import { addressToEntity } from "solecs/utils.sol";
import { System, IWorld } from "solecs/System.sol";
import { getAddressById } from "solecs/utils.sol";
import { MapConfigv2Component, ID as MapConfigv2ComponentID, MapConfig } from "components/MapConfigv2Component.sol";
import { VisionConfigComponent, ID as VisionConfigComponentID, VisionConfig } from "components/VisionConfigComponent.sol";
import { ZkCheckComponent, ID as ZkCheckComponentID } from "components/ZkCheckComponent.sol";
import { SingletonID } from "solecs/SingletonID.sol";

import { SpaceTimeMarkerComponent, ID as SpaceTimeMarkerComponentID, SpaceTimeMarker } from "components/SpaceTimeMarkerComponent.sol";
import { Verifier } from "libraries/Verifier.sol";

uint256 constant ID = uint256(keccak256("system.Mark"));

struct MarkInfo {
  uint256 coord_hash;
  uint256 perlin;
  uint256 radius;
  uint256 seed;
  uint256 real_hash;
  uint256 distance;
  uint256[2] a;
  uint256[2][2] b;
  uint256[2] c;
}

contract MarkSystem is System {
  constructor(IWorld _world, address _components) System(_world, _components) {}

  function execute(bytes memory args) public returns (bytes memory) {
    MarkInfo memory markInfo = abi.decode(args, (MarkInfo));
    return executeTyped(markInfo);
  }

  function executeTyped(MarkInfo memory markInfo) public returns (bytes memory) {
    ZkCheckComponent zkCheck = ZkCheckComponent(getAddressById(components, ZkCheckComponentID));
    if (zkCheck.getValue(SingletonID)) {
      uint256[6] memory input = [markInfo.coord_hash, markInfo.perlin, markInfo.radius, markInfo.seed, markInfo.real_hash, markInfo.distance];
      require(Verifier.verifyMoveProof(markInfo.a, markInfo.b, markInfo.c, input), "Failed mark proof check");
    }

    // Constrain position to map size, wrapping around if necessary
    MapConfig memory mapConfig = MapConfigv2Component(getAddressById(components, MapConfigv2ComponentID)).getValue();
    require(markInfo.radius <= mapConfig.gameRadiusX && markInfo.radius <= mapConfig.gameRadiusY, "radius over limit");

    VisionConfig memory visionConfig = VisionConfigComponent(getAddressById(components, VisionConfigComponentID))
      .getValue();
    require(markInfo.distance <= visionConfig.maxDistance, "mark too far");

    SpaceTimeMarkerComponent(getAddressById(components, SpaceTimeMarkerComponentID)).set(
      markInfo.real_hash,
      SpaceTimeMarker(markInfo.seed, uint64(block.timestamp) + visionConfig.remainTime)
    );
  }
}
