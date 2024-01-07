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
