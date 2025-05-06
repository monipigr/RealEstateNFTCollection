// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";

contract RealEstateNFTCollectionTest is Test {
    
    RealEstateNFTCollection public realEstateNFTCol;
    address user1 = vm.addr(1);

    function setUp() public {
        string memory name_ = "Real Estate NFT Collection";
        string memory symbol_ = "RLC";
        uint256 mintFee_ = 1;
        string memory baseUri_ = "ipfs://:TODO";
        realEstateNFTCol = new RealEstateNFTCollection(name_, symbol_, mintFee_, baseUri_);
    }

    /// @notice Should deploy the contract and assign a non-zero address
    function test_deployContractCorrectly() public view {
       assert(address(realEstateNFTCol) != address(0));
    }

    /// @notice Should mint the real estate token property correctly
    function test_mint() external {
        vm.startPrank(user1);

        uint256 propertyValue_ = 40; 
        uint256 propertySquareMeters_ = 100; 
        string memory image_ = "ipfs://todouriimage"; 
        bool hasPool_ = true;
        realEstateNFTCol.mintProperty(propertyValue_, propertySquareMeters_, image_, hasPool_);
        assertEq(realEstateNFTCol.currentPropertyId(), 1);
        assertEq(realEstateNFTCol.ownerOf(0), user1);

        vm.stopPrank();
    }

    

}
