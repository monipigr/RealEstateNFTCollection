// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/access/AccessControl.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

/*
Conditions: 
- Cada propiedad tiene una fee (mintFee) por mintearla que se almacenan en el contrato. (mintFee)
- La mintFee es un porcentaje de su valor de mercado. 
- Solo el admin puede cambiar la mintFee (OWNER_ROLE)

- Mint: Solo el propietario de la casa puede mintearla (PropertyAdmin)
- Se deben pasar las características de la casa (valor, m2, imagen, nºhab, nºbaños, garage si/no, piscina si/no)
- Se emite un evento cada vez que mintea una nueva propiedad (MintProperty)
- ¿Cómo se construirá el json dinámicamente según la características introducidas por el usuario? 

- Withdraw: Solo el admin puede retirar las fees almacenadas (OWNER_ROLE)

- Burn: El propietario de la propiedad puede hacer burn solo de su propiedad tokenizada (TENANT_ROLE)
- ¿Cómo se destruye el json asociado?

- No hay límite de propiedades tokenizables.
- Cada NFT apunta a un JSON con info del inmueble. Cómo se construye el json si no están preconstruidos? 

Roles:
- TENANT_ROLE - propietario de la propiedad
- OWNER_ROLE - wallet que despliega el contrato

NextSteps:
- Nuevo rol LARGE_TENANT_ROLE para propietarios con +5 propiedades
- Se aplica una fee más elevada para LARGE_TENANT_ROLE (ej. +0.2%)
 */

contract RealEstateNFTCollection is ERC721, AccessControl {
    // bytes32 public constant DEFAULT_ADMIN_ROLE = keccak256("DEFAULT_ADMIN_ROLE");
    bytes32 public constant OWNER_ROLE = keccak256("OWNER_ROLE");
    bytes32 public constant TENANT_ROLE = keccak256("TENANT_ROLE");
    // address OWNER_ROLE;
    // address TENANT_ROLE;


    string public baseUri;
    uint256 propertyId;

    uint256 public mintFee;
    uint256 collectedFees;

    struct Property {
        uint256 propertyId;
        uint256 propertyValue;
        uint256 squareMeters;
        string image;
        bool hasPool;
    }

    mapping(address => Property) userProperties;

    constructor(string memory name_, string memory symbol_, uint256 mintFee_) ERC721(name_, symbol_) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(OWNER_ROLE, msg.sender);
        mintFee = mintFee_;
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, AccessControl) returns (bool) {
        return super.supportsInterface(interfaceId);
    }


    function mintProperty(uint256 propertyValue_) external {
        // Mintea propiedad 
        // Aumenta conteo de propiedades minteadas (propertyId) --> sería el equivalente a tokenID. Pero no sé si es mejor llamarle tokenID o está bien con propertID
        // Añade propiedad al mapping de propiedades de dicho usuario
        // Calcula fee
        // Añade fee al sumatorio de fees (collectedFees)
        // Emite evento
    }

}
