// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

interface IV3SwapCallback {  
  function v3SwapCallback(
    int256 amount0, 
    int256 amount1,
    bytes calldata data  
  ) external;
}