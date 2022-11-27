// SPDX-License-Identifier: MIT-Modern-Variant
// Hacked by @cavetorch for use in Team Macaw project

pragma solidity >=0.6.6 <0.9.0;

import 'erc721a/contracts/ERC721A.sol';
import '@openzeppelin/contracts/access/Ownable.sol';
import '@openzeppelin/contracts/utils/cryptography/MerkleProof.sol';
import '@openzeppelin/contracts/security/ReentrancyGuard.sol';
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; // <-- Import of VRFConsumerBase contract (base class)

contract MacawCollectible is ERC721A, VRFConsumerBase, Ownable, ReentrancyGuard  { // <-- Inheritance of ERC721 and VRFConsumerBase contracts
     using Strings for uint256;

  bytes32 public merkleRoot;
  mapping(address => bool) public whitelistClaimed;
    uint256 public tokenId; // <-- Public variable of type uint256

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalSupply) public ERC721(_name, _symbol, _decimals, _totalSupply) {
        _name = "Macaw Webtree House"; // <-- Name of the token
        _symbol = "MWH"; // <-- Symbol name of the token
        _totalSupply = 1000000 * 10**18; // <-- Total supply of the token
        _balances[msg.sender] = _totalSupply; // <-- Assign total supply to the creator of the contract
    }

    string public tokenName; // <-- Public variable of type string
    string public tokenSymbol; // <-- Public variable of type string
    string public tokenURI; // <-- Public variable of type string


    mapping(bytes32 => address) public requestIdToSender; // API call to the request Sender beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToTokenPrice; // API call to the request TokenPrice beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToTokenSeller; // API call to the request TokenSeller beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToTokenBuyer; // API call to the request TokenBuyer beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToTokenOwner; // API call to the request TokenOwner beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToTokenApproved; // API call to the request TokenApproved beforeTokenTransfer //
    mapping(bytes32 => string) public requestIdToTokenURI; // API call to the request TokenURI // 
    mapping(uint256 => uint256) public tokenIdToTokenId; // API call to the tokenId to TokenId mapping //
    mapping(uint256 => uint256) public tokenIdToTokenPrice; // API call to the tokenId to TokenPrice mapping //
    event requestedCollectible(bytes32 indexed requestId); // <-- Event of requested collectible //
    event collectedCollectible(bytes32 indexed requestId); // <-- Event of collected collectible //
    event collectedCollectibleWithSender(bytes32 indexed requestId, address sender); // <-- Event of collected collectible with sender //
    event collectedCollectibleWithSenderAndTokenId(bytes32 indexed requestId, address sender, uint256 tokenId); // <-- Event of collected collectible with sender and tokenId //

    bytes32 internal keyHash; // VRF key hash //
    bytes32 internal randomNumber; // VRF random number //
    bytes32 internal randomNumberHash; // VRF random number hash //
    uint256 public fee; // fee for the VRF //
   
constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash) public { // <-- Constructor of the contract //
    VRFCoordinator = _VRFCoordinator; // <-- VRFCoordinator address //
    LinkToken = _LinkToken; // <-- LinkToken address //
    keyHash = _keyhash; // <-- VRF key hash //
    fee = 10000000000000000000; // <-- Fee for the VRF //
}   // <-- End of Constructor // 
    ERC721A public ERC721; // <-- Inheritance of ERC721A contract //
    VRFConsumerBase public VRFConsumerBase; // <-- Inheritance of VRFConsumerBase contract //
    address public VRFCoordinator; // <-- VRFCoordinator address //
    address public LinkToken; // <-- LinkToken address //
    address public owner; // <-- Owner address //
    address public approved; // <-- Approved address //
    } // <-- End of contract //

    function collectible(uint256 _tokenId) external { // <-- Collectible function //
        require(ERC721.ownerOf(_tokenId) == msg.sender); // <-- Require that the sender is the owner of the token //
        ERC721.safeTransferFrom(msg.sender, owner, _tokenId); // <-- Safe transfer from the sender to the owner //
        emit collectedCollectible(sha3(_tokenId)); // <-- Emit the collected collectible event //
    } // <-- End of collectible function //                    
    {                   
        bytes32 requestId = requestRandomness(keyHash, fee, userProvidedSeed); // <-- API call to the requestRandomness function //
        requestIdToSender[requestId] = msg.sender; // <-- API call to the requestIdToSender mapping //
        emit requestedCollectible(requestId); // <-- Event of requested collectible //
    } 
    function fullfillRandomness(bytes32 requestId, uint256 randomness) internal override { // <-- Function to fullfill the VRF //}   
        address macawOwner = requestIdToSender[requestId]; // get the sender of the request //
        uint256 newItemId = tokenCounter; // get the next token id //
        tokenCounter++; // increment the token counter //
        tokenId = newItemId; // set the token id //
        _safeMint(macawOwner, newItemId); // mint the token //
        requestIdToTokenId[requestId] = newItemId; // <-- API call to the requestIdToTokenId mapping //
        randomNumber = randomness; // <-- VRF random number //
        _setTokenURI(newItemId, tokenURI); // set the tokenURI //
    } // <-- End of fullfillRandomness function //
} // <-- End of Function to define the TokenRegistry //
