// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";
import { ERC20Mock } from "test/mocks/ERC20Mock.sol"; // we can mint multiple different tokens on this.
import { PoolFactory } from "src/PoolFactory.sol"; // the factory can create the TSwapPool
import { TSwapPool } from "src/TSwapPool.sol";

contract Invariant is StdInvariant, Test {
    // these pools have 2 assets
    ERC20Mock poolToken; // this represents any arbitrarily erc20 token
    ERC20Mock weth;

    PoolFactory factory; // the factory can create multiple pools
    TSwapPool pool; // we'll make this our pool for poolToken / WETH

    int256 constant STARTING_X_100e18_POOLTOKEN = 100e18; // starting ERC20 / poolToken balance
    int256 constant STARTING_Y_50e18_WETH = 50e18; // starting WETH balance
    int256 constant STARTING_Y_50e18_LIQUIDITYTOKEN = 50e18;

    // constructor

    function setUp() public {
        weth = new ERC20Mock();
        poolToken = new ERC20Mock();
        factory = new PoolFactory(address(weth));
        pool = TSwapPool(factory.createPool(address(poolToken)));

        // for this test we need to create some initial balances for poolToken and weth
        poolToken.mint(address(this), uint256(STARTING_X_100e18_POOLTOKEN));
        weth.mint(address(this), uint256(STARTING_Y_50e18_WETH));
        // Now we need to figure out how to get the tokens into the pool.
        // check TSwapPool::deposit for how to do this

        poolToken.approve(address(pool), type(uint256).max); // `type(uint256).max` is basically the max amount possible
            // in Solidity.
        weth.approve(address(pool), type(uint256).max);

        pool.deposit(
            uint256(STARTING_Y_50e18_WETH),
            uint256(STARTING_Y_50e18_LIQUIDITYTOKEN),
            uint256(STARTING_X_100e18_POOLTOKEN),
            uint64(block.timestamp)
        );
    }

    function statefulFuzz_constantProductFormulaStaysTheSame() public {
        // assert ???
        // The change in the poolsize of weth should follow this function:
        // x⋅y=k   or  ∆x = (β/(1-β)) * x
        //  It's quite complex, but basically everytime the function `swapExactInput`,
        // we're using the formula: ∆x = (β/(1-β)) * x
        // So inside this function we'll check on the balance of weth and poolToken before and after the swap.
        // We'll use the handler, to mimic this same effect.
        // in the handler we'll create a variable actual delta x == ∆x = (β/(1-β)) * x
        // or, actual delta x == expected delta x
        // so above will be our assert
    }
}
