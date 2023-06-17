// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "forge-std/Script.sol";
import "../test/ERC20Mintable.sol";
import { V3Pool } from "../src/V3Pool.sol";
import { V3Manager } from "../src/V3Manager.sol";

contract Deployment is Script {
  function run() public {
    uint256 token0Balance = 1 ether;
    uint256 token1Balance = 5042 ether;
    int24 tick = 85176;
    uint160 sqrtP = 5602277097478614198912276234240;

    vm.startBroadcast();
    ERC20Mintable token0 = new ERC20Mintable("token0", "t0", 18);
    ERC20Mintable token1 = new ERC20Mintable("token1", "t1", 18);
    token0.mint(msg.sender, token0Balance);
    token1.mint(msg.sender, token1Balance);

    V3Pool pool = new V3Pool(
      address(token0), 
      address(token1), 
      tick, 
      sqrtP
    );
    V3Manager manager = new V3Manager();   
    vm.stopBroadcast();

    console.log("token0 address: ", address(token0));
    console.log("token1 address: ", address(token1));
    console.log("Pool address: ", address(pool));
    console.log("Manager address: ", address(manager));
  }
}
