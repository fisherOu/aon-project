// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {BareComponent} from "solecs/BareComponent.sol";
import {LibTypes} from "solecs/LibTypes.sol";
import {SingletonID} from "solecs/SingletonID.sol";

uint256 constant ID = uint256(keccak256("component.MoveConfig"));

struct MoveConfig {
    uint64 initPoints;
    uint64 increaseCooldown;
    uint64 maxPoints;
    uint64 maxDistance;
}

contract MoveConfigComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema()
        public
        pure
        override
        returns (string[] memory keys, LibTypes.SchemaValue[] memory values)
    {
        keys = new string[](4);
        values = new LibTypes.SchemaValue[](4);

        keys[0] = "initPoints";
        values[0] = LibTypes.SchemaValue.UINT64;

        keys[1] = "increaseCooldown";
        values[1] = LibTypes.SchemaValue.UINT64;

        keys[2] = "maxPoints";
        values[2] = LibTypes.SchemaValue.UINT64;

        keys[3] = "maxDistance";
        values[3] = LibTypes.SchemaValue.UINT64;
    }

    function set(MoveConfig memory moveConfig) public {
        set(
            SingletonID,
            abi.encode(
                moveConfig.initPoints,
                moveConfig.increaseCooldown,
                moveConfig.maxPoints,
                moveConfig.maxDistance
            )
        );
    }

    function getValue() public view returns (MoveConfig memory) {
        (
            uint64 initPoints,
            uint64 increaseCooldown,
            uint64 maxPoints,
            uint64 maxDistance
        ) = abi.decode(
                getRawValue(SingletonID),
                (uint64, uint64, uint64, uint64)
            );
        return MoveConfig(initPoints, increaseCooldown, maxPoints, maxDistance);
    }
}
