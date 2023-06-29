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
            ZKConfig({open: true, initVerifyAddress: 0xd2E3710e75b0BBeF7274EA8C9c912bC8988171F6,
            moveVerifyAddress: 0xDc4c4c2DAC39F2651a54FbCd8d6f7a915e9a3FE0,
            markVerifyAddress: 0xb4C03B82B2e46b801df2203DE6a3550d35AD69bf,
            treasureVerifyAddress: 0xEB49bD3A80A5b7C221843664a30060bcfD963f47,
            resourceVerifyAddress: 0xC444a840dBA9e5db9Fc35863d2f79FeA2890dF9d,
            attackPathVerifyAddress:
            0x5c618759661C342ba99fA59CC05a0Aa7134b7E87})
        );
    }
}
