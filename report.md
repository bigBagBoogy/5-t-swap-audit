---
title: Tswap Audit Report
author: Segurigor.io
date: March 7, 2023
header-includes:
  - \usepackage{titling}
  - \usepackage{graphicx}
---

\begin{titlepage}
\centering
\begin{figure}[h]
\centering
\includegraphics[width=0.5\textwidth]{logo.pdf}
\end{figure}
\vspace\*{2cm}
{\Huge\bfseries Protocol Audit Report\par}
\vspace{1cm}
{\Large Version 1.0\par}
\vspace{2cm}
{\Large\itshape segurigor.io\par}
\vfill
{\large \today\par}
\end{titlepage}

\maketitle

<!-- Your report starts here! -->

Prepared by: [Segurigor](https://Segurigor.io)
Lead Auditors:

- xxxxxxx

# Table of Contents

- [Table of Contents](#table-of-contents)
- [Protocol Summary](#protocol-summary)
- [Disclaimer](#disclaimer)
- [Risk Classification](#risk-classification)
  - [Files Summary](#files-summary)
  - [Files Details](#files-details)
  - [Issue Summary](#issue-summary)
- [High](#high)
    - [\[H-1\] `TSwapPool::getInputAmountBasedOnOutput` Calulation for fees is incorrect. Fees end up waaay too high.](#h-1-tswappoolgetinputamountbasedonoutput-calulation-for-fees-is-incorrect-fees-end-up-waaay-too-high)
    - [\[H-2\] No slippage protection! `TSwapPool::swapExactOutput`.](#h-2-no-slippage-protection-tswappoolswapexactoutput)
    - [\[H-3\] `TSwapPool::swap` the extra tokens given to users after every `swapCount` breaks the protocol invariant of `x * y = k`](#h-3-tswappoolswap-the-extra-tokens-given-to-users-after-every-swapcount-breaks-the-protocol-invariant-of-x--y--k)
  - [MEDIUM](#medium)
    - [\[M-1\] `TSwapPool::deposit` is missing deadline check causing transactions to complete even after deadline.](#m-1-tswappooldeposit-is-missing-deadline-check-causing-transactions-to-complete-even-after-deadline)
    - [\[M-2\] Rebase, fee-on-transfer and ERC777 tokens break protocol invariant](#m-2-rebase-fee-on-transfer-and-erc777-tokens-break-protocol-invariant)
  - [LOW](#low)
    - [\[L-1\] `TSwapPool::LiquidityAdded` event has parameters out of order, causing the event to emit wrong information](#l-1-tswappoolliquidityadded-event-has-parameters-out-of-order-causing-the-event-to-emit-wrong-information)
  - [Informationals](#informationals)
    - [\[I-1\] `PoolFactory::PoolFactory__PoolDoesNotExist` is not used and should be removed](#i-1-poolfactorypoolfactory__pooldoesnotexist-is-not-used-and-should-be-removed)
    - [\[I-2\] `PoolFactory::constructor` wethToken is lacking zero address check.](#i-2-poolfactoryconstructor-wethtoken-is-lacking-zero-address-check)
    - [\[I-3\] `PoolFactory::createPool` should use `symbol()` in stead of `name()`](#i-3-poolfactorycreatepool-should-use-symbol-in-stead-of-name)

# Protocol Summary

The TSwap protocol accrues fees from users who make swaps. Every swap has a `0.3` fee, represented in `getInputAmountBasedOnOutput` and `getOutputAmountBasedOnInput`. Each applies a `997` out of `1000` multiplier. That fee stays in the protocol.

When you deposit tokens into the protocol, you are rewarded with an LP token. You'll notice `TSwapPool` inherits the `ERC20` contract. This is because the `TSwapPool` gives out an ERC20 when Liquidity Providers (LP)s deposit tokens. This represents their share of the pool, how much they put in. When users swap funds, 0.03% of the swap stays in the pool, netting LPs a small profit.

# Disclaimer

The Segurigor team makes all effort to find as many vulnerabilities in the code in the given time period, but holds no responsibilities for the findings provided in this document. A security audit by the team is not an endorsement of the underlying business or product. The audit was time-boxed and the review of the code was solely on the security aspects of the Solidity implementation of the contracts.

# Risk Classification

|            |        | Impact |        |     |
| ---------- | ------ | ------ | ------ | --- |
|            |        | High   | Medium | Low |
|            | High   | H      | H/M    | M   |
| Likelihood | Medium | H/M    | M      | M/L |
|            | Low    | M      | M/L    | L   |

We use the [CodeHawks](https://docs.codehawks.com/hawks-auditors/how-to-evaluate-a-finding-severity) severity matrix to determine severity. See the documentation for more details.


## Files Summary

| Key | Value |
| --- | --- |
| .sol Files | 2 |
| Total nSLOC | 56 |


## Files Details

| Filepath | nSLOC |
| --- | --- |
| src/PoolFactory.sol | 6 |
| src/TSwapPool.sol | 50 |
| **Total** | **56** |


## Issue Summary

| Severity | Number of issues found |
| -------- | ---------------------- |
| High     | 3                     |
| Medium   | 2                      |
| Low      | 1                      |
| Info     | 3                      |
| Total    | 9                      |




# High

### [H-1] `TSwapPool::getInputAmountBasedOnOutput` Calulation for fees is incorrect. Fees end up waaay too high.

### [H-2] No slippage protection! `TSwapPool::swapExactOutput`. 

**description** The `swapExactOutput` function doen not offer any slippage protection.
You can't just walk up to a protocol and say; "Here's 10 Weth, give me whatever amount of DAI I can get" This will leave you open to MEV attacks and price oracle manipulation.

**impact** causes users to potentially receive way fewer tokens.
An MEV attack can explode this vulnerability to clitical.

### [H-3] `TSwapPool::swap` the extra tokens given to users after every `swapCount` breaks the protocol invariant of `x * y = k`

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
    // -> emit log_named_int(key: "      Left", val: -1100000000000000000 [-1.1e18])
    // -> emit log_named_int(key: "     Right", val: -100000000000000000 [-1e17])

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

### [M-2] Rebase, fee-on-transfer and ERC777 tokens break protocol invariant

**Description** These tokens have a weird "baked-in" functionality that breaks our protocol
The fee on transfer in this case with the liquidityTokens, pays out so much that the 
x * y = k formula breaks.

## LOW

### [L-1] `TSwapPool::LiquidityAdded` event has parameters out of order, causing the event to emit wrong information

**Description:** When the `LiquidityAdded` event is emitted in the `TSwapPool::_addLiquidityMintAndTransfer` function it logs values in an incorrect order. The `poolTokensToDeposit` value should go in the third parameter position, whereas the `wethToDeposit` value should go second.

```diff
-   emit LiquidityAdded(msg.sender, poolTokensToDeposit, wethToDeposit);
+   emit LiquidityAdded(msg.sender, wethToDeposit, poolTokensToDeposit);
```





## Informationals



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

### [I-3] `PoolFactory::createPool` should use `symbol()` in stead of `name()`
```diff  
-             string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).name());
+             string memory liquidityTokenSymbol = string.concat("ts", IERC20(tokenAddress).symbol());
  ```



