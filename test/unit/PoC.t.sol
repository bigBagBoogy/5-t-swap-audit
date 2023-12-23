// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "../../src/PoolFactory.sol";
import { ERC20Mock } from "@openzeppelin/contracts/mocks/token/ERC20Mock.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

contract PoC is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    address liquidityProvider = makeAddr("liquidityProvider");
    address user = makeAddr("user");

    function setUp() public {
        pool = new TSwapPool(address(poolToken), address(weth), "LTokenA", "LA");
        weth = ERC20Mock(pool.getWeth());
        poolToken = ERC20Mock(pool.getPoolToken());
    }

    // The calculation of fees  that are too high is incorrectly benefitting
    // the liquidity provider.
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

    function testTooHighFeesInFunction() public {
        uint256 initialLiquidity = 100e18;
        vm.statPrank(liquidityProvider);
        weth.approve(address(pool), initialLiquidity);
        poolToken.approve(address(pool), initialLiquidity);

        pool.deposit({
            wethToDeposit: initialLiquidity,    
            minimumLiquidityTokensToMint: 0,
            maximumPoolTokensToDeposit: initialLiquidity,
            deadline: uint64(block.timestamp)}
        );
        vm.stopPrank();

        // user has 11 pool tokens
        address someUser = makeAddr("someUser");
        uint256 userInitialPoolTokenBalance = 11e18;
        poolToken.mint(someUser, userInitialPoolTokenBalance);
        vm.startPrank(someUser);

        // User buys 1 weth from
        // Initial liquidity was 1:1 so user should have paid 1~ pool token
        // However, it spent much more than that.
        assertLt(poolToken.balanceOf(someUser), 1 ether);
        vm.stopPrank;

        // The liquidity provider can rug all funds from the pool now,
        // including those deposited by the user
        vm.startPrank(liquidityProvider);
        pool.withdraw({
            poolToken.balanceOf(liquidityProvider),
            minimumWethToReceive: 0,
            maximumLiquidityToReceive: 0,
            deadline: uint64(block.timestamp)}
        );
        vm.stopPrank();


      

}
