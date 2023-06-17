// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {BareComponent} from "solecs/BareComponent.sol";
import {LibTypes} from "solecs/LibTypes.sol";

uint256 constant ID = uint256(keccak256("component.ResourcePosition"));

struct ResourcePosition {
    uint256 seed;
    uint64 timeout;
}

contract ResourcePositionComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema()
        public
        pure
        override
        returns (string[] memory keys, LibTypes.SchemaValue[] memory values)
    {
        keys = new string[](2);
        values = new LibTypes.SchemaValue[](2);

        keys[0] = "seed";
        values[0] = LibTypes.SchemaValue.UINT256;

        keys[1] = "timeout";
        values[1] = LibTypes.SchemaValue.UINT64;
    }

    function set(
        uint256 entity,
        ResourcePosition memory resourcePosition
    ) public {
        set(
            entity,
            abi.encode(resourcePosition.seed, resourcePosition.timeout)
        );
    }

    function getValue(
        uint256 entity
    ) public view returns (ResourcePosition memory) {
        (uint256 seed, uint64 timeout) = abi.decode(
            getRawValue(entity),
            (uint256, uint64)
        );
        return ResourcePosition(seed, timeout);
    }
}
