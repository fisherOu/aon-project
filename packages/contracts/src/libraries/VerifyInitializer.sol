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
            ZKConfig({open: true, initVerifyAddress: 0x44E4cE6FBbB74b97ED410918FE078FF96FCC3e59, moveVerifyAddress: 0x25DB2FDb5DD5a1fA0cdD05D1861D415d7015f78c, markVerifyAddress: 0xFDe64A83aFAeF76B1ff7f8b3D17791D0e270BDb8, treasureVerifyAddress: 0x32Ac23C5DAa44437726A529B695aCa575986eD7a, resourceVerifyAddress: 0x9a961BE9bED3C9a225c3035954D42C9B3957d7d7,
            attackPathVerifyAddress:
            0x9f0e5b2bb6329C112Ac9aFe838dD4262a7490Cc9})
        );
    }
}
