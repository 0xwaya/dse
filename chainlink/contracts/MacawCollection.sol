// SPDX-License-Identifier: MIT-Modern-Variant
pragma solidity ^0.6.6; // <-- Version of Solidity
import "@openzeppelin/contracts/token/ERC721/ERC721.sol"; // <-- Import of ERC721 contract from OpenZeppelin library 
import "@chainlink/contracts/src/v0.6/VRFConsumerBase.sol"; // <-- Import of VRFConsumerBase contract (base class)
contract MacawCollection is ERC721, VRFConsumerBase {  // <-- Inheritance of ERC721 and VRFConsumerBase contracts from MacawCollection contract 
    uint256 public tokenCounter; // <-- Public variable of type uint256 
    uint256 public tokenId; // <-- Public variable of type uint256
    string public tokenName; // <-- Public variable of type string
    string public tokenSymbol; // <-- Public variable of type string
    string public tokenURI; // <-- Public variable of type string
    enum Genus{Anodorhynchus, Cyanopsitta, Ara, Orthopsittaca, Primolius, Diopsittaca} // <-- Enumeration of Genus 
    uint256 public genus; // <-- Public variable of type uint256
    mapping(bytes32 => address) public requestIdToSender; // API call to the request Sender beforeTokenTransfer // 
    mapping(bytes32 => uint256) public requestIdToTokenId; // API call to the request TokenId beforeTokenTransfer //
    mapping(bytes32 => uint256) public requestIdToGenus; // API call to the request Genus beforeTokenTransfer //
    mapping(bytes32 => string) public requestIdToTokenURI; // API call to the request TokenURI //
    mapping(uint256 => Genus) public tokenIdToGenus; // API call to the request Genus //
    mapping(uint256 => string) public tokenIdToTokenURI; // API call to the request TokenURI //
    mapping(bytes32 => uint256) public requestIdToTokenId; // API call to the request //
    mapping(bytes32 => uint256) public requestIdToTokenCounter; // API call to the request TokenCounter //
    mapping(bytes32 => string) public requestIdToTokenName; // API call to the request TokenName //
    mapping(bytes32 => string) public requestIdToTokenSymbol; // API call to the request TokenSymbol //
    event requestedCollectible(bytes32 indexed requestId); // event to be emitted when a collectible is requested //
    event collectedCollectible(bytes32 indexed requestId); // event to be emitted when a collectible is collected //
    event collectedCollectibleWithURI(bytes32 indexed requestId, string tokenURI); // event to be emitted when a collectible is collected with URI //
    event collectedCollectibleWithURIAndGenus(bytes32 indexed requestId, string tokenURI, uint256 genus); // event to be emitted when a collectible is collected with URI and Genus //
    event collectedCollectibleWithURIAndGenusAndTokenId(bytes32 indexed requestId, string tokenURI, uint256 genus, uint256 tokenId); // event to be emitted when a collectible is collected with URI, Genus and TokenId //
    event collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(bytes32 indexed requestId, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter); // event to be emitted when a collectible is collected with URI, Genus, TokenId and TokenCounter //
    event collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(bytes32 indexed requestId, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter, string tokenName); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter, TokenName //
    event collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(bytes32 indexed requestId, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter, string tokenName, string tokenSymbol); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter, TokenName, TokenSymbol //
    event collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenURI(bytes32 indexed requestId, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter, string tokenName, string tokenSymbol, string tokenURI); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter, TokenName, TokenSymbol and TokenURI //
    event ReturnedCollectible(bytes32 indexed requestId, uint256 randomNumber); // event to be emitted when a collectible is returned //
    event ReturnedCollectibleWithURI(bytes32 indexed requestId, uint256 randomNumber, string tokenURI); // event to be emitted when a collectible is collected with URI //
    event ReturnedCollectibleWithURIAndGenus(bytes32 indexed requestId, uint256 randomNumber, string tokenURI, uint256 genus); // event to be emitted when a collectible is collected with URI and Genus // 
    event ReturnedCollectibleWithURIAndGenusAndTokenId(bytes32 indexed requestId, uint256 randomNumber, string tokenURI, uint256 genus, uint256 tokenId); // event to be emitted when a collectible is collected with URI, Genus and TokenId // 
    event ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(bytes32 indexed requestId, uint256 randomNumber, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter // 
    event ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(bytes32 indexed requestId, uint256 randomNumber, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter, string tokenName); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter, TokenName //    
    event ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(bytes32 indexed requestId, uint256 randomNumber, string tokenURI, uint256 genus, uint256 tokenId, uint256 tokenCounter, string tokenName, string tokenSymbol); // event to be emitted when a collectible is collected with URI, Genus, TokenId, TokenCounter, TokenName, TokenSymbol // 

    bytes32 internal keyHash; // VRF key hash //
    bytes32 internal randomNumber; // VRF random number //
    bytes32 internal randomNumberHash; // VRF random number hash //
    uint256 public fee; // fee for the VRF //
    uint256 public feePerByte; // fee per byte for the VRF //

 constructor(address _VRFCoordinator, address _LinkToken, bytes32 _keyhash)    public   {  // <-- Constructor of the contract //   
            VRFConsumerBase(_VRFCoordinator, _LinkToken) // <-- Inheritance of VRFConsumerBase // 
            VRFCoordinator = _VRFCoordinator; // <-- Assign the VRFCoordinator to the _VRFCoordinator //
            LinkToken = _LinkToken; // <-- Assign LinkToken to _LinkToken // 
            keyHash = _keyhash; // <-- Assign keyHash to _keyhash //
            fee = 10000000000000000000; // <-- Assign fee to 10000000000000000000 // 
            tokenCounter = 0; // <-- Initializing the tokenCounter to 0 //
        ERC721("Amazonian Web3 Parrots", "MACAW") // <-- Constructor of ERC721 // 
        }
    }  // <-- End of Constructor // 
    function createCollectible(uint256, userProvidedSeed, string memory tokenURI)  {  // <-- Function to create a collectible //
        uint256 randomNumber = getRandomNumber(userProvidedSeed); // <-- Get the random number //
        uint256 randomNumberHash = getRandomNumberHash(randomNumber); // <-- Get the random number hash //
        uint256 randomNumber = generateRandomNumber(userProvidedSeed); // <-- Generate random number //
        uint256 randomNumberHash = generateRandomNumberHash(randomNumber); // <-- Generate random number hash //
        uint256 tokenId = tokenCounter++; // <-- Assign tokenCounter to tokenId //
        uint256 tokenId = generateTokenId(tokenId); // <-- Generate tokenId //
        uint256 tokenId = getTokenId(tokenId); // <-- Get the tokenId //
        tokenIdToGenus[tokenId] = Genus.Anodorhynchus; // <-- Assign Genus.Anodorhynchus to tokenIdToGenus[tokenId] //          
        tokenIdToTokenURI[tokenId] = tokenURI; // <-- Assign tokenURI to tokenIdToTokenURI[tokenId] //
        requestIdToTokenId[keyHash] = tokenId; // <-- Assign tokenId to requestIdToTokenId[keyHash] //
        emit requestedCollectible(keyHash); // <-- Emit requestedCollectible(keyHash) //
        return tokenId; // <-- Return tokenId //
        return randomNumber; // <-- Return randomNumber //
    }  // <-- End of Function to create a collectible //
    function fullfillRandomness(bytes32 requestId, uint256 randomNumber) internal override { // override is necessary to call the base class function //
        address macawOwner = requestIdToSender[requestId]; // get the sender of the request //
        uint256 tokenId = requestIdToTokenId[requestId]; // get the tokenId of the request //
        uint256 randomNumberHash = getRandomNumberHash(randomNumber); // get the randomNumberHash of the request //
        string memory tokenURI = requestIdToTokenURI[requestId]; // get the tokenURI of the request //
        uint256 genus = tokenIdToGenus[tokenId]; // get the genus of the token //
        uint256 tokenId = generateTokenId(tokenId); // generate the tokenId //
        uint256 tokenId = getTokenId(tokenId); // get the tokenId //
        tokenIdToGenus[tokenId] = genus; // assign the genus to the tokenIdToGenus[tokenId] //
        tokenIdToTokenURI[tokenId] = tokenURI; // assign the tokenURI to the tokenIdToTokenURI[tokenId] //
        requestIdToTokenId[requestId] = tokenId; // assign the tokenId to the requestIdToTokenId[requestId] //
        emit collectedCollectible(requestId, randomNumber); // emit collectedCollectible(requestId, randomNumber) //
        emit collectedCollectibleWithURI(requestId, randomNumber, tokenURI); // emit collectedCollectibleWithURI(requestId, randomNumber, tokenURI) //
        emit collectedCollectibleWithURIAndGenus(requestId, randomNumber, tokenURI, genus); // emit collectedCollectibleWithURIAndGenus(requestId, randomNumber, tokenURI, genus) //
        emit collectedCollectibleWithURIAndGenusAndTokenId(requestId, randomNumber, tokenURI, genus, tokenId); // emit collectedCollectibleWithURIAndGenusAndTokenId(requestId, randomNumber, tokenURI, genus, tokenId) //
        emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter); // emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter) //
        emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName); // emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName) //
        emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol); // emit collectedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol) //
        emit ReturnedCollectible(requestId, randomNumber); // emit ReturnedCollectible(requestId, randomNumber) //
        emit ReturnedCollectibleWithURI(requestId, randomNumber, tokenURI); // emit ReturnedCollectibleWithURI(requestId, randomNumber, tokenURI) //
        emit ReturnedCollectibleWithURIAndGenus(requestId, randomNumber, tokenURI, genus); // emit ReturnedCollectibleWithURIAndGenus(requestId, randomNumber, tokenURI, genus) //
        emit ReturnedCollectibleWithURIAndGenusAndTokenId(requestId, randomNumber, tokenURI, genus, tokenId); // emit ReturnedCollectibleWithURIAndGenusAndTokenId(requestId, randomNumber, tokenURI, genus, tokenId) //
        emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter); // emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounter(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter) //
        emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName); // emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenName(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName) //
        emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol); // emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol) //
        emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenOwner(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenOwner); // emit ReturnedCollectibleWithURIAndGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenOwner(requestId, randomNumber, tokenURI, genus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenOwner) //
        uint256 newItemId = tokenCounter; // get the next token id //
        uint256 newItemId = generateTokenId(newItemId); // generate the next token id //
        uint256 newItemId = getTokenId(newItemId); // get the next token id //
        tokenIdToGenus[newItemId] = genus; // assign the genus to the tokenIdToGenus[newItemId] //
        tokenIdToTokenURI[newItemId] = tokenURI; // assign the tokenURI to the tokenIdToTokenURI[newItemId] //
        tokenCounter = newItemId; // assign the next token id to the tokenCounter //
        emit newItem(newItemId, tokenURI, genus); // emit newItem(newItemId, tokenURI, genus) //
        emit newItemWithTokenOwner(newItemId, tokenURI, genus, tokenOwner); // emit newItemWithTokenOwner(newItemId, tokenURI, genus, tokenOwner) //
        emit newItemWithTokenOwnerAndTokenName(newItemId, tokenURI, genus, tokenOwner, tokenName); // emit newItemWithTokenOwnerAndTokenName(newItemId, tokenURI, genus, tokenOwner, tokenName) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbol(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbol(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounter(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounter(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenId(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenId(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURI(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURI(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenus(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenus(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenusAndTokenName(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus, tokenName); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenusAndTokenName(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus, tokenName) //
        emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenusAndTokenNameAndTokenSymbol(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus, tokenName, tokenSymbol); // emit newItemWithTokenOwnerAndTokenNameAndTokenSymbolAndTokenCounterAndTokenIdAndTokenURIAndTokenGenusAndTokenNameAndTokenSymbol(newItemId, tokenURI, genus, tokenOwner, tokenName, tokenSymbol, tokenCounter, tokenId, tokenURI, genus, tokenName, tokenSymbol) //
        _safeMint(macawOwner, newItemId); // mint the token //
        _safeTransferFrom(macawOwner, tokenOwner, newItemId); // transfer the token from the macawOwner to the tokenOwner //
        _setTokenURI(newItemId, tokenURI); // set the tokenURI //
        _setTokenGenus(newItemId, genus); // set the tokenGenus //
        _setTokenName(newItemId, tokenName); // set the tokenName //
        _setTokenSymbol(newItemId, tokenSymbol); // set the tokenSymbol //
        _setTokenOwner(newItemId, tokenOwner); // set the tokenOwner //
        _setTokenCounter(newItemId, tokenCounter); // set the tokenCounter //
        _setTokenId(newItemId, tokenId); // set the tokenId //
        Genus macawGenus = Genus(randomNumber % 2); // get the genus of the token //
        emit ReturnedCollectibleWithGenus(requestId, macawGenus); // emit ReturnedCollectibleWithGenus(requestId, macawGenus) //
        emit ReturnedCollectibleWithGenusAndTokenId(requestId, macawGenus, tokenId); // emit ReturnedCollectibleWithGenusAndTokenId(requestId, macawGenus, tokenId) //
        emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounter(requestId, macawGenus, tokenId, tokenCounter); // emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounter(requestId, macawGenus, tokenId, tokenCounter) //
        emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenName(requestId, macawGenus, tokenId, tokenCounter, tokenName); // emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenName(requestId, macawGenus, tokenId, tokenCounter, tokenName) //
        emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol); // emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbol(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol) //
        emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenURI(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenURI); // emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenURI(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenURI) //
        emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenURIAndTokenOwner(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenURI, tokenOwner); // emit ReturnedCollectibleWithGenusAndTokenIdAndTokenCounterAndTokenNameAndTokenSymbolAndTokenURIAndTokenOwner(requestId, macawGenus, tokenId, tokenCounter, tokenName, tokenSymbol, tokenURI, tokenOwner) //
        tokenIdToGenus[newItemId] = macawGenus; // set the genus of the token // 
        tokenIdToTokenURI[newItemId] = tokenURI; // set the tokenURI //
        tokenIdToTokenName[newItemId] = tokenName; // set the tokenName //
        tokenIdToTokenSymbol[newItemId] = tokenSymbol; // set the tokenSymbol //
        tokenIdToTokenOwner[newItemId] = tokenOwner; // set the tokenOwner //
        tokenIdToTokenCounter[newItemId] = tokenCounter; // set the tokenCounter //
        tokenIdToTokenId[newItemId] = tokenId; // set the tokenId //
        tokenIdToTokenGenus[newItemId] = macawGenus; // set the genus of the token // 
        requestIdToTokenId[requestId] = newItemId; // set the tokenId //
        requestIdToTokenURI[requestId] = tokenURI; // set the tokenURI //
        requestIdToTokenGenus[requestId] = macawGenus; // set the genus of the token //
        requestIdToTokenName[requestId] = tokenName; // set the tokenName //
        requestIdToTokenSymbol[requestId] = tokenSymbol; // set the tokenSymbol //
        requestIdToTokenOwner[requestId] = tokenOwner; // set the tokenOwner //
        requestIdToTokenCounter[requestId] = tokenCounter; // set the tokenCounter //
        tokenCounter = tokenCounter + 1; // increment the token counter // 
        _setTokenCounter(newItemId, tokenCounter); // set the tokenCounter //
        _setTokenCounter(tokenId, tokenCounter); // set the tokenCounter //
    }
    function setTokenURI(uint256 tokenId, string memory _tokenURI) public {  // <-- Function to set the tokenURI //
        require( LINK.balanceOf(msg.sender) >= fee); // <-- Require that the sender has enough LINK //
        require(tokenIdToGenus[tokenId] == Genus.Anodorhynchus); // <-- Require that the token is of type Anodorhynchus //
        require(tokenIdToTokenURI[tokenId] == ""); // <-- Require that the tokenURI is empty //
        require(tokenIdToTokenOwner[tokenId] == msg.sender); // <-- Require that the tokenOwner is the sender //
        tokenIdToTokenURI[tokenId] = _tokenURI; // <-- Set the tokenURI //
        _setTokenURI(tokenId, _tokenURI); // <-- Set the tokenURI //
    }  // <-- End of Function to set the tokenURI //
    function getTokenURI(uint256 tokenId) public view returns (string memory tokenURI) {  // <-- Function to get the tokenURI //
        tokenURI = tokenIdToTokenURI[tokenId]; // <-- Assign tokenIdToTokenURI[tokenId] to tokenURI //
    }  // <-- End of Function to get the tokenURI //
    function getGenus(uint256 tokenId) public view returns (Genus) {  // <-- Function to get the genus //
        return tokenIdToGenus[tokenId]; // <-- Return tokenIdToGenus[tokenId] //
    }  // <-- End of Function to get the genus //
    function getTokenId(bytes32 requestId) public view returns (uint256) {  // <-- Function to get the tokenId //   
            _isApprovedOrOwner(_msgSender(), tokenId),  // <-- Require that the sender is the owner or approved //  
            return requestIdToTokenId[requestId]; // <-- Return requestIdToTokenId[requestId] //
    }  // <-- End of Function to get the tokenId //
    function getRandomNumber(bytes32 requestId) public view returns (uint256) {  // <-- Function to get the randomNumber //
        return requestIdToRandomNumber[requestId]; // <-- Return requestIdToRandomNumber[requestId] //
    }  // <-- End of Function to get the randomNumber //
    function getFee() public view returns (uint256) {  // <-- Function to get the fee //
        return fee; // <-- Return fee //
    }  // <-- End of Function to get the fee //
    function getKeyHash() public view returns (bytes32) {  // <-- Function to get the keyHash //
        return keyHash; // <-- Return keyHash //
    }  // <-- End of Function to get the keyHash //
    function getVRFCoordinator() public view returns (address) {  // <-- Function to get the VRFCoordinator //
        return VRFCoordinator; // <-- Return VRFCoordinator //
    }  // <-- End of Function to get the VRFCoordinator //
    function getLinkToken() public view returns (address) {  // <-- Function to get the LinkToken //
        return LinkToken; // <-- Return LinkToken //
    }  // <-- End of Function to get the LinkToken //
    function getTokenCounter() public view returns (uint256) {  // <-- Function to get the tokenCounter //
        return tokenCounter; // <-- Return tokenCounter //
    }  // <-- End of Function to get the tokenCounter //
    function getRequestIdToTokenId() public view returns (bytes32[]) {  // <-- Function to get the requestIdToTokenId //
        return requestIdToTokenId; // <-- Return requestIdToTokenId //
    }  // <-- End of Function to get the requestIdToTokenId //
    function getRequestIdToRandomNumber() public view returns (uint256[]) {  // <-- Function to get the requestIdToRandomNumber //
        return requestIdToRandomNumber; // <-- Return requestIdToRandomNumber //
    }  // <-- End of Function to get the requestIdToRandomNumber //
    function getRequestIdToSender() public view returns (address[]) {  // <-- Function to get the requestIdToSender //
        return requestIdToSender; // <-- Return requestIdToSender //
    }  // <-- End of Function to get the requestIdToSender //
    function getTokenIdToTokenURI() public view returns (string[]) {  // <-- Function to get the tokenIdToTokenURI //
        return tokenIdToTokenURI; // <-- Return tokenIdToTokenURI //
    }  // <-- End of Function to get the tokenIdToTokenURI //
    function getTokenIdToGenus() public view returns (Genus[]) {  // <-- Function to get the tokenIdToGenus //
        return tokenIdToGenus; // <-- Return tokenIdToGenus //
    }  // <-- End of Function to get the tokenIdToGenus //
    function getTokenIdToOwner() public view returns (address[]) {  // <-- Function to get the tokenIdToOwner //
        return tokenIdToOwner; // <-- Return tokenIdToOwner //
    }  // <-- End of Function to get the tokenIdToOwner //
    function getTokenIdToApproved() public view returns (address[]) {  // <-- Function to get the tokenIdToApproved //
        return tokenIdToApproved; // <-- Return tokenIdToApproved //
    }  // <-- End of Function to get the tokenIdToApproved //
    function getTokenIdToApprovedCount() public view returns (uint256[]) {  // <-- Function to get the tokenIdToApprovedCount //
        return tokenIdToApprovedCount; // <-- Return tokenIdToApprovedCount //
    }  // <-- End of Function to get the tokenIdToApprovedCount //

    function _safeMint(address _to, uint256 _tokenId) internal {  // <-- Function to mint a token //
        require(LINK.balanceOf(msg.sender) >= fee); // <-- Require that the sender has enough LINK //
        LINK.transfer(msg.sender, _to, fee); // <-- Transfer LINK from the sender to the recipient //
        tokenIdToOwner[_tokenId] = msg.sender; // <-- Assign the sender to tokenIdToOwner[_tokenId] //
    }  // <-- End of Function to mint a token //
    function _safeTransferFrom(address _from, address _to, uint256 _tokenId) internal {  // <-- Function to transfer a token from one address to another //
        require(_to != address(0)); // <-- Require that the recipient is not the zero address //
        require(_from != address(0)); // <-- Require that the sender is not the zero address //
        require(tokenIdToOwner[_tokenId] == _from); // <-- Require that the sender is the owner of the token //
        require(tokenIdToApproved[_tokenId] == _from); // <-- Require that the sender is the approved of the token //
        require(LINK.balanceOf(_from) >= fee); // <-- Require that the sender has enough LINK //
        LINK.transfer(_from, _to, fee); // <-- Transfer LINK from the sender to the recipient //
        tokenIdToOwner[_tokenId] = _to; // <-- Assign the recipient to tokenIdToOwner[_tokenId] //
    }  // <-- End of Function to transfer a token from one address to another //
    function _safeApprove(address _to, uint256 _tokenId) internal {  // <-- Function to approve a token for a recipient //
        require(_to != address(0)); // <-- Require that the recipient is not the zero address //
        require(_to != msg.sender); // <-- Require that the recipient is not the sender //
        require(tokenIdToOwner[_tokenId] == msg.sender); // <-- Require that the sender is the owner of the token //
        tokenIdToApproved[_tokenId] = _to; // <-- Assign the recipient to tokenIdToApproved[_tokenId] //
        tokenIdToApprovedCount[_tokenId]++; // <-- Increment tokenIdToApprovedCount[_tokenId] //
    }  // <-- End of Function to approve a token for a recipient //
} // <-- End of Function to define the TokenRegistry //
