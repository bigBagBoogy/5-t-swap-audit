// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";
import { ERC20Mock } from "../mocks/ERC20Mock.t.sol";
import { PoolFactory } from "../../../src/PoolFactory.sol";
import { TSwapPool } from "../../../src/TSwapPool.sol";
import { Handler } from "test/unit/invariant/Handler.t.sol";

contract Invariant is StdInvariant, Test {
    // a pool has 2 assets
    ERC20Mock public poolToken;
    ERC20Mock public weth;

    Handler public handler;

    // we are gonna need the contract
    PoolFactory public factory;
    TSwapPool public pool; // the pool we are testing (poolToken, weth)

    int256 constant STARTING_X = 100e18; // poolTokens
    int256 constant STARTING_Y = 50e18; // weth

    function setUp() public {
        weth = new ERC20Mock();
        poolToken = new ERC20Mock();
        factory = new PoolFactory(address(weth));
        pool = TSwapPool(factory.createPool(address(poolToken)));

        // create initial x and y balances for the pool
        poolToken.mint(address(this), uint256(STARTING_X));
        weth.mint(address(this), uint256(STARTING_Y));
        poolToken.approve(address(pool), type(uint256).max);
        weth.approve(address(pool), type(uint256).max);
        pool.deposit(uint256(STARTING_Y), uint256(STARTING_Y), uint256(STARTING_X), uint64(block.timestamp));

        handler = new Handler(pool);
        bytes4[] memory selectors = new bytes4[](2);
        selectors[0] = handler.deposit.selector;
        selectors[1] = handler.swapPoolTokenForWethBasedOnOutputWeth.selector;

        targetSelector(FuzzSelector({ addr: address(handler), selectors: selectors }));
        targetContract(address(handler));
    }

    function statefulFuzz_constantProductFormulaStaysTheSame() public {
        // assert ?????
        // The change in the poolsize of weth should follow this function
        // Δx = (β/(1-β)) * x
        // In a handler
        // Actual delta X == Δx = (β/(1-β)) * x
        assertEq(handler.expectedDeltaY(), handler.actualDeltaX());
    }
}
