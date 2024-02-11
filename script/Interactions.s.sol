// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import {Script} from "forge-std/Script.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";
import {BasicNft} from "../src/BasicNft.sol";
import {MoodNft} from "../src/MoodNft.sol";

// lib/foundry-devsecops/src/DevOpsTools.sol

contract MintBasicNft is Script {
    string public constant PUG =
        "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";

    function run() external {
        address mostRecentlyDeployed = 0x47b6BB1038b025b7Ba6E410b84769e61E1C249bF;
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        BasicNft(contractAddress).mintNft(PUG);
        vm.stopBroadcast();
    }
}

contract MintMoodNft is Script {
    function run() external {
        address mostRecentlyDeployed = 0x216968a12FCc29ebD0B23eb5D8A519b10d8CD1DB;
        mintNftOnContract(mostRecentlyDeployed);
    }

    function mintNftOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).mintNft();
        vm.stopBroadcast();
    }
}

contract FlippingMoodNft is Script {
    function run() external {
        address mostRecentlyDeployed = 0x216968a12FCc29ebD0B23eb5D8A519b10d8CD1DB;
        flipMoodOnContract(mostRecentlyDeployed);
    }

    function flipMoodOnContract(address contractAddress) public {
        vm.startBroadcast();
        MoodNft(contractAddress).flipMood(0);
        vm.stopBroadcast();
    }
}
