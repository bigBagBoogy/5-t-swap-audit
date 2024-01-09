Straight off the bat we find these compiler warnings:

```bash
Compiler run successful with warnings:
Warning (5667): Unused function parameter. Remove or comment out the variable name to silence this warning.
   --> src/TSwapPool.sol:117:9:
    |
117 |         uint64 deadline
    |         ^^^^^^^^^^^^^^^

Warning (2072): Unused local variable.
   --> src/TSwapPool.sol:131:13:
    |
131 |             uint256 poolTokenReserves = i_poolToken.balanceOf(address(this));
    |             ^^^^^^^^^^^^^^^^^^^^^^^^^

Warning (5667): Unused function parameter. Remove or comment out the variable name to silence this warning.
   --> src/TSwapPool.sol:306:18:
    |
306 |         returns (uint256 output)
    |                  ^^^^^^^^^^^^^^
```

## AMM constant product formula

## x * y = k
Pairs act as automated market makers, standing ready to accept one token for the other as long as the “constant product” formula is preserved. This formula, most simply expressed as x * y = k , states that trades must not change the product ( k ) of a pair's reserve balances ( x and y ).

The constant product formula is a key concept in Automated Market Makers (AMMs), particularly in decentralized exchanges like Uniswap. The formula is used to maintain a constant product of two assets in a liquidity pool, where the product of the quantities of the two assets remains constant.

The general form of the formula is:

## x⋅y=k

Where:


### x is the quantity of one asset in the pool,
### y is the quantity of the other asset in the pool,
### k is the constant product.

In the context of Uniswap, for example, this formula is used for trading between two ERC-20 tokens. Initially, when liquidity is added to the pool, the product of the quantities of the two tokens is calculated, and that product remains constant as trades occur.

When a user wants to swap one token for another, the formula ensures that the product of the quantities of both tokens before and after the trade is the same. The price of one token in terms of the other is determined by the ratio of their quantities in the pool.

For a swap where a user wants to trade Δx of token X for Δy of token Y, the formula becomes:

(x+Δx)⋅(y−Δy)=k

This updated product reflects the new quantities of the tokens after the trade. The Uniswap algorithm then calculates the amounts Δx and Δy based on this formula.

It's important to note that as trades occur, the price of the tokens in the pool can change, and the constant product formula ensures that the market adjusts accordingly. The AMM mechanism allows for decentralized trading without the need for a traditional order book.

## What trips me up in this audit from time to time:
When adding liquidity to the pool through the deposit function, 
there is nothing taken out (it's not a swap).
The Liquidity provider gets minted LP tokens as an "I Owe You"

## the swapping:
Sending in the poolToken and taking WETH out