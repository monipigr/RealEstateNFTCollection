// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract RealEstateNFTCollection is ERC721, AccessControl {
    using Strings for uint256;

    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant TENANT_ROLE = keccak256("TENANT_ROLE");

    uint256 public currentPropertyId;
    string public baseUri;

    uint256 public mintFee;
    uint256 public collectedFees;

    struct Property {
        uint256 propertyId;
        uint256 propertyValue;
        uint256 squareMeters;
        string image;
        bool hasPool;
    }

    mapping(address => Property[]) public userProperties;

    event MintProperty(address indexed userAddress_, uint256 indexed propertyId_);
    event FeesWithdrawn(address indexed to, uint256 amount);
    event BurnProperty(address indexed userAddress_, uint256 indexed propertyId_);


    constructor(string memory name_, string memory symbol_, uint256 mintFee_, string memory baseUri_) ERC721(name_, symbol_) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(OWNER_ROLE, msg.sender);
        mintFee = mintFee_;
        baseUri = baseUri_;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    /// @notice Mints a new property NFT and stores its metadata. Calculates and collects the minting fee, and emits an event.
    /// @param propertyValue_ Market value of the property in wei
    /// @param propertySquareMeters_ Total surface of the property in square meters
    /// @param image_ URI string pointing to the property image (e.g. IPFS)
    /// @param hasPool_ Whether the property has a pool (true/false)
    function mintProperty(uint256 propertyValue_, uint256 propertySquareMeters_, string memory image_, bool hasPool_) external payable {
        uint256 mintedFee =  (propertyValue_ * mintFee) / 100;
        require(msg.value >= mintedFee, "Insufficient fee");
        collectedFees += msg.value;

        _safeMint(msg.sender, currentPropertyId);

        uint256 id = currentPropertyId;
        currentPropertyId++;

        Property memory propertyMinted = Property({
            propertyId: id,
            propertyValue: propertyValue_,
            squareMeters: propertySquareMeters_,
            image: image_,
            hasPool: hasPool_
        });
        userProperties[msg.sender].push(propertyMinted);

        emit MintProperty(msg.sender, id);
    }

    /// @notice Should allow only owner role to withdraw collected fees
    function withdrawFees() external onlyRole(OWNER_ROLE) {
        uint256 amount = collectedFees;
        collectedFees = 0;

        (bool sent, ) = msg.sender.call{value: amount}("");
        require(sent, "Transfer failed");

        emit FeesWithdrawn(msg.sender, amount);
    }

    /// @notice Burns a property token if the caller owns it and has TENANT_ROLE
    /// @param tokenId The ID of the property NFT to be burned
    function burnProperty(uint256 tokenId) external onlyRole(TENANT_ROLE) {
        require(ownerOf(tokenId) == msg.sender, "Not the property owner");

        _burn(tokenId);
        
        Property[] storage properties = userProperties[msg.sender];
        for (uint256 i = 0; i < properties.length; i++) {
            if (properties[i].propertyId == tokenId) {
                properties[i] = properties[properties.length - 1];
                properties.pop();
                break;
            }
        }

        emit BurnProperty(msg.sender, tokenId);
    }

    /// @notice Allow the owner to update the minting fee as a percentage
    /// @param newMintFee_ New mint fee percentage (in whole numbers)
    function setMintFee(uint256 newMintFee_) external onlyRole(OWNER_ROLE) {
        mintFee = newMintFee_;
    }

    function _baseURI() internal override view virtual returns (string memory) {
        return baseUri;
    }

    function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }


}
