methods {
    function points(address) external returns uint256  envfree;
    function vote(address,address,address) external;
    function voted(address) external returns bool  envfree;
    function winner() external returns address  envfree;
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