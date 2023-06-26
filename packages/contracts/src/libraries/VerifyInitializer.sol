// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {IWorld} from "solecs/interfaces/IWorld.sol";
import {ZKConfigComponent, ID as ZKConfigComponentID, ZKConfig} from "components/ZKConfigComponent.sol";
import {SingletonID} from "solecs/SingletonID.sol";

library VerifyInitializer {
    function init(IWorld world) internal {
        ZKConfigComponent zkConfig = ZKConfigComponent(
            world.getComponent(ZKConfigComponentID)
        );
        // don't set if not checking zk
        zkConfig.set(
            ZKConfig({open: true, initVerifyAddress: 0x7799F7d25621fb541307D905640EC00f371C26da, moveVerifyAddress: 0x78862A5ef7B4b3A3786614d3B7f05c600e389226, markVerifyAddress: 0x78862A5ef7B4b3A3786614d3B7f05c600e389226, treasureVerifyAddress: 0x78862A5ef7B4b3A3786614d3B7f05c600e389226, resourceVerifyAddress: 0x78862A5ef7B4b3A3786614d3B7f05c600e389226})
        );
    }
}
