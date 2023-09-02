// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library TickLib {
  struct Tick {
    bool initialized;
    uint128 liquidity;
  }

  function update(
    mapping (int24 => Tick) storage self,
    int24 tick,
    uint128 newLiquidity
  ) internal returns (bool flipped) {
    Tick storage tick_ = self[tick];
    uint128 liquidityBefore = tick_.liquidity;
    uint128 liquidityAfter = liquidityBefore + newLiquidity;

    if (liquidityBefore == 0) {
      tick_.initialized = true;
    }

    flipped = (liquidityBefore == 0) != (liquidityAfter == 0);

    tick_.liquidity = liquidityAfter;
  }
}
