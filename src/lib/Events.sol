// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Events {
  event Mint(
    address indexed sender, 
    address indexed owner,
    int24 tickLow,
    int24 tickHigh,
    uint128 amount,
    uint256 amount0,
    uint256 amount1
  );
  event Swap(
    address indexed sender,
    address indexed receiver,
    int256 amount0,
    int256 amount1,
    uint160 sqrtPriceX96,
    int24 tick,
    uint128 liquidity
  );
}
