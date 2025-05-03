// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {RealEstateNFTCollection} from "../src/RealEstateNFTCollection.sol";

contract RealEstateNFTCollectionTest is Test {
    RealEstateNFTCollectionTest public realEstateNFTCol;

    function setUp() public {
        realEstateNFTCol = new RealEstateNFTCollectionTest();
    }

    function test_Increment() public {
        // realEstateNFTCol.increment();
        // assertEq(counter.number(), 1);
    }

}
