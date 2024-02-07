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
 * address(0) always has zero balance.
 *
 * To run, execute the following command in terminal:
 * 
 * certoraRun ERC20.sol --verify ERC20:ERC20.spec
 */

 methods
 {
    function balanceOf(address) external returns (uint) envfree;
 }

 rule address0AlwaysHasZeroBalance(method f) {

    // Precondition
    require balanceOf(0) == 0;

    mathint address0_before = balanceOf(0);

    env e;  // The env for f
    calldataarg args;  // Any possible arguments for f
    f(e, args);  // Calling the contract method f

    mathint address0_after = balanceOf(0);

       // Operations on mathints can never overflow nor underflow
    assert address0_before == address0_after,
        "balance of address 0 is not zero";
 }