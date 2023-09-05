// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.19;

import { SqrtPriceMath } from "./SqrtPriceMath.sol";
import { AmountMath } from "./AmountMath.sol";
import "./FullMath.sol";
import "./FixedPoint96.sol";

library SwapMath {
  function computeSwapStep(
    uint160 sqrtPriceCurrentX96,
    uint160 sqrtPriceTargetX96,
    uint128 liquidity,
    uint256 amountRemaining
  ) internal pure returns (
    uint160 sqrtPriceNextX96,
    uint256 amountIn,
    uint256 amountOut
  ) {
    bool zeroForOne = sqrtPriceCurrentX96 >= sqrtPriceTargetX96;

    sqrtPriceNextX96 = getNextSqrtPriceFromInput(
      sqrtPriceCurrentX96,
      liquidity,
      amountRemaining,
      zeroForOne
    );

    amountIn = AmountMath.calcAmount0(
      sqrtPriceCurrentX96,
      sqrtPriceNextX96,
      liquidity
    );

    amountOut = AmountMath.calcAmount1(
      sqrtPriceCurrentX96,
      sqrtPriceNextX96,
      liquidity
    );

    if (!zeroForOne) {
      (amountIn, amountOut) = (amountOut, amountIn);
    }
  }

  function getNextSqrtPriceFromInput(
    uint160 sqrtPriceCurrentX96,
    uint128 liquidity,
    uint256 amount,
    bool zeroForOne
  ) internal pure returns (uint160 sqrtPriceNextX96) {
    if (zeroForOne) {
      return getNextSqrtPriceFromAmount0RoundingUp(
        sqrtPriceCurrentX96, 
        liquidity, 
        amount
      );
    } else {
      return getNextSqrtPriceFromAmount1RoundingUp(
        sqrtPriceCurrentX96, 
        liquidity, 
        amount
      );
    }
  }

  function getNextSqrtPriceFromAmount0RoundingUp(
    uint160 sqrtPriceCurrentX96,
    uint128 liquidity,
    uint256 amount
  ) internal pure returns (uint160 sqrtPriceNextX96) {
    if (amount == 0) return sqrtPriceCurrentX96;
    uint256 numerator = uint256(liquidity) << FixedPoint96.RESOLUTION;
    uint256 product;
    // may overflow
    unchecked {
      product = amount * sqrtPriceCurrentX96;   
    }    
    
    if (product/amount == sqrtPriceCurrentX96) {
      uint256 denominator = numerator + product;
      if (denominator >= numerator) {
        return uint160(FullMath.mulDivRoundingUp(
          numerator,
          sqrtPriceCurrentX96,
          denominator
        ));
      }
    }

    return uint160(FullMath.divRoundingUp(
      numerator,
      numerator/sqrtPriceCurrentX96 + amount
    ));
  }

  function getNextSqrtPriceFromAmount1RoundingUp(
    uint160 sqrtPriceCurrentX96,
    uint128 liquidity,
    uint256 amount
  ) internal pure returns (uint160 sqrtPriceNextX96) {
    return sqrtPriceCurrentX96 + uint160((amount << FixedPoint96.RESOLUTION)/liquidity);
  }
}