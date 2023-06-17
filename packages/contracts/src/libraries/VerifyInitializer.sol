// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import {IWorld} from "solecs/interfaces/IWorld.sol";
import {ZkCheckComponent, ID as ZkCheckComponentID} from "components/ZkCheckComponent.sol";
import {SingletonID} from "solecs/SingletonID.sol";

library VerifyInitializer {
    function init(IWorld world) internal {
        ZkCheckComponent zkCheck = ZkCheckComponent(
            world.getComponent(ZkCheckComponentID)
        );
        // don't set if not checking zk
        zkCheck.set(SingletonID);
    }
}
