# 🏠 RealEstateNFTCollection

## 📝 Overview

`RealEstateNFTCollection` is a fully on-chain, role-based ERC-721 implementation for tokenizing real estate properties as NFTs. Built with Solidity and tested with Foundry, the project supports minting, burning, fee collection, and dynamic token metadata based on property data.

## ✨ Features

- 🏷 **Dynamic Property Minting**
  - Tokenizes properties with user-defined attributes (value, square meters, pool and image).
- 🔗 **Metadata URI Resolution**

  - `tokenURI` returns a dynamic `.json` pointing to IPFS metadata folder.

- 🔐 **Role-Based Access Control**

  - Admin (`OWNER_ROLE`) can withdraw fees and update minting fee.
  - Users (`TENANT_ROLE`) can burn their own property tokens.

- 💸 **Minting Fee System**

  - Minting requires a fee based on property value (e.g. 1%).
  - Fees are accumulated and withdrawable by the contract owner.

- 🗑 **Burn Functionality**

  - Users can burn only their own properties. Metadata mapping is cleaned up.

- 📢 **Event Emissions**
  - Emits `MintProperty`, `BurnProperty`, and `FeesWithdrawn`.

## 🏗 Smart Contract Architecture

- **Standard**: ERC-721 (OpenZeppelin-based)
- **State Variables**:
  - `mintFee` — % of property value.
  - `collectedFees` — balance of fees available for withdrawal.
  - `baseUri` — IPFS URI for metadata resolution.
- **Core Components**:
  - `mintProperty()` — mints property NFTs with fee.
  - `withdrawFees()` — lets `OWNER_ROLE` withdraw accumulated minting fees.
  - `burnProperty()` — burns NFT and removes it from owner's property list.
  - `setMintFee()` — lets owner update the percentage-based mint fee.
- **Security Practices**:
  - Role-based access control using OpenZeppelin's `AccessControl`
  - CEI (Check - Effects - Interactions) Pattern to prevent reentrancy attacks
  - Revert-on-failure for ETH transfers using `require(sent, "Transfer failed")`
  - Uses `_requireOwned()` in `tokenURI` to prevent invalid calls.

## 🛠 Technologies Used

- **Solidity**: `^0.8.24`
- **Framework**: [Foundry](https://book.getfoundry.sh/)
- **OpenZeppelin Contracts**: v4.x ERC721 standard

## 🧪 Testing

Tests are written using Foundry and include unit tests, negative tests, and access control assertions.

| **Test Function**                               | **Purpose**                                         |
| ----------------------------------------------- | --------------------------------------------------- |
| `test_mintProperty()`                           | Successful property minting with fee and event      |
| `test_mintPropertyRevertIfInsufficientFee()`    | Rejects mint with insufficient payment              |
| `test_mintPropertyWithExtraFee()`               | Accepts overpayment correctly                       |
| `test_emitMintPropertyEvent()`                  | Checks `MintProperty` event emission                |
| `test_withdrawFees_correctly()`                 | Withdraws collected fees to owner                   |
| `test_withdrawFees_revertsIfNotOwner()`         | Reverts withdraw if not `OWNER_ROLE`                |
| `test_burnProperty_successfully()`              | Burns token and removes from user’s property list   |
| `test_burnProperty_revertsIfNotPropertyOwner()` | Only token owner can burn their property            |
| `test_setMintFee()`                             | Owner can change mint fee                           |
| `test_setMintFee_revertsIfNotOwner()`           | Reverts if unauthorized address tries to update fee |
| `test_tokenURI()`                               | Returns correct metadata URI for minted tokens      |
| `test_tokenURIRevertsIfTokenNotMinted()`        | Reverts on querying metadata for non-existent token |

## ✅ Coverage Highlights

```
forge coverage
```

> 📈 **95%+ test coverage**, including minting, burning, access control, metadata and fee logic.

| File                        | % Lines        | % Statements   | % Branches   | % Funcs      |
| --------------------------- | -------------- | -------------- | ------------ | ------------ |
| RealEstateNFTCollection.sol | 95.12% (39/41) | 92.50% (37/40) | 85.71% (6/7) | 87.50% (7/8) |

### 🔍 Notes:

- `supportsInterface()` override excluded from coverage — inherited OpenZeppelin logic
- ETH transfer `require(sent, ...)` fallback path intentionally not tested (very low risk)

> The uncovered lines do not affect contract behavior or introduce security risk.

## 🛠 Technologies Used

- **Solidity**: `^0.8.24`
- **Foundry**: For deploying, testing, fuzzing and assertions
- **OpenZeppelin Contracts**: `ERC721`, `AccessControl`
- **IPFS**: For decentralized metadata storage
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
