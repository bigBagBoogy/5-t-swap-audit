// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../../src/TSwapPool.sol";
import { ERC20Mock } from "../mocks/ERC20Mock.t.sol";

contract PoC is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address user = makeAddr("user");

    function setUp() public {
        pool = new TSwapPool();
        weth = ERC20Mock(pool.getWeth());
        poolToken = ERC20Mock(pool.getPoolToken());
        vm.deal(user, 10e18);
    }

    // getInputAmountBasedOnOutput() is off!
    // getInputAmountBasedOnOutput() used in `TSwapPool::swapExactOutput`
    // which in turn is used in sellPoolTokens()
    // compared to: `getOutputAmountBasedOnInput()`
    // when are fees incurred?
    // When user sells pool tokens, the (too high) fees are incurred.
    // So first we need to deal a user some pool tokens, and then we sell them.
    // The sellPoolTokens() takes poolTokenAmount as an argument.
    // The way it works is: `getInputAmountBasedOnOutput(outputAmount, inputReserves, outputReserves);`
    // calculates inputAmount (but reduces it by fees).

    function testTooHighFeesInFunction() {
        intendedFees = 997 / 1000;
        console.log(intendedFees);
        actualFees = 997 / 10000 * inputAmount;
        console.log(actualFees);
        vm.prank(user);
        sellPoolTokens(1e18);
    }
}
