// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IV3MintCallback {  
  function v3MintCallback(
    uint256 amount0, 
    uint256 amount1,
    bytes calldata data
  ) external;
}