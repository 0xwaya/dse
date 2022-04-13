// SPDX-License-Identifier: MIT-Modern-Variant

pragma solidity >=0.6.0 <0.9.0;

import '@openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol';
import '@chainlink-brownie-contracts/blob/main/contracts/src/v0.6/VRFConsumerBase.sol';

contract macaw_collection is ERC721, VRFConsumerBase {
    
    bytes32 internal keyhash;
    uint256 public fee;
    uint256 public tokenCounter;

    enum Genus{Anodorhynchus, Cyanopsitta, Ara, Orthopsittaca, Primolius, Diopsittaca}


    mapping(bytes32 => address) public requestIdToSender;
    mapping(bytes32 => string) public requestIdToTokenURI;
    mapping(uint256 => Genus) public tokenIdToGenus;
    mapping(bytes32 => uint256) public requestIdToTokenId;
    event requestedCollectible(bytes32 indexed requestId);

    constructor(address _VRFCoordinator, address _LinkToken, byte32 _keyhash)
    VRFConsumerBase(_VRFCoordinator, _LinkToken)
    ERC721("Web3 Parrots", "MACAW")
    {
        keyhash = _keyhash;
        feed = 0.1 * 10 **18; // 0.1 LINK // 
    }

    function createCollectible(uint256, userProvidedSeed, string memory tokenURI)
    public returns (bytes32)
    {
        // image data storage in areweave is ultimate goal, currently set to IPFS // 

        bytes32 requestId = requestRandomness(keyhash, fee, userProvidedSeed);
        requestIdToSender[requestId] = msg.sender;
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }
    function fullfillRandomness(bytes32 requestId, uint256 randomNumber) internal override {
        address macawOwner = requestIdToSender[requestId];
        string memory tokenURI = requestIdToTokenURI[requestId];
        uint256 newItemId = tokenCounter;
        _safeMint(macawOwner, newItemId);
        _setTokenURI(newItemId, tokenURI);
        // random Genus // 
        Genus macawGenus = Genus(randomNumber % 2);
        tokenIdToGenus[newItemId] = macawGenus;
        requestIdToTokenId[requestId] = newItemId;
        tokenCounter = tokenCounter + 1;
    }
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
}
