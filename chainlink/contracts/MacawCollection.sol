// SPDX-License-Identifier: MIT-Modern-Variant
pragma solidity ^0.6.6; // <-- Version of Solidity
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // <-- Import of ERC721
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; // <-- Import of VRFConsumerBase
contract MacawCollection is ERC721, VRFConsumerBase {  // <-- Inheritance of ERC721 and VRFConsumerBase
    uint256 public tokenCounter; // <-- Public variable of type uint256
        // add other properties here
    enum Genus{Anodorhynchus, Cyanopsitta, Ara, Orthopsittaca, Primolius, Diopsittaca} // <-- Enumeration of Genus
    mapping(bytes32 => address) public requestIdToSender; // API call to the request Sender beforeTokenTransfer //
    mapping(bytes32 => string) public requestIdToTokenURI; // API call to the request TokenURI //
    mapping(uint256 => Genus) public tokenIdToGenus; // API call to the request Genus //
    mapping(bytes32 => uint256) public requestIdToTokenId; // API call to the request //
    event requestedCollectible(bytes32 indexed requestId); // event to be emitted when a collectible is requested //
    event ReturnedCollectible(bytes32 indexed requestId, uint256 randomNumber);

    bytes32 internal keyHash; // VRF key hash //
    uint256 public fee; // fee for the VRF //

 constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)    public   {  // <-- Constructor 
        VRFCoordinator = _VRFCoordinator; // <-- Assign VRFCoordinator to _VRFCoordinator
        LinkToken = _LinkToken; // <-- Assign LinkToken to _LinkToken
        keyHash = _keyhash; // <-- Assign keyHash to _keyhash
        fee = 10000000000000000000; // <-- Assign fee to 10000000000000000000
     VRFConsumerBase(_VRFCoordinator, _LinkToken) // <-- Inheritance of VRFConsumerBase //
    ERC721("Amazonian Web3 Parrots", "MACAW") // <-- Constructor of ERC721 //
    fee = 10000000000000000000; // <-- fee for the VRF //   
    keyHash = _keyhash; // <-- VRF key hash //
    tokenCounter = 0; // <-- Initializing the tokenCounter to 0 //  
     }    // <-- End of Constructor
    function createCollectible(uint256, userProvidedSeed, string memory tokenURI)
    public returns (bytes32)
    {
        // image data storage future goal is to set to Arweave instead of IPFS // 

        bytes32 requestId = requestRandomness(keyhash, fee, userProvidedSeed);
        requestIdToSender[requestId] = msg.sender; // send requested information to sender //
        requestIdToTokenURI[requestId] = tokenURI;
        emit requestedCollectible(requestId);
    }
    function fullfillRandomness(bytes32 requestId, uint256 randomNumber) internal override { // override is necessary to call the base class function //
        address macawOwner = requestIdToSender[requestId]; // get the sender of the request //
        string memory tokenURI = requestIdToTokenURI[requestId]; // get the tokenURI of the request //
        uint256 newItemId = tokenCounter; // get the next token id //
        _safeMint(macawOwner, newItemId); // mint the token //
        _setTokenURI(newItemId, tokenURI); // set the tokenURI //
        Genus macawGenus = Genus(randomNumber % 2); // get the genus of the token //
        tokenIdToGenus[newItemId] = macawGenus;
        requestIdToTokenId[requestId] = newItemId; // set the tokenId //
        tokenCounter = tokenCounter + 1; // increment the token counter //
    }
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721: transfer caller is not owner nor approved"
        );
        _setTokenURI(tokenId, _tokenURI);
    }
}
