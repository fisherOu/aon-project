// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {BareComponent} from "solecs/BareComponent.sol";
import {LibTypes} from "solecs/LibTypes.sol";

uint256 constant ID = uint256(keccak256("component.TreasureTimer"));

struct TreasureTimer {
    uint64 cooldown_timeout;
    uint64 charging_timeout;
}

contract TreasureTimerComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema()
        public
        pure
        override
        returns (string[] memory keys, LibTypes.SchemaValue[] memory values)
    {
        keys = new string[](2);
        values = new LibTypes.SchemaValue[](2);

        keys[0] = "cooldown_timeout";
        values[0] = LibTypes.SchemaValue.UINT64;

        keys[1] = "charging_timeout";
        values[1] = LibTypes.SchemaValue.UINT64;
    }

    function set(
        uint256 entity,
        TreasureTimer memory treasureTimer
    ) public {
        set(entity, abi.encode(treasureTimer.cooldown_timeout, treasureTimer.charging_timeout));
    }

    function getValue(
        uint256 entity
    ) public view returns (TreasureTimer memory) {
        (uint64 cooldown_timeout, uint64 charging_timeout) = abi.decode(
            getRawValue(entity),
            (uint64, uint64)
        );
        return TreasureTimer(cooldown_timeout, charging_timeout);
    }
}
