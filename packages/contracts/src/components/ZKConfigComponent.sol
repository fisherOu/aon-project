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
    address markVerifyAddress;
    address treasureVerifyAddress;
    address resourceVerifyAddress;
    address attackPathVerifyAddress;
}

contract ZKConfigComponent is BareComponent {
    constructor(address world) BareComponent(world, ID) {}

    function getSchema()
        public
        pure
        override
        returns (string[] memory keys, LibTypes.SchemaValue[] memory values)
    {
        keys = new string[](7);
        values = new LibTypes.SchemaValue[](7);

        keys[0] = "open";
        values[0] = LibTypes.SchemaValue.BOOL;

        keys[1] = "initVerifyAddress";
        values[1] = LibTypes.SchemaValue.ADDRESS;

        keys[2] = "moveVerifyAddress";
        values[2] = LibTypes.SchemaValue.ADDRESS;

        keys[3] = "markVerifyAddress";
        values[3] = LibTypes.SchemaValue.ADDRESS;

        keys[4] = "treasureVerifyAddress";
        values[4] = LibTypes.SchemaValue.ADDRESS;

        keys[5] = "resourceVerifyAddress";
        values[5] = LibTypes.SchemaValue.ADDRESS;

        keys[6] = "attackPathVerifyAddress";
        values[6] = LibTypes.SchemaValue.ADDRESS;
    }

    function set(ZKConfig memory moveConfig) public {
        set(
            SingletonID,
            abi.encode(
                moveConfig.open,
                moveConfig.initVerifyAddress,
                moveConfig.moveVerifyAddress,
                moveConfig.markVerifyAddress,
                moveConfig.treasureVerifyAddress,
                moveConfig.resourceVerifyAddress,
                moveConfig.attackPathVerifyAddress
            )
        );
    }

    function getValue() public view returns (ZKConfig memory) {
        (bool open,
            address initVerifyAddress,
            address moveVerifyAddress,
            address markVerifyAddress,
            address treasureVerifyAddress,
            address resourceVerifyAddress,
            address attackPathVerifyAddress) = abi.decode(
                getRawValue(SingletonID),
                (bool, address, address, address, address, address, address)
            );
        return ZKConfig(open, initVerifyAddress, moveVerifyAddress, markVerifyAddress, treasureVerifyAddress, resourceVerifyAddress, attackPathVerifyAddress);
    }
}
