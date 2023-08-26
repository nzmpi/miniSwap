// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

library PositionLib {
  struct Position {
    uint128 liquidity;
  }

  function update(
    Position storage self,
    uint128 newLiquidity
  ) internal {
    self.liquidity += newLiquidity;
  }

  function get(
    mapping (bytes32 => Position) storage self,
    address owner,
    int24 tickLow,
    int24 tickHigh
  ) internal view returns (Position storage position) {
    position = self[
      keccak256(abi.encodePacked(owner, tickLow, tickHigh))
    ];
  }
}
