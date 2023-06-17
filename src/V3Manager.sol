// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./V3Pool.sol";

contract V3Manager {

  function mint(
    address pool,
    int24 tickLow,
    int24 tickHigh,
    uint128 liquidity,
    bytes calldata data
  ) external {
    V3Pool(pool).mint(
      msg.sender,
      liquidity,
      tickLow,
      tickHigh,
      data
    );
  }

  function swap(address pool, bytes calldata data) external {
    V3Pool(pool).swap(msg.sender, data);
  }

  function v3MintCallback(
    uint256 amount0, 
    uint256 amount1,
    bytes calldata data
  ) external {
    V3Pool.CallbackData memory callbackData = abi.decode(
      data,
      (V3Pool.CallbackData)
    );

    ERC20(callbackData.token0).transferFrom(
      callbackData.sender, 
      msg.sender,
      amount0
    );
      ERC20(callbackData.token1).transferFrom(
        callbackData.sender, 
        msg.sender,
        amount1
      );
    
  }

  function v3SwapCallback(
    int256 amount0, 
    int256 amount1,
    bytes calldata data
  ) public {
    V3Pool.CallbackData memory callbackData = abi.decode(
      data,
      (V3Pool.CallbackData)
    );
    if (amount0 > 0) {
      ERC20(callbackData.token0).transferFrom(
        callbackData.sender, 
        msg.sender,
        uint256(amount0)
      );
    }

    if (amount1 > 0) {
      ERC20(callbackData.token1).transferFrom(
        callbackData.sender, 
        msg.sender,
        uint256(amount1)
      );
    }
  }
}
