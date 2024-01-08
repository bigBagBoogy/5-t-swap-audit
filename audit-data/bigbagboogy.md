# git:

git init
git add .
git commit -m "natspec 2nd invariant"
git push origin main

### more git

to view commit history in github, click on the clock icon "commits"

git remote set-url origin < url >

### I switched to 'detached HEAD' state.

`git checkout 7d<***   commit   hash   ***   k>6`
M .gitignore
Note: switching to '7d<***   commit   hash   ***   k>6'.

You are in 'detached HEAD' state. You can look around, make experimental
changes and commit them, and you can discard any commits you make in this
state without impacting any branches by switching back to a branch.

If you want to create a new branch to retain commits you create, you may
do so (now or later) by using -c with the switch command. Example:

`git switch -c <new-branch-name>`

### where am I? _git_

If you are on branch main (see this with:  ``` git branch```) and you want to know the
hash of main, type: ```git log -n 1 main```

### type: ```git show main```    for the following info:
commit 91132936cb09ef9bf82f38ab1106346e2ad60f91 (HEAD -> main, origin/main, origin/HEAD)
Author: Equious <76449140+Equious@users.noreply.github.com>
Date:   Thu Dec 28 02:08:32 2023 -0700

    Update README.md

diff --git a/README.md b/README.md
index 1cd52cd..a17ab3d 100644
--- a/README.md
+++ b/README.md
@@ -43,10 +43,10 @@ Secure your crypto assets, such as ETH, WBTC, ARB, LINK, & PAXG tokenized gold,
 
 All contracts at commit `7c9f84772eacb588c00a2add9f46aa93211a7132`
 
