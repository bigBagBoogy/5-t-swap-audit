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

**Description**

**Impact:**

**Proof of Concept**

**Recommended Mitigation**

**Informationals**

### [I-1] `PoolFactory::PoolFactory__PoolDoesNotExist` is not used and should be removed

```diff
-     error PoolFactory__PoolDoesNotExist(address tokenAddress);
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
