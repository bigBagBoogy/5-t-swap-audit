## HIGH

### [H-1] `TSwapPool::getInputAmountBasedOnOutput` Calulation for fees is incorrect. Fees end up waaay too high.

### [H-5] `TSwapPool::swap` the extra tokens given to users after every `swapCount` breaks the protocol invariant of `x * y = k`

**Description:** The protocol follows a strict invariant of x \* y = k. Where:

- `x`: The balace of the pool token
- `y`: The balance of the Weth token
- `k`: The constant product of the two balances

This means, that whenever the balances change in the protocol, the ratio between the two amounts should remain constant, hence the k. However, this is broken due to the extra incentive in the \_swap function. Meaning that over time the protocol funds will be drained.

```javascript
swap_count++;
if (swap_count >= SWAP_COUNT_MAX) {
  swap_count = 0;
  outputToken.safeTransfer(msg.sender, 1_000_000_000_000_000_000);
}
```

<details>
<summary>Proof of Code</summary>
Paste the followincode into `TSwapPoolTest.t.sol`

```javascript
    function testSwapBreaksInvariant() public {
        vm.startPrank(liquidityProvider);
        weth.approve(address(pool), 100e18);
        poolToken.approve(address(pool), 100e18);
        pool.deposit(100e18, 100e18, 100e18, uint64(block.timestamp));
        vm.stopPrank();

        uint256 outputWeth = 1e17;

        vm.startPrank(user);
        poolToken.approve(address(pool), type(uint256).max);
        poolToken.mint(user, 10e18);
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp)); //5
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        int256 startingY = int256(weth.balanceOf(address(pool)));
        int256 expectedDeltaY = int256(-1) * int256(outputWeth);
        // and then the tenth time:
        pool.swapExactOutput(poolToken, weth, outputWeth, uint64(block.timestamp));
        vm.stopPrank();

        uint256 endingY = weth.balanceOf(address(pool));
        int256 actualDeltaY = int256(endingY) - int256(startingY);
        assertEq(actualDeltaY, expectedDeltaY);
    }
    // output:    emit log(val: "Error: a == b not satisfied [int]")
    // ├─ emit log_named_int(key: "      Left", val: -1100000000000000000 [-1.1e18])
    // ├─ emit log_named_int(key: "     Right", val: -100000000000000000 [-1e17])

```

</details>
**Recommended Mitigation** Remove the extra incentive mechanism. If you want to keep this in, we should account for the change in the x \* y = k protocol invariant. Or, we should set aside tokens in the same way we do with fees.

```diff
-        swap_count++;
-        // Fee-on-transfer
-        if (swap_count >= SWAP_COUNT_MAX) {
-            swap_count = 0;
-            outputToken.safeTransfer(msg.sender, 1_000_000_000_000_000_000);
-        }
```

## MEDIUM

### [M-1] `TSwapPool::deposit` is missing deadline check causing transactions to complete even after deadline.

**Description:** The `deposit` function accepts a deadline parameter, which according to the documentation is for: "The deadline for the transaction to be completed by" However this parameter is never used.
As a consequence, operations that add liquidity that to the pool might be executed at unexpected times. In market conditions, where the deposit rate is unfavorable.

<!-- MEV attacks-->

**Impact:**

**Proof of Concept**

**Recommended Mitigation** Consider making the following chsnges to the function:

```diff
function deposit(
        uint256 wethToDeposit,
        uint256 minimumLiquidityTokensToMint,
        uint256 maximumPoolTokensToDeposit,
        uint64 deadline
    )
        external
    +   revertIfDeadlinePassed(deadline)
        revertIfZero(wethToDeposit)
        returns (uint256 liquidityTokensToMint)
    {
```

**Informationals**

### [s-#] TITLE (root cause + impact)

**Description** the function TSwapPool::sellPoolTokens internally calls swapExactOutput()
This should be: `swapExactInput(minWethToReceive)`

**Impact:**

**Proof of Concept**

**Recommended Mitigation**

**Informationals**

### [I-1] `PoolFactory::PoolFactory__PoolDoesNotExist` is not used and should be removed

```diff
-     error PoolFactory__PoolDoesNotExist(address tokenAddress);
```


### [I-2] `PoolFactory::constructor` wethToken is lacking zero address check.
```diff
        constructor(address wethToken) {
+       if(wethToken == address(0)) {
             revert();
        i_wethToken = IERC20(wethToken);
        }
     }   
```

**Description**

**Impact:**

**Proof of Concept**

**Recommended Mitigation**

## LOW

### [L-1] `TSwapPool::LiquidityAdded` event has parameters out of order, causing the event to emit wrong information

**Description:** When the `LiquidityAdded` event is emitted in the `TSwapPool::_addLiquidityMintAndTransfer` function it logs values in an incorrect order. The `poolTokensToDeposit` value should go in the third parameter position, whereas the `wethToDeposit` value should go second.

```diff
-   emit LiquidityAdded(msg.sender, poolTokensToDeposit, wethToDeposit);
+   emit LiquidityAdded(msg.sender, wethToDeposit, poolTokensToDeposit);
```
