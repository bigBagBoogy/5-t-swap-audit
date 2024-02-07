// methods {
//     function isUnknown(address) external returns bool;
//     function inputToken() external returns address;
// }


// rule testInvalidToken(method f) {
//     // Precondition
//     require !isUnknown() <=> inputToken() == i_wethToken() || inputToken() == i_poolToken();

//     env e;
//     calldataarg args;
//     f(e, args);
    
//     assert (
//         !isUnknown() <=> inputToken() == i_wethToken() || inputToken() == i_poolToken(),
//         "foreign token comes into the protocol"
//     );
// }

/**
 * # ERC20 Spec written by bigBagBoogy
 * sellPoolTokensIntegrity: if outputAmount > 0 => inputAmount > 0 
 * This should fail if inputAmount == 0
 *
 * To run, execute the following command in terminal:
 * 
 * certoraRun ERC20.sol --verify ERC20:ERC20.spec
 */

 methods
 {
    function sellPoolTokens(uint256) external returns (uint256); // returns weth amount
    function balanceOf(address) external returns (uint) envfree;
    function getPoolToken() external returns (address) envfree; // gets addr of token.
 }
// line 330
 rule sellPoolTokensIntegrity(method f) {

    address inputToken;
    address outputToken;
    uint outputTokenAmt = balanceOf(outputToken);
    uint inputTokenAmt = balanceOf(inputToken);

    // Precondition  start with nothing
    require balanceOf(outputToken) == 0;
    require balanceOf(inputToken) == 0; // since we start with no inputTokens,
    // no function should change state in such a way that we end up with outputTokens.

    mathint outputToken_before = balanceOf(outputToken);

    env e;  // The env for f
    calldataarg args;  // Any possible arguments for f
    f(e, args);  // Calling the contract method f

    mathint outputToken_after = balanceOf(outputToken);

       // Operations on mathints can never overflow nor underflow
    assert balanceOf(inputToken) == 0 => outputToken_after == 0,
        "error no outputTokens should have been here";
 }


 ///   TODO:   check back on the video about vacuous rules and run a check 
 //  on this test.    https://www.youtube.com/watch?v=csTe6ub3Jwg&list=PLKtu7wuOMP9XHbjAevkw2nL29YMubqEFj&index=10