-- [SmartVaultV3](https://github.com/the-standard/cyfrin-audit/blob/7c9f84772eacb588c00a2add9f46aa93211a7132/contracts/SmartVaultV3.sol)
-- [SmartVaultManagerV5](https://github.com/the-standard/cyfrin-audit/blob/7c9f84772eacb588c00a2add9f46aa93211a7132/contracts/SmartVaultManagerV5.sol)
-- [LiquidationPool](https://github.com/the-standard/cyfrin-audit/blob/7c9f84772eacb588c00a2add9f46aa93211a7132/contracts/LiquidationPool.sol)
-- [LiquidationPoolManager](https://github.com/the-standard/cyfrin-audit/blob/7c9f84772eacb588c00a2add9f46aa93211a7132/contracts/LiquidationPoolManager.sol)
+- [SmartVaultV3]
+- [SmartVaultManagerV5]
+- [LiquidationPool]
+- [LiquidationPoolManager]
 

# start

Finding the main entry point for the protocol / contract



### so I did: `git switch -c passwordstore-audit --->  Switched to a new branch passwordstore-audit'`

Or undo this operation with:

git switch -

Turn off this advice by setting config variable advice.detachedHead to false

HEAD is now at 7d55682 removed audits

### end of git

# Tools tooling:

_solidity-metrics_

1. Right-click file you wish to see metrics on.
2. choose `solidity-metrics`
3. optionally you can export the report by opening the command palette and typing `export`

_Aderyn_ to run:   `adeyn .`
_Slither_ to run:    `slither .`

alternatively, to run slither and ignore dependancies: `slither . --exclude-dependencies`



_Solidity Visual Developer_ (highlighting variables) shows the type of variable (state)
enable / disable (I have turn this off by default)

_sc minimised_ code examples of exploitable contracts:
https://github.com/Cyfrin/sc-exploits-minimized

## onboarding:

`forge build`
`forge test`
`forge coverage`

# the rekt Test:

### The Rekt Test Questions:

Do you have all actors, roles, and privileges documented?
Do you keep documentation of all the external services, contracts, and oracles you rely on?
Do you have a written and tested incident response plan?
Do you document the best ways to attack your system?
Do you perform identity verification and background checks on all employees?
Do you have a team member with security defined in their role?
Do you require hardware security keys for production systems?
Does your key management system require multiple humans and physical steps?
Do you define key invariants for your system and test them on every commit?
Do you use the best automated tools to discover security issues in your code?
Do you undergo external audits and maintain a vulnerability disclosure or bug bounty program?
Have you considered and mitigated avenues for abusing users of your system?

More detailed explanation on rekt test:
https://medium.com/immunefi/the-rekt-test-9834fc7467fb

### Minimal onboarding questions (cyfrin)

https://github.com/Cyfrin/security-and-auditing-full-course-s23/blob/main/minimal-onboarding-questions.md

## CLOC (Count Lines Of Code) (tool)

use for example: `cloc src/PasswordStore.sol` to view the lines of code in PasswordStore.sol

# salt

In blockchain smart contracts, "salt" typically refers to a random value that is used to enhance the security of certain cryptographic operations, especially in the context of creating unique hash values. One common use of salt is in the process of hashing passwords to prevent rainbow table attacks.

A rainbow table attack is a type of precomputed attack on password hashes. It's a method used by attackers to crack hashed passwords more efficiently than traditional brute-force attacks. The concept involves creating a large table (the "rainbow table") that contains precomputed hash values for a vast number of possible plaintext inputs, such as passwords. The idea is to look up the hash of the target password in the table to find the corresponding plaintext password.

Here's a simplified overview of how `rainbow table attacks` work:

Hashing and Reduction Functions: The attacker starts by creating a table of precomputed hash values. This table is generated by applying a cryptographic hash function repeatedly, often using a series of reduction functions to create new inputs for subsequent hash operations.

Chain Generation: The attacker creates chains of hashed values by repeatedly applying the hash and reduction functions. Each chain starts with a randomly chosen plaintext value.

Table Storage: The endpoint of each chain (the final hash in the sequence) is stored in the rainbow table, along with the starting plaintext value.

Attack: When the attacker obtains a hashed password (e.g., from a compromised database), they can look up the hash in the rainbow table. If a match is found, the corresponding plaintext from the chain is the password.

# Proof of Code

### reading from storage to show that private variables are not private

1. Run Anvil chain
2. Use the contract addres:
   run: `cast storage 0x5FbDB2315678afecb367f032d93F642f64180aa3`

output:
| Name | Type | Slot | Offset | Bytes | Value | Hex Value | Contract |
|------------|---------|------|--------|-------|-------------------------------------------------------------------------------|--------------------------------------------------------------------|-------------------------------------|
| s_owner | address | 0 | 0 | 20 | 1390849295786071768276380950238675083608645509734 | 0x000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb92266 | src/PasswordStore.sol:PasswordStore |
| s_password | string | 1 | 0 | 32 | 49516443757395204518384437876896412918898210405993719258753982441762571943956 | 0x6d7950617373776f726400000000000000000000000000000000000000000014 | src/PasswordStore.sol:PasswordStore |

### _or run:_

cast storage 0x5FbDB2315678afecb367f032d93F642f64180aa3 1 --rpc-url http://127.0.0.1:8545
to target storage slot 1 specifically. This gives output:
0x6d7950617373776f726400000000000000000000000000000000000000000014
This is the hex representation of the stored password.

To decode this, run in CLI:
`cast parse-bytes32-string 0x6d7950617373776f726400000000000000000000000000000000000000000014`

output: _myPassword_

# Severity rating:

Impact:  
Likelyhood:
Severity:

https://docs.codehawks.com/hawks-auditors/how-to-evaluate-a-finding-severity

# findings report:

chatGpt 3.5 prompt\*\*\*:

The following is a markdown write up of a finding in a smart contract codebase,
can you help me make sureit is grammatically correct, and formatted nicely?

\*\*\* does not work most of the time...

### Make the findings report into a PDF

https://github.com/Cyfrin/audit-report-templating


0. Get the template for the report from: https://raw.githubusercontent.com/Cyfrin/audit-report-templating/main/report-example.md
0a. -->  report-example.md  --> copy RAW into a _NEW_ markdown file like report.md
1. Add all your findings this _NEW_ markdown file.
   i. Amend all placeholder data to match the data from your findings
2. Install pandoc & LaTeX
3. Download eisvogel.latex and add to your templates directory (should be ~/.pandoc/templates/)
5. Add your logo to the directory as a pdf named logo.pdf
6. Your report.md seems to need to be in `root`
7. Run this command:
   `pandoc report.md -o report.pdf --from markdown --template=eisvogel --listings`


## FAQ:

Certain characters like ⠆ do not work with pandoc, and you'll need to remove them to generate your final report.


# copy the report to your downloads folder in windows

with CLI command:  ```cp report.pdf /mnt/c/Users/pc/Downloads/```

make sure you're in the correct directory in VScode and type the exact file to copy...




# Working in HardHat

add ```require('solidity-coverage');```  to hardhat.config.js
run ```npx hardhat coverage```


# DoS 
Look for "for loops" where the "thing" that is iterated over, is not "bounded"
It it is not bounded to a particular size, can a user just add an arbitrarily 
amount of items to that list.
How much does it cost the user to do that?
If a user can do that and add a nearly infinite amount of things to that list
very cheaply, then you might have a critical or high vulnerability

Look for external calls (a call from the protocol to an external contact (wallet contract))
and see how this cal may fail. If you'd have a liquidate function that sends a remainder
of funds to the liquidated user, but the user ha set his contract/wallet up to NOT
receive crypto, the liquidate function will revert, preventing the liquidation.

### External function calls may fail if:

#1 Sending ether to a contract that does not accept it
#2 Calling a function that does not exist
#3 The external call execution runs out of gas
#4 Third-party contract is simply malicious


# Reentracy

CEI is not always a clear opening to a reentracy attack.

I found there is a distinct difference in the mechanics of `transfer` and/or `call`

```javascript
    function withdrawBalance() public {
        uint256 balance = userBalance[msg.sender];
      // using transfer:
        payable(msg.sender).transfer(balance);
          // State change
        userBalance[msg.sender] -= balance;    
    }

 ```
### using `call` will be more vulnerable it seems:

```javascript
    function withdrawBalance() public {
        uint256 balance = userBalance[msg.sender];
        (bool success,) = msg.sender.call{value: balance}("");
        if (!success) {
            revert();
        }
        // State change
        userBalance[msg.sender] = 0;
    }
```

## ```.transfer``` vs ```call``` vs ```.sendValue```
## .transfer Method:

- The .transfer method is a higher-level convenience function in Solidity for sending Ether. It is commonly used for simple Ether transfers and is meant to be a safer alternative to direct send calls.
- It is specifically designed for sending Ether and includes a limited amount of gas (2,300 gas) to prevent reentrant attacks by limiting the gas available for the recipient to execute arbitrary code.

### while .transfer provides some level of protection by limiting the gas available for external calls, it doesn't eliminate all reentrancy vulnerabilities.

## call method:

- The call method is a more flexible and lower-level way to make external function calls, including sending Ether. It allows you to specify the amount of gas to be sent along with the call.
- When using call to send Ether, you have greater control over the gas parameters, and you can specify a custom gas limit for the execution of the recipient's code.
This flexibility allows for more advanced use cases and is often used when interacting with contracts that may have specific gas requirements.

## sendValue method:
 Very similar to `.transfer`. The most notable difference is that .sendValue returns a boolean value indicating the success or failure of the Ether transfer. This return value can be used to handle failure scenarios more explicitly.
 example:
 ```javascript
bool success = Address.sendValue(payable(msg.sender), amount);
require(success, "Ether transfer failed");
```

# Athrimatic errors

Example of overflow: `uint64 collectedFees` How much until this overflows?
to find out you can do:  `chisel`
`type(uint64).max`
output:      Decimal: 18446744073709551615
this is 18e18, so 19 eth will overflow!
18000000000000000000

# mishandling of ETH
```javascript
        require(address(this).balance == uint256(totalFees), "PuppyRaffle: There are currently players active!");
```
This type of strict requires will make the protocol vunerable to DoS / mishandling of Eth
If someone forces eth into this contract using `selfDestruct` then
```address(this).balance !== uint256(totalFees)``` and you won't be able to withdraw.

### sushi swap mishandling of msg.value:
https://samczsun.com/two-rights-might-make-a-wrong/

The below function from the sushi swap proltocol, allows for executing multiple
(auction) handlings/biddings, but within this function, msg.value is persisted.
Meaning one could but his 1 eth at multiple objects at once.

```javascript
function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
        successes = new bool[](calls.length);
        results = new bytes[](calls.length);
        for (uint256 i = 0; i < calls.length; i++) {
            (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
            require(success || !revertOnFail, _getRevertMsg(result));
            successes[i] = success;
            results[i] = result;
        }
    }
```
# Slither INFO:Detectors:

PuppyRaffle.withdrawFees() (src/PuppyRaffle.sol#159-165) sends eth to arbitrary user
        Dangerous calls:
        - (success) = feeAddress.call{value: feesToWithdraw}() (src/PuppyRaffle.sol#163)
Reference: https://github.com/crytic/slither/wiki/Detector-Documentation#functions-that-send-ether-to-arbitrary-destinations

Above message I saw also in competitive audit of "The Standard".
The combination with an unprotected `set` function can be critical.

### Exploit Scenario:
```javascript
contract ArbitrarySendEth{
    address destination;
    function setDestination(){
        destination = msg.sender;
    }

    function withdraw() public{
        destination.transfer(this.balance);
    }
}
```
In the case of `PuppyRaffle::changeFeeAddress` it has `onlyOwner` so it should be fine.
Don't overlook that appart from the owner also the _constructor_ can set the feeAddress. 
This might be an issue in proxy contracts that initialize wrong. 
think: _"I think I killed it"_


# gas

When using `something.length` in a loop, we're actually reading from storage every time.
This can be very gas expensive if the array is big.
In this case you better cache this:

```javascript
  function getActivePlayerIndex(address player) external view returns (uint256) {
   uint256 playerLength = players.length; // read from storage once
        for (uint256 i = 0; i < playerLength; i++) {
            if (players[i] == player) {
                return i;
            }
 ```
 ##            