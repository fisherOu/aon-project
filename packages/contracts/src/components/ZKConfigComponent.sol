// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {BareComponent} from "solecs/BareComponent.sol";
import {LibTypes} from "solecs/LibTypes.sol";
import {SingletonID} from "solecs/SingletonID.sol";

uint256 constant ID = uint256(keccak256("component.ZKConfig"));

struct ZKConfig {
    bool open;
    address initVerifyAddress;
    address moveVerifyAddress;
}

contract ZKConfigComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema()
        public
        pure
        override
        returns (string[] memory keys, LibTypes.SchemaValue[] memory values)
    {
        keys = new string[](3);
        values = new LibTypes.SchemaValue[](3);

        keys[0] = "open";
        values[0] = LibTypes.SchemaValue.BOOL;

        keys[1] = "initVerifyAddress";
        values[1] = LibTypes.SchemaValue.ADDRESS;

        keys[2] = "moveVerifyAddress";
        values[2] = LibTypes.SchemaValue.ADDRESS;
    }

    function set(ZKConfig memory moveConfig) public {
        set(
            SingletonID,
            abi.encode(
                moveConfig.open,
                moveConfig.initVerifyAddress,
                moveConfig.moveVerifyAddress
            )
        );
    }

    function getValue() public view returns (ZKConfig memory) {
        (bool open,
            address initVerifyAddress,
            address moveVerifyAddress) = abi.decode(
                getRawValue(SingletonID),
                (bool, address, address)
            );
        return ZKConfig(open, initVerifyAddress, moveVerifyAddress, maxDistance);
    }
}
