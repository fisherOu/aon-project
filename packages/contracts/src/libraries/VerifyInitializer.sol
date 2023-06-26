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
            ZKConfig({open: true, initVerifyAddress: 0x44E4cE6FBbB74b97ED410918FE078FF96FCC3e59, moveVerifyAddress: 0x8B8771931eFC48E8968a493a1CbaB5792dC1b28A, markVerifyAddress: 0x887aBd88AF9cb61E31A1c2e78354f4e4cF9496e9, treasureVerifyAddress: 0x32Ac23C5DAa44437726A529B695aCa575986eD7a, resourceVerifyAddress: 0x9a961BE9bED3C9a225c3035954D42C9B3957d7d7})
        );
    }
}
