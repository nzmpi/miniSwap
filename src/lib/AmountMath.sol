// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./FixedPoint96.sol";
import "./FullMath.sol";

library AmountMath {
  function calcAmount0(
    uint160 sqrtPriceLowX96,
    uint160 sqrtPriceHighX96,
    uint128 liquidity
  ) internal pure returns (uint256 amount0) {
    if (sqrtPriceLowX96 > sqrtPriceHighX96)
      (sqrtPriceLowX96, sqrtPriceHighX96) = (sqrtPriceHighX96, sqrtPriceLowX96);

    require(sqrtPriceLowX96 > 0);

    amount0 = FullMath.divRoundingUp(
      FullMath.mulDivRoundingUp(
        (uint256(liquidity) << FixedPoint96.RESOLUTION),
        (sqrtPriceHighX96 - sqrtPriceLowX96),
        sqrtPriceHighX96
      ),
      sqrtPriceLowX96
    );
  }

  function calcAmount1(
    uint160 sqrtPriceLowX96,
    uint160 sqrtPriceHighX96,
    uint128 liquidity
  ) internal pure returns (uint256 amount1) {
    if (sqrtPriceLowX96 > sqrtPriceHighX96)
      (sqrtPriceLowX96, sqrtPriceHighX96) = (sqrtPriceHighX96, sqrtPriceLowX96);

    amount1 = FullMath.mulDivRoundingUp(
        liquidity,
        (sqrtPriceHighX96 - sqrtPriceLowX96),
        FixedPoint96.Q96
      );
  }
}
