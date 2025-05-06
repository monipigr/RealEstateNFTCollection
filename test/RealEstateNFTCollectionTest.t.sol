// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";

contract RealEstateNFTCollectionTest is Test {
    
    RealEstateNFTCollection public realEstateNFTCol;
    uint256 mintFee = 1;
    address user1 = vm.addr(1);
    event MintProperty(address indexed userAddress_, uint256 indexed propertyId_);



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
    function test_mintProperty() external {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        realEstateNFTCol.mintProperty{value: expectedFee}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );
        assertEq(realEstateNFTCol.currentPropertyId(), 1);
        assertEq(realEstateNFTCol.ownerOf(0), user1);
        assertEq(realEstateNFTCol.collectedFees(), expectedFee);

        vm.stopPrank();
    }

    /// @notice Should revert if the fee sent is lower than required
    function test_mintPropertyRevertIfInsufficientFee() external {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        vm.expectRevert("Insufficient fee");
        realEstateNFTCol.mintProperty{value: expectedFee - 1}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );

        vm.stopPrank();
    }

    /// @notice Should accept minting if the fee sent is higher than required
    function test_mintPropertyWithExtraFee() external {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        realEstateNFTCol.mintProperty{value: expectedFee - 1}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );
        assertEq(realEstateNFTCol.currentPropertyId(), 1);
        assertEq(realEstateNFTCol.ownerOf(0), user1);
        assertEq(realEstateNFTCol.collectedFees(), expectedFee);

        vm.stopPrank();
    }

    /// @notice Should emit MintProperty event correctly
    function test_emitMintPropertyEvent() external {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        vm.expectEmit(true, true, false, true);
        emit MintProperty(user1, 0);
        realEstateNFTCol.mintProperty{value: expectedFee}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );

        vm.stopPrank();
    }

    

}
