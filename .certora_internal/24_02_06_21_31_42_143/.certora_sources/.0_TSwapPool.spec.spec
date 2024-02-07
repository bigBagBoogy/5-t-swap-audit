// @spec: TSwapPool__InvalidToken error should throw
// invariant: cannot swap with invalid token
// swapExactInput calls private function _swap, which internally checks for 
// a valid token, so we'll target swapExactInput.
// methods {
//     function swapExactInput(
//         e,
//         IERC20 inputToken,
//         uint256 inputAmount,
//         IERC20 outputToken,
//         uint256 minOutputAmount,
//         uint64 deadline
//     ) public returns (uint256);
//     function _isUnknown(IERC20 token) private view returns (bool) 
// }
//  rule cannotSwapInvalidToken(IERC20 inputToken,
//         uint256 inputAmount,
//         IERC20 outputToken,
//         uint256 minOutputAmount,
//         uint64 deadline) {
//             env e;
//             bool isUnknown = _isUnknown(IERC20 inputToken); // true means invalid token
//             swapExactInput@withrevert(e, inputToken, inputAmount, outputToken, minOutputAmount, deadline);
//         assert lastReverted;
//         }



// should we want to simplify this rule, we could just focus on:
//  assert !isUnknown <=> outputToken == i_wethToken || outputToken == i_poolToken;

// should we test this parametric? so run all, and see if ever the assertion breaks and why.
// to run from CLI:  certoraRun TSwapPool.sol --verify TSwapPool:TSwapPool.spec --msg "testInvalidToken rule"

methods {
    function _isUnknown(IERC20 token) private view returns (bool)
};

rule testInvalidToken(method f) {
    env e;  // The env for f
    calldataarg args;  // Any possible arguments for f
    f(e, args);  // Calling the contract method f

    assert !isUnknown <=> outputToken == i_wethToken || outputToken == i_poolToken;
}






