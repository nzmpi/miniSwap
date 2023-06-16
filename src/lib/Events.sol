// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

contract Events {
  event Mint(
    address sender, 
    address owner,
    int24 tickLow,
    int24 tickHigh,
    uint128 amount,
    uint256 amount0,
    uint256 amount1
  );
}
