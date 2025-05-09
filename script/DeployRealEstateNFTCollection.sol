// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";

contract DeployRealEstateNFTCollection is Script {

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        string memory name_ = "Real Estate NFT Collection";
        string memory symbol_ = "RLC";
        uint256 mintFee_ = 1;
        string memory baseUri_ = "ipfs://bafybeifjyapb4dzh2u7ovha22juknejj75tal4srtdef6ci53pbphp5fiy";
        RealEstateNFTCollection realEstateNFTCol = new RealEstateNFTCollection(name_, symbol_, mintFee_, baseUri_);

        vm.stopBroadcast();
    }
}
