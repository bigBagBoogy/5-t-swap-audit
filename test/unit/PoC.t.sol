// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../../src/TSwapPool.sol";
import { ERC20Mock } from "../mocks/ERC20Mock.t.sol";

contract PoC is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    function setUp() public {
        pool = new TSwapPool();
        weth = ERC20Mock(pool.getWeth());
        poolToken = ERC20Mock(pool.getPoolToken());
    }

// used in `TSwapPool::swapExactOutput` compared to: `getOutputAmountBasedOnInput`
function testTooHighFeesInFunction(){
    getInputAmountBasedOnOutput() 
}
}