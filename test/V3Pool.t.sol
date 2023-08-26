// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import "forge-std/Test.sol";
import "./ERC20Mintable.sol";
import { V3Pool } from "../src/V3Pool.sol";

contract V3PoolTest is Test {
  /*ERC20Mintable token0;
  ERC20Mintable token1;
  V3Pool pool;
  bool shouldTransferInCallback;

  struct TestParams {
    uint128 token0Balance;   
    uint128 token1Balance;
    int24 currentTick;
    int24 tickLow;
    int24 tickHigh;
    uint128 liquidity;
    bool shouldTransferInCallback;
    bool mintLiquidity;
    uint160 currentSqrtP;
  }*/

  function setUp() public {
    /*token0 = new ERC20Mintable("token0", "t0", 18);
    token1 = new ERC20Mintable("token1", "t1", 18);*/
  }

  function testEx() public {
    assertTrue(true);
  }

  /*function testMintSuccess() public {
    TestParams memory params = TestParams({
      token0Balance: 1 ether,
      token1Balance: 5000 ether,
      currentTick: 85176,
      tickLow: 84222,
      tickHigh: 86129,
      liquidity: 1517882343751509868544,
      shouldTransferInCallback: true,
      mintLiquidity: true,
      currentSqrtP: 5602277097478614198912276234240
    });

    (uint256 poolBalance0, uint256 poolBalance1) = setupTest(params);
    uint256 expectedAmount0 = 0.99897661834742528 ether;
    uint256 expectedAmount1 = 5000 ether;

    assertEq(poolBalance0, expectedAmount0, "Incorrect poolbalance0");
    assertEq(poolBalance1, expectedAmount1, "Incorrect poolbalance1");assertEq(token0.balanceOf(address(pool)), expectedAmount0);
    assertEq(token1.balanceOf(address(pool)), expectedAmount1);

    bytes32 positionKey = keccak256(abi.encode(
      address(this),
      params.tickLow,
      params.tickHigh
    ));
    uint128 liquidity = pool.positions(positionKey);
    assertEq(liquidity, params.liquidity, "Incorrect liquidity");

    (bool tickInitialized, uint128 tickLiquidity) = pool.ticks(params.tickLow);
    assertTrue(tickInitialized);
    assertEq(tickLiquidity, params.liquidity, "Incorrect tickLow");
    (tickInitialized, tickLiquidity) = pool.ticks(params.tickHigh);
    assertTrue(tickInitialized);
    assertEq(tickLiquidity, params.liquidity, "Incorrect tickHigh");

    assertEq(pool.sqrtPriceX96(), 5602277097478614198912276234240, "Incorrect sqrtPriceX96");
    assertEq(pool.tick(), 85176, "Incorrect tick");
    assertEq(pool.liquidity(), 1517882343751509868544, "Incorrect liquidity");

  }

  function testSwapBuyToken0() public {
    TestParams memory params = TestParams({
      token0Balance: 1 ether,
      token1Balance: 5000 ether,
      currentTick: 85176,
      tickLow: 84222,
      tickHigh: 86129,
      liquidity: 1517882343751509868544,
      shouldTransferInCallback: true,
      mintLiquidity: true,
      currentSqrtP: 5602277097478614198912276234240
    });

    (uint256 poolBalance0, uint256 poolBalance1) = setupTest(params);
    token1.mint(address(this), 42 ether);
    int256 balance0Before = int256(token0.balanceOf(address(this)));
    
    bytes memory data = abi.encodePacked(
      address(token0),
      address(token1),
      address(this)
    );
    (int256 amount0, int256 amount1) = pool.swap(address(this), data);
    assertEq(amount0, -0.008396714242162444 ether, "Wrong token0 out");
    assertEq(amount1, 42 ether, "Wrong token1 in");

    assertEq(
      token0.balanceOf(address(this)),
      uint256(balance0Before - amount0),
      "Wrong balance0Before"
    );
    assertEq(
      token1.balanceOf(address(this)),
      0,
      "Wrong token1 balance"
    );

    assertEq(
      token0.balanceOf(address(pool)),
      uint256(int256(poolBalance0) + amount0),
      "Wrong token0 pool balance"
    );
    assertEq(
      token1.balanceOf(address(pool)),
      uint256(int256(poolBalance1) + amount1),
      "Wrong token1 pool balance"
    );

    assertEq(
      pool.sqrtPriceX96(),
      5604469350942327889444743441197,
      "Wrong current sqrtPrice"
    );
    assertEq(pool.tick(), 85184, "Wrong tick");
    assertEq(
      pool.liquidity(),
      1517882343751509868544,
      "Wrong liquidity"
    );
  }


  function setupTest(TestParams memory params) internal returns (
    uint256 poolBalance0, 
    uint256 poolBalance1
  ) {
    token0.mint(address(this), params.token0Balance);
    token1.mint(address(this), params.token1Balance);

    pool = new V3Pool(
      address(token0),
      address(token1),
      params.currentTick,
      params.currentSqrtP
    );

    shouldTransferInCallback = params.shouldTransferInCallback;
    bytes memory data = abi.encodePacked(
      address(token0),
      address(token1),
      address(this)
    );

    if (params.mintLiquidity) {
      (poolBalance0, poolBalance1) = pool.mint(
        address(this),
        params.liquidity,
        params.tickLow,
        params.tickHigh,
        data
      );
    }
  }

  function v3MintCallback(
    uint256 amount0, 
    uint256 amount1,
    bytes calldata data
  ) public {
    if (shouldTransferInCallback) {
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
  }*/

}
