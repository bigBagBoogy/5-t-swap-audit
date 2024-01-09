// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console2 } from "forge-std/Test.sol";
import { TSwapPool } from "src/TSwapPool.sol";
import { ERC20Mock } from "test/mocks/ERC20Mock.sol";

contract Handler is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address liquidityProvider = makeAddr("liquidityProvider");
    address swapper = makeAddr("swapper");

    //ghost variables - they only exist in the Handler
    int256 startingY_weth;
    int256 startingX_poolToken;

    int256 public expectedDeltaY_weth; //  change in toke balances
    int256 public expectedDeltaX_poolToken;

    int256 public actualDeltaY_weth; //  change in toke balances
    int256 public actualDeltaX_poolToken;

    constructor(TSwapPool _pool) {
        pool = _pool;
        weth = ERC20Mock(_pool.getWeth());
        poolToken = ERC20Mock(_pool.getPoolToken());
    }
    // let's start with testing the `deposit` and `swapExactInput` function

    // in deposit we'll use TSwap's function to get the ratio of weth and poolToken
    // to calculate wethToDeposit
    // TSwapPool::getPoolTokensToDepositBasedOnWeth, wethToDeposit =
    // (wethToDeposit * poolTokenReserves) / wethReserves;
    // so if we'd deposit 2 eth to a pool of 100weth/50poolToken,
    // it'd be (20 * 50) / 100 = 10 poolToken

    // in the swap function we'll use a TSwap's function again:
    // TSwapPool::getInputAmountBasedOnOutput with in it the nested `swapExactInput`

    // we're gonna want to at least fuzz test `deposit` and `swapExactInput
    // So in here, `wethAmount` is the amount of weth to deposit, but also delta Y

    // we'll put in poolToken and take out weth
    function swapPoolTokenForWethBasedOnOutputWeth(uint256 outputWeth) public {
        uint256 minWeth = pool.getMinimumWethDepositAmount();
        outputWeth = bound(outputWeth, minWeth, weth.balanceOf(address(pool)));
        // below, poolTokenAmount will be out Delta X
        uint256 poolTokenAmount = pool.getInputAmountBasedOnOutput(
            outputWeth, poolToken.balanceOf(address(pool)), weth.balanceOf(address(pool))
        );
        if (poolTokenAmount > type(uint64).max) {
            return;
        }
        startingY_weth = int256(weth.balanceOf(address(pool)));
        startingX_poolToken = int256(poolToken.balanceOf(address(pool)));
        expectedDeltaY_weth = int256(-1) * int256(outputWeth);
        expectedDeltaX_poolToken = int256(poolTokenAmount);

        if (poolToken.balanceOf(swapper) < poolTokenAmount) {
            poolToken.mint(swapper, poolTokenAmount - poolToken.balanceOf(swapper) + 1);
        }
        vm.startPrank(swapper);
        poolToken.approve(address(pool), type(uint256).max);
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        vm.stopPrank();

        // see what the actual amount is
        uint256 endingY_weth = weth.balanceOf(address(pool));
        uint256 endingX_poolToken = poolToken.balanceOf(address(pool));
        // actual will be ending - starting
        // the outcome of this we'll compare with expected
        actualDeltaY_weth = int256(endingY_weth) - int256(startingY_weth);
        actualDeltaX_poolToken = int256(endingX_poolToken) - int256(startingX_poolToken);
    }

    //
    //
    //
    //
    //   DEPOSIT  //
    //
    //
    //
    //
    function deposit(uint256 wethAmountToDeposit) public {
        if (wethAmountToDeposit == 0) {
            return;
        }
        // let's make sure it's a reasonable amount, avoid weird overflow errors
        uint256 minWeth = pool.getMinimumWethDepositAmount();
        wethAmountToDeposit = bound(wethAmountToDeposit, 1e18, type(uint64).max);

        startingY_weth = int256(weth.balanceOf(address(pool)));
        startingX_poolToken = int256(poolToken.balanceOf(address(pool)));
        expectedDeltaY_weth = int256(wethAmountToDeposit);
        expectedDeltaX_poolToken = int256(pool.getPoolTokensToDepositBasedOnWeth(wethAmountToDeposit));

        // do the deposit
        vm.startPrank(liquidityProvider); // our liquidity provider has no funds yet, so:
        weth.mint(liquidityProvider, wethAmountToDeposit);
        poolToken.mint(liquidityProvider, uint256(expectedDeltaX_poolToken));
        weth.approve(address(pool), type(uint256).max);
        poolToken.approve(address(pool), type(uint256).max);
        pool.deposit(wethAmountToDeposit, 0, uint256(expectedDeltaX_poolToken), uint64(block.timestamp));
        vm.stopPrank();

        // see what the actual amount is
        uint256 endingY_weth = weth.balanceOf(address(pool));
        uint256 endingX_poolToken = poolToken.balanceOf(address(pool));
        // actual will be ending - starting
        // the outcome of this we'll compare with expected
        actualDeltaY_weth = int256(endingY_weth) - int256(startingY_weth);
        actualDeltaX_poolToken = int256(endingX_poolToken) - int256(startingX_poolToken);
    }
}
