// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import { Test, console } from "forge-std/Test.sol";
import { StdInvariant } from "forge-std/StdInvariant.sol";

contract Invariant2 is StdInvariant, Test {
    function setUp() public {
        console.log("test");
    }
}
