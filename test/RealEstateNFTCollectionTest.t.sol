// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract RealEstateNFTCollectionTest is Test {
    using Strings for uint256;
    
    RealEstateNFTCollection public realEstateNFTCol;
    string constant BASE_URI = "ipfs://bafybeifjyapb4dzh2u7ovha22juknejj75tal4srtdef6ci53pbphp5fiy/";
    uint256 mintFee = 1;
    address user1 = vm.addr(1);
    address owner = vm.addr(2);
    event MintProperty(address indexed userAddress_, uint256 indexed propertyId_);

    function setUp() public {
        string memory name_ = "Real Estate NFT Collection";
        string memory symbol_ = "RLC";
        uint256 mintFee_ = 1;
        string memory baseUri_ = "ipfs://bafybeifjyapb4dzh2u7ovha22juknejj75tal4srtdef6ci53pbphp5fiy/";
        realEstateNFTCol = new RealEstateNFTCollection(name_, symbol_, mintFee_, baseUri_);
        realEstateNFTCol.grantRole(realEstateNFTCol.OWNER_ROLE(), owner );
        realEstateNFTCol.grantRole(realEstateNFTCol.TENANT_ROLE(), user1 );
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
    function test_mintPropertyWithExtraFee() external payable {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        realEstateNFTCol.mintProperty{value: expectedFee + 1 ether}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );
        assertEq(realEstateNFTCol.currentPropertyId(), 1);
        assertEq(realEstateNFTCol.ownerOf(0), user1);
        assertEq(realEstateNFTCol.collectedFees(), expectedFee + 1 ether);

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

    /// @notice Should allow the owner to withdraw fees 
    function test_withdrawFees_correctly() external {
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

        vm.stopPrank();

        vm.startPrank(owner);
        
        uint256 ownerBalanceBefore = owner.balance;
        uint256 contractBalanceBefore = address(realEstateNFTCol).balance;
        realEstateNFTCol.withdrawFees();
        uint256 ownerBalanceAfter = owner.balance;
        uint256 contractBalanceAfter = address(realEstateNFTCol).balance;

        assertEq(contractBalanceAfter, 0);
        assertEq(ownerBalanceAfter, ownerBalanceBefore + contractBalanceBefore);
        assertEq(contractBalanceAfter, 0);

        vm.stopPrank();
    }

    /// @notice Should revert if a non-owner attempts to withdraw fees
    function test_withdrawFees_revertsIfNotOwner() external {
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
        
        vm.expectRevert();
        realEstateNFTCol.withdrawFees();
        assertEq(realEstateNFTCol.collectedFees(), expectedFee);

        vm.stopPrank();
    }

    /// @notice Should burn successfully the property given by the user
    function test_burnProperty_successfully() external {
        // Mintea la propiedad 
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 tokenId_ = 0;
        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        realEstateNFTCol.mintProperty{value: expectedFee}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );

        assertEq(realEstateNFTCol.ownerOf(tokenId_), user1);

        realEstateNFTCol.burnProperty(tokenId_);

        vm.expectRevert();
        realEstateNFTCol.ownerOf(tokenId_);

        vm.stopPrank();
    }

    /// @notice Should revert if not the owner of that property attempts to burn the property
    function test_burnProperty_revertsIfNotPropertyOwner() external {
        vm.deal(user1, 100 ether);
        vm.startPrank(user1);

        uint256 tokenId_ = 0;
        uint256 propertyValue_ = 40 ether; 
        uint256 expectedFee = (propertyValue_ * realEstateNFTCol.mintFee()) / 100;
        realEstateNFTCol.mintProperty{value: expectedFee}(
            propertyValue_, 
            40, 
            "ipfs://uriimage", 
            true
        );

        assertEq(realEstateNFTCol.ownerOf(tokenId_), user1);

        vm.stopPrank();

        realEstateNFTCol.grantRole(realEstateNFTCol.TENANT_ROLE(), owner);
        vm.startPrank(owner);

        vm.expectRevert("Not the property owner");

        realEstateNFTCol.burnProperty(tokenId_);

        vm.stopPrank();
    }

    /// @notice Should modify the mintFee
    function test_setMintFee() external {
        vm.startPrank(owner);

        uint256 newFee_ = 2;
        realEstateNFTCol.setMintFee(newFee_);
        assertEq(realEstateNFTCol.mintFee(), newFee_);

        vm.stopPrank();
    }

    /// @notice Should revert if not the user attempts to modify the mintFee
    function test_setMintFee_revertsIfNotOwner() external {
        vm.startPrank(user1);

        uint256 newFee_ = 2;
        vm.expectRevert();
        realEstateNFTCol.setMintFee(newFee_);

        vm.stopPrank();
    }

    /// @notice Should correctly generate the tokenURI for token ID 0 after minting
    function test_tokenURI() external {
        uint256 tokenId = 0;

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
        // realEstateNFTCol.mintProperty();
        string memory expectedURI = string.concat(BASE_URI, tokenId.toString(), ".json");
        string memory tokenURI = realEstateNFTCol.tokenURI(0);
        assertEq(tokenURI, expectedURI); 

        vm.stopPrank();
    }

    /// @notice Should revert when querying tokenURI before the token has been minted
    function test_tokenURIRevertsIfTokenNotMinted() external {
        vm.expectRevert();
        realEstateNFTCol.tokenURI(0);
    }

    // /// @notice Should correctly generate the tokenURI for a fuzzing tokenUri
    // function testFuzz_tokenURI(uint256 tokenId) external {

    //     vm.startPrank(user1);

    //     for (uint256 i = 0; i <= tokenId; i++) {
    //         realEstateNFTCol.mint();
    //     }
    //     string memory tokenURIExpected = string.concat(BASE_URI, tokenId.toString(), ".json");
    //     string memory tokenURI = realEstateNFTCol.tokenURI(tokenId);
    //     assertEq(tokenURI, tokenURIExpected); 

    //     vm.stopPrank();
    // }


    

}
