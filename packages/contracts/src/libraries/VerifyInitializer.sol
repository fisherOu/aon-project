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
            ZKConfig({open: true, initVerifyAddress: 0xd3F8a21e3F0bc05460010219B63c841e7044221A, moveVerifyAddress: 0x334aa89ec77a5208601bf934d171d932a85c849c13fc7cde54e36d39e9ad0735})
        );
    }
}
