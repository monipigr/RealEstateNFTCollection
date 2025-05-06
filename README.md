# 🏠 RealEstateNFTCollection

## 📝 Overview

`RealEstateNFTCollection` is a colección de propiedades inmobiliarias tokenizadas como NFTs.

## ✨ Features

## 🏗 Smart Contract Architecture and Patterns

- **ERC721 Standard**: Inherits OpenZeppelin's robust ERC721 implementation
- **Storage Variables**:
  - `currentTokenId`: tracks next token to mint
  - `totalSupply`: immutable max number of NFTs
  - `baseUri`: used for metadata resolution
- **Core Logic**:
  - `mint()`: mints NFTs sequentially with `_safeMint`, emits `MintNFT` event
  - `tokenURI(uint256)`: returns full metadata URI, combining baseUri and tokenId
- **Security Practices**:
  - Uses `_requireOwned` to prevent querying non-existent token metadata
- **Design Choices**:
  - Public minting with no access control (no `Ownable`)
  - Linear minting logic without metadata reveal or rarity mechanics

## 🛠 Technologies Used

- **Solidity**: `^0.8.24`
- **Framework**: [Foundry](https://book.getfoundry.sh/)
- **OpenZeppelin Contracts**: v4.x ERC721 standard

## 🧪 Testing

Unit tests are written using Foundry to ensure contract reliability:

| **Test Function**                                 | **Description**                |
| ------------------------------------------------- | ------------------------------ |
| `test_RealEstateNFTCollectionCorrectlyDeployed()` | Contract deployment validation |

Tests cover edge cases such as double minting, token existence validation, and proper URI generation.

## 💯 ✅ Full Test Coverage Report

```
forge coverage
```

| File                            | % Lines             | % Statements        | % Branches        | % Funcs           |
| ------------------------------- | ------------------- | ------------------- | ----------------- | ----------------- |
| src/RealEstateNFTCollection.sol | 100.00% (15/15)     | 100.00% (13/13)     | 100.00% (2/2)     | 100.00% (4/4)     |
| **Total**                       | **100.00% (15/15)** | **100.00% (13/13)** | **100.00% (2/2)** | **100.00% (4/4)** |

## 🛠 Technologies Used

- **Solidity**: `^0.8.24`
- **Foundry**: For deploying, testing, fuzzing and assertions
- **OpenZeppelin Contracts**: `ERC721`, `IERC721`
- **Strings**: For converting `uint256` token IDs into strings in `tokenURI`

## 🔧 How to Use

### Prerequisites

- Install [Foundry](https://book.getfoundry.sh/)
- Install [OpenZeppelin](https://docs.openzeppelin)

### 🛠 Setup

```bash
git clone https://github.com/your-username/RealEstateNFTCollection.git
cd RealEstateNFTCollection
forge install
```

### Testing

```bash
forge test
forge --match-test testExample -vvvv
```

## 📜 License

This project is licensed under the MIT License.
