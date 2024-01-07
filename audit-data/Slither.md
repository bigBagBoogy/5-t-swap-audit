## 1:

- `PoolFactory.s_pools` (src/PoolFactory.sol#28) is never initialized. It is used in:
  - `PoolFactory.createPool(address)` (src/PoolFactory.sol#48-59)
  - `PoolFactory.getPool(address)` (src/PoolFactory.sol#64-66)

- `PoolFactory.s_tokens` (src/PoolFactory.sol#29) is never initialized. It is used in:
  - `PoolFactory.getToken(address)` (src/PoolFactory.sol#68-70)

Reference: [Uninitialized State Variables](https://github.com/crytic/slither/wiki/Detector-Documentation#uninitialized-state-variables)

## 2:

- `PoolFactory.constructor(address).wethToken` (src/PoolFactory.sol#41) lacks a zero-check on:
  - `i_wethToken = wethToken` (src/PoolFactory.sol#42)

Reference: [Missing Zero-Address Validation](https://github.com/crytic/slither/wiki/Detector-Documentation#missing-zero-address-validation)

## 3:

- Reentrancy in `TSwapPool._swap(IERC20,uint256,IERC20,uint256)` (src/TSwapPool.sol#342-356):
  - External calls:
    - `outputToken.safeTransfer(msg.sender,1_000_000_000_000_000_000)` (src/TSwapPool.sol#350)
  - Event emitted after the call(s):
    - `Swap(msg.sender,inputToken,inputAmount,outputToken,outputAmount)` (src/TSwapPool.sol#352)

Reference: [Reentrancy Vulnerabilities](https://github.com/crytic/slither/wiki/Detector-Documentation#reentrancy-vulnerabilities-3)

## 4:

- Different versions of Solidity are used:
  - Version used: ['0.8.20', '>=0.6.2', '^0.8.20']
  - `0.8.20` (src/PoolFactory.sol#15)
  - `0.8.20` (src/TSwapPool.sol#15)
  - `>=0.6.2` (lib/forge-std/src/interfaces/IERC20.sol#2)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/interfaces/draft-IERC6093.sol#3)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Permit.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/utils/Address.sol#4)
  - `^0.8.20` (lib/openzeppelin-contracts/contracts/utils/Context.sol#4)

Reference: [Different Pragma Directives](https://github.com/crytic/slither/wiki/Detector-Documentation#different-pragma-directives-are-used)

INFO:Slither:. analyzed (13 contracts with 90 detectors), 5 result(s) found
