// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "./lib/Events.sol";
import "./lib/Errors.sol";
import "./lib/TickLib.sol";
import "./lib/PositionLib.sol";
import "./interfaces/IV3MintCallback.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V3Pool is Errors, Events {
  using TickLib for mapping (int24 => TickLib.Tick);
  using PositionLib for mapping (bytes32 => PositionLib.Position);
  using PositionLib for PositionLib.Position;

  address immutable public token0;
  address immutable public token1;
  int24 constant MIN_TICK = -887272;
  int24 constant MAX_TICK = 887272;

  uint160 sqrtPriceX96;
  int24 tick;
  uint128 liquidity;

  mapping (bytes32 => PositionLib.Position) positions;
  mapping (int24 => TickLib.Tick) ticks;
  
  constructor(
    address _token0, 
    address _token1,
    int24 _tick,
    uint160 _sqrtPriceX96
  ) {
    token0 = _token0;
    token1 = _token1;
    tick = _tick;
    sqrtPriceX96 = _sqrtPriceX96;
  }

  function mint(
    address owner,
    uint128 amount,
    int24 tickLow,
    int24 tickHigh
  ) external returns (uint256 amount0, uint256 amount1) {
    if (
      tickLow < MIN_TICK ||
      tickHigh > MAX_TICK ||
      tickLow >= tickHigh
    ) revert InvalidTickRange();
    if (amount == 0) revert ZeroLiquidity();

    ticks.update(tickLow, amount);
    ticks.update(tickHigh, amount);

    PositionLib.Position storage position = PositionLib.get(
      positions, 
      owner, 
      tickLow, 
      tickHigh
    );

    position.update(amount);

    amount0 = 0.998976618347425280 ether;
    amount1 = 5000 ether;

    liquidity += amount;

    uint256 balance0Before;
    uint256 balance1Before;
    if (amount0 > 0) balance0Before = balance(0);
    if (amount1 > 0) balance1Before = balance(1);

    IV3MintCallback(msg.sender).v3MintCallback(
        amount0,
        amount1
    );
    if (amount0 > 0 && balance0Before + amount0 > balance(0))
        revert InsufficientInputAmount();
    if (amount1 > 0 && balance1Before + amount1 > balance(1))
        revert InsufficientInputAmount();

    

    emit Mint(
      msg.sender, 
      owner, 
      tickLow, 
      tickHigh, 
      amount, 
      amount0, 
      amount1
    );

  }

  function balance(uint256 tokenIndex) internal view returns (uint256) {
    if (tokenIndex == 0) return IERC20(token0).balanceOf(address(this));
    else return IERC20(token1).balanceOf(address(this));
  }


}