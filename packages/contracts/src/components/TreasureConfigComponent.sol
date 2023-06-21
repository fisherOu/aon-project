// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;
import { BareComponent } from "solecs/BareComponent.sol";
import { LibTypes } from "solecs/LibTypes.sol";
import { SingletonID } from "solecs/SingletonID.sol";

uint256 constant ID = uint256(keccak256("component.TreasureConfig"));

struct PropertyConfigRange {
    uint64 propertyId;
    uint8 triggerType;// 0: airdrop; 1: flightToTarget; 2: flightAndTouch; 3: destroy
    //0: vision; 1: damage; 2: shield; 3: teleprotation;
    // 4: two-way teleprotation; 5: DefenseCannon; 6: Wormhole; 7: LandMine;
    // 8: flightToTarget; 9: fog;
    uint8 effectType;
    uint32 energyPerRange;
    uint32 rangeMax;
    uint32 rangeMin;
    uint32 energyPerArea;
    uint32 areaMax;
    uint32 areaMin;
    uint32 energyPerDamage;
    uint32 energyPerShield;
}

struct TreasureTypes {
    uint64 typeId;
    uint8 isActive;// 0: not active; 1: active;
    uint8 isFlight;// 0: airdrop; 1: flight;
    uint64 flightEffectId;
    uint64 arrivalEffectId;
    uint64 destroyEffectId;
}

struct TreasureConfig {
  uint32 energyMax;
  uint32 energyMin;
  bytes treasureTypes;
  bytes properties;
}

contract TreasureConfigComponent is BareComponent {
  constructor(address world) BareComponent(world, ID) {}

  function getSchema() public pure override returns (string[] memory keys, LibTypes.SchemaValue[] memory values) {
    keys = new string[](4);
    values = new LibTypes.SchemaValue[](4);

    keys[0] = "energyMax";
    values[0] = LibTypes.SchemaValue.UINT32;

    keys[1] = "energyMin";
    values[1] = LibTypes.SchemaValue.UINT32;

    keys[2] = "treasureTypes";
    values[2] = LibTypes.SchemaValue.STRING;

    keys[3] = "properties";
    values[3] = LibTypes.SchemaValue.STRING;
  }

  function set(TreasureConfig memory treasureConfig) public {
    set(SingletonID, abi.encode(treasureConfig.energyMax, treasureConfig.energyMin, treasureConfig.treasureTypes, treasureConfig.terrain));
  }

  function getValue() public view returns (TreasureConfig memory) {
    (uint32 energyMax, uint32 energyMin, bytes memory treasureTypes, bytes memory properties) = abi.decode(getRawValue(SingletonID), (uint32, uint32, bytes, bytes));
    return TreasureConfig(energyMax, energyMin, treasureTypes, properties);
  }
}
