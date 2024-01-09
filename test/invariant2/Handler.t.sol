// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { TSwapPool } from "src/TSwapPool.sol";
import { ERC20Mock } from "test/mocks/ERC20Mock.sol";

contract Handler is Test {
    TSwapPool pool;
    ERC20Mock weth;
    ERC20Mock poolToken;

    constructor(TSwapPool _pool) {
        pool = _pool;
        weth = ERC20Mock(_pool.getWeth());
        poolToken = ERC20Mock(_pool.getPoolToken());
    }

    // we'll use TSwap's function to get the ratio of weth and poolToken
    // to calculate wethToDeposit
    // TSwapPool::getPoolTokensToDepositBasedOnWeth, wethToDeposit =
    // (wethToDeposit * poolTokenReserves) / wethReserves;
    // so if we'd deposit 2 eth to a pool of 100weth/50poolToken,
    // it'd be (20 * 50) / 100 = 10 poolToken

    // we're gonna want to at least fuzz test `deposit` and `swapExactInput`
}
