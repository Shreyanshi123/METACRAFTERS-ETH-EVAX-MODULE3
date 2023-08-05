// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PokemonToken {
    using SafeMath for uint256;

    string public name = "Pokemon Card Token";
    string public symbol = "POCT";
    uint8 public decimals = 0;
    uint256 public totalSupply;
    uint256 public tokensPerSecond = 1;
    uint256 private lastMintTime;
    bool private _paused;

    mapping(address => bool) private _whitelist;
    mapping(uint256 => uint256) private transferLock;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;
    mapping(uint256 => address) private _tokenOwner; // Added mapping for token ownership
    mapping(uint256 => address) private _tokenApprovals; // Added mapping for token approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals; // Added mapping for operator approvals

    event TokensBurned(address indexed account, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);


    modifier onlyOwner() {
        require(msg.sender == contractOwner, "You are not the owner");
        _;
    }

    modifier whenNotPaused() {
        require(!_paused, "Token transferring is paused");
        _;
    }

    modifier whenWhitelisted(address acc) {
        require(_whitelist[acc], "Account is not whitelisted");
        _;
    }

    struct Card {
        string pokemonName;
        uint256 cardId;
        uint256 attackLevel;
        uint256 defenseLevel;
        uint256 pokemonType;
    }

    Card[] public cards;

    address private contractOwner;

    constructor(uint256 _tokensPerSecond) {
        contractOwner = msg.sender;
        tokensPerSecond = _tokensPerSecond;
        lastMintTime = block.timestamp;
        name = "Pokemon Card Token";
        symbol = "POCT";
        decimals = 18;
    }

    function createCard(string memory _name, uint256 _attack, uint256 _defense) public onlyOwner {
        uint256 cardId = cards.length;
        cards.push(Card(_name, cardId, _attack, _defense, 0));
        totalSupply++;
        balanceOf[msg.sender]++;
    }

    function getCardDetails(uint256 _cardId) public view returns (string memory, uint256, uint256, uint256) {
        require(_cardId < cards.length, "Invalid card ID");
        Card memory card = cards[_cardId];
        return (card.pokemonName, card.cardId, card.attackLevel, card.defenseLevel);
    }

    function pause() public onlyOwner {
        _paused = true;
    }

    function unpause() public onlyOwner {
        _paused = false;
    }

    function isPaused() public view returns (bool) {
        return _paused;
    }

    function addToWhitelist(address account) public onlyOwner {
        _whitelist[account] = true;
    }

    function removeFromWhitelist(address account) public onlyOwner {
        _whitelist[account] = false;
    }

    function isWhitelisted(address account) public view returns (bool) {
        return _whitelist[account];
    }

    function isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
        address tokenOwner = ownerOf(tokenId);
        return (spender == tokenOwner || getApproved(tokenId) == spender || isApprovedForAll(tokenOwner, spender));
    }

    function ownerOf(uint256 tokenId) public view returns (address) {
        address tokenOwner = _tokenOwner[tokenId];
        require(tokenOwner != address(0), "Token not minted");
        return tokenOwner;
    }

    function getApproved(uint256 tokenId) public view returns (address) {
        return _tokenApprovals[tokenId];
    }

    function isApprovedForAll(address owner, address operator) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function mint() public onlyOwner whenNotPaused {
        uint256 elapsedTime = block.timestamp - lastMintTime;
        uint256 amount = elapsedTime.mul(tokensPerSecond);
        balanceOf[msg.sender] = balanceOf[msg.sender].add(amount);
        totalSupply = totalSupply.add(amount);
        lastMintTime = block.timestamp;
    }

    function burn() public whenNotPaused {
        uint256 elapsedTime = block.timestamp - lastMintTime;
        uint256 amount = elapsedTime.mul(tokensPerSecond);
        require(amount <= balanceOf[msg.sender], "Not enough tokens to burn.");

        balanceOf[msg.sender] = balanceOf[msg.sender].sub(amount);
        totalSupply = totalSupply.sub(amount);
        lastMintTime = block.timestamp;
                emit TokensBurned(msg.sender, amount);
    }

    function timelockTransfer(uint256 tokenId, uint256 unlockTime) public whenNotPaused {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        require(transferLock[tokenId] == 0, "Token already timelocked");
        transferLock[tokenId] = unlockTime;
    }

    function claimTimelockedTransfer(uint256 tokenId) public whenNotPaused {
        require(transferLock[tokenId] > 0, "Token is not timelocked");
        require(transferLock[tokenId] <= block.timestamp, "Timelock not expired yet");
        transferLock[tokenId] = 0;
    }

    function transfer(address to, uint256 tokenId) public whenNotPaused {
        require(ownerOf(tokenId) == msg.sender, "You are not the owner");
        require(to != address(0), "Invalid recipient address");

       address from = msg.sender;

    require(ownerOf(tokenId) == from, "Token not owned by sender");

    _tokenOwner[tokenId] = to;
    _tokenApprovals[tokenId] = address(0);

    balanceOf[from] = balanceOf[from].sub(1);
    balanceOf[to] = balanceOf[to].add(1);

    emit Transfer(from, to, tokenId);
    }

    function transferFrom(address from, address to, uint256 tokenId) public whenNotPaused {
        require(isApprovedOrOwner(msg.sender, tokenId), "You are not approved to transfer this token");
        require(to != address(0), "Invalid recipient address");

        require(ownerOf(tokenId) == from, "Token not owned by sender");

    _tokenOwner[tokenId] = to;
    _tokenApprovals[tokenId] = address(0);

    balanceOf[from] = balanceOf[from].sub(1);
    balanceOf[to] = balanceOf[to].add(1);

    emit Transfer(from, to, tokenId);

       
    }

    function approve(address to, uint256 tokenId) public whenNotPaused {
        address tokenOwner = ownerOf(tokenId);
        require(to != tokenOwner, "You cannot approve yourself");

        _tokenApprovals[tokenId] = to;
        emit Approval(tokenOwner, to, tokenId);
    }

    function setApprovalForAll(address operator, bool approved) public whenNotPaused {
        require(operator != msg.sender, "You cannot approve yourself");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

  
}