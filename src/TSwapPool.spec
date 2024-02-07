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
    function sellPoolTokens(uint256) external returns (uint256) // returns weth amount
    function balanceOf(address) external returns (uint) envfree;
    function getPoolToken() external view returns (address) envfree; // gets addr of token.
 }
// line 330
 rule sellPoolTokensIntegrity(method f) {

    // Precondition  start with nothing
    require balanceOf(outputToken) == 0;
    require balanceOf(inputToken) == 0;

    mathint outputToken_before = balanceOf(outputToken);

    env e;  // The env for f
    calldataarg args;  // Any possible arguments for f
    f(e, args);  // Calling the contract method f

    mathint outputToken_after = balanceOf(outputToken);

       // Operations on mathints can never overflow nor underflow
    assert inputToken_after == 0 => outputToken == 0,
        "balance of address 0 is not zero";
 }