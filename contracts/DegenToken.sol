// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

// Import OpenZeppelin's ERC20 implementation
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {
    // Structure to represent an in-game item
    struct InGameItem {
        uint256 id;
        string name;
        uint256 price;
    }

    InGameItem[] private inGameItems; // List of in-game items 

    // Constructor
    constructor() ERC20("Degen", "DGN") Ownable(msg.sender) {
        // Initialize some in-game items
        inGameItems.push(InGameItem(1, "$10 Stone Sword", 10));
        inGameItems.push(InGameItem(2, "$25 Iron Spear", 25));
        inGameItems.push(InGameItem(3, "$50 Silver Axe", 50)); 
    }

    function displayStoreItems() public view returns (string memory,string memory,string memory){
        string memory item1 = string.concat("ITEM 1. ",inGameItems[0].name);
        string memory item2 = string.concat("ITEM 2. ",inGameItems[1].name);
        string memory item3 = string.concat("ITEM 3. ",inGameItems[2].name);
        return (item1,item2,item3);
    }

    // Mint new tokens to another address
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // Transfer tokens to another address
    function transferTokens(address to, uint256 amount) public {
        require(amount > 0, "Transfer amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        approve(msg.sender, amount);
        _transfer(msg.sender, to, amount);
    }   

    // Redeem tokens for items
    function redeemTokens(uint256 itemId) public {
        itemId -= 1;
        require(itemId < inGameItems.length, "Invalid item ID");

        InGameItem storage item = inGameItems[itemId];
        require(balanceOf(msg.sender) >= item.price, "Insufficient balance");

        _burn(msg.sender, item.price);
    }

    // Check token balance of the contract deployer
    function getBalance() public view returns (uint256) {
        return balanceOf(msg.sender);
    }

    // Burn tokens
    function burnTokens(uint256 amount) public {
        require(amount > 0, "Burn amount must be greater than 0");
        require(balanceOf(msg.sender) >= amount, "Insufficient balance");
        _burn(msg.sender, amount);
    }
}
