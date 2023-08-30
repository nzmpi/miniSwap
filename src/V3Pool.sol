// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "./lib/Events.sol";
import "./lib/Errors.sol";
import "./lib/TickLib.sol";
import "./lib/PositionLib.sol";
import "./interfaces/IV3MintCallback.sol";
import "./interfaces/IV3SwapCallback.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract V3Pool is Errors, Events {
  using TickLib for mapping (int24 => TickLib.Tick);
  using PositionLib for mapping (bytes32 => PositionLib.Position);
  using PositionLib for PositionLib.Position;

  address immutable public token0; 
  address immutable public token1;
  int24 constant MIN_TICK = -887272;
  int24 constant MAX_TICK = 887272;

  // current price
  uint160 public sqrtPriceX96;
  int24 public tick;
  uint128 public liquidity;

  mapping (int24 => TickLib.Tick) public ticks;
  mapping (bytes32 => PositionLib.Position) public positions;

  struct CallbackData {
    address token0;
    address token1;
    address sender;
  }
  
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
    int24 tickHigh,
    bytes calldata data
  ) external returns (uint256 amount0, uint256 amount1) {
    if (owner == address(0)) revert ZeroAddress();
    if (amount == 0) revert ZeroLiquidity();
    if (
      tickLow < MIN_TICK ||
      tickHigh > MAX_TICK ||
      tickLow >= tickHigh
    ) revert InvalidTickRange();

    ticks.update(tickLow, amount);
    ticks.update(tickHigh, amount);

    PositionLib.Position storage position = positions.get(
      owner, 
      tickLow, 
      tickHigh
    );
    position.update(amount);

    amount0 = 0.99897661834742528 ether;
    amount1 = 5000 ether;

    liquidity = liquidity + amount;

    uint256 balance0Before;
    uint256 balance1Before;
    if (amount0 > 0) balance0Before = balance(0);
    if (amount1 > 0) balance1Before = balance(1);

    IV3MintCallback(msg.sender).v3MintCallback(
      amount0,
      amount1,
      data
    );

    if (amount0 > 0 && balance0Before + amount0 > balance(0))
      revert InsufficientAmount();
    if (amount1 > 0 && balance1Before + amount1 > balance(1))
      revert InsufficientAmount();    

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

  function swap(
    address receiver, 
    bytes calldata data
  ) external returns (int256 amount0, int256 amount1) {
    int24 newTick = 85184;
    uint160 newPrice = 5604469350942327889444743441197;
    amount0 = -0.008396714242162444 ether;
    amount1 = 42 ether;

    tick = newTick;
    sqrtPriceX96 = newPrice;

    IERC20(token0).transfer(receiver, uint256(-amount0));

    uint256 balance1Before = balance(1);
    IV3SwapCallback(msg.sender).v3SwapCallback(
      amount0,
      amount1,
      data
    );
    if (balance(1) < balance1Before + uint256(amount1)) 
      revert InsufficientAmount();

    emit Swap(
      msg.sender, 
      receiver, 
      amount0, 
      amount1, 
      newPrice, 
      newTick, 
      liquidity
    );
  }

  function balance(uint256 tokenIndex) internal view returns (uint256) {
    if (tokenIndex == 0) return IERC20(token0).balanceOf(address(this));
    else return IERC20(token1).balanceOf(address(this));
  }

}