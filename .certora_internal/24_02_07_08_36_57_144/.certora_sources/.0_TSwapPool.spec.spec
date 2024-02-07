methods {
    function isUnknown(address) external returns bool;
    function inputToken() external returns address;
}


rule testInvalidToken(method f) {
    // Precondition
    require !isUnknown() <=> inputToken() == i_wethToken() || inputToken() == i_poolToken();

    env e;
    calldataarg args;
    f(e, args);
    
    assert (
        !isUnknown() <=> inputToken() == i_wethToken() || inputToken() == i_poolToken(),
        "foreign token comes into the protocol"
    );
}