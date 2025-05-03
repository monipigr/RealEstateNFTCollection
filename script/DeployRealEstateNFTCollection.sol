// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";

contract DeployRealEstateNFTCollection is Script {
    RealEstateNFTCollection public realEstateNFTCol;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        realEstateNFTCol = new RealEstateNFTCollection();

        vm.stopBroadcast();
    }
}
