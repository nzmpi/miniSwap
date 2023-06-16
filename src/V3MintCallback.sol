// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./V3Pool.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V3MintCallback {
  
  function v3MintCallback(uint256 amount0, uint256 amount1) external {
    V3Pool pool = V3Pool(msg.sender);
    IERC20 token0 = IERC20(pool.token0());
    IERC20 token1 = IERC20(pool.token1());
    token0.transfer(msg.sender, amount0);
    token1.transfer(msg.sender, amount1);
  }

}