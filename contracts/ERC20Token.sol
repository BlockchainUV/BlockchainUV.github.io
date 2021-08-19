// Implements EIP20 token standard

// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "./ERC20Interface.sol";

contract ERC20Token is ERC20Interface {
    uint256 constant private MAX_UINT256 = 2**256-1;
    
    mapping (address => uint256) public balances;
    mapping (address => mapping (address => uint256)) public allowed;

    uint256 public override totalSupply;
    uint8 public decimals;

    string public name;
    string public symbol;

    constructor(
        uint256 tokenSupply,
        uint8 tokenDecimals,
        string memory tokenName,
        string memory tokenSymbol
    ) {
        balances[msg.sender] = tokenSupply;
        totalSupply = tokenSupply;
        decimals = tokenDecimals;
        name = tokenName;
        symbol = tokenSymbol;
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(amount >= 0, "Can not transfer negative amount.");
        require(balances[msg.sender] >= amount, "Insufficient funds.");
        balances[msg.sender] -= amount;
        balances[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function transferFrom(address from, address to, uint256 amount) public override returns (bool) {
        require(balances[from] >= amount && allowed[from][msg.sender] >= amount, "Insufficient funds.");
        balances[from] -= amount;
        balances[to] += amount;
        if (allowed[from][msg.sender] < MAX_UINT256) {
            allowed[from][msg.sender] -= amount;
        }
        emit Transfer(from, to , amount);
        return true;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowed[owner][spender];
    }

    /* function totalSupply() public view override returns (uint256) {
        return totalSupply;
    } */
}