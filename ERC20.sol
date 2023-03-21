// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract myERC20 {
    string public constant name_ = "dxjToken";
    mapping(address => uint256) balances_;
    mapping(address => mapping(address => uint256)) public allowed_;
    string public constant symbol_ = "Crui";
    uint8 public constant decimals_ = 6;
    uint constant _initial_supply = 5000000;
    uint256 private totalSupply_;
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );

    constructor() {
        totalSupply_ = _initial_supply;
        balances_[msg.sender] = _initial_supply;
    }

    function name() public view returns (string memory) {
        return name_;
    }

    function symbol() public view returns (string memory) {
        return symbol_;
    }

    function decimals() public view returns (uint8) {
        return 6;
    }

    function totalSupply() public view returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public view returns (uint256) {
        return balances_[account];
    }

    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _transfer(owner, to, amount);
        return true;
    }

    function _transfer(address from, address to, uint256 amount) internal {
        require(from != address(0), "error:  address not correct");
        require(to != address(0), "error:  address not correct");

        uint256 fromBalance = balances_[from];
        require(
            fromBalance >= amount,
            "error: transfer amount exceeds balance"
        );
        unchecked {
            balances_[from] = fromBalance - amount;
            balances_[to] += amount;
        }

        emit Transfer(from, to, amount);
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return allowed_[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;
    }

    function _approve(address owner, address spender, uint256 amount) internal {
        require(owner != address(0), "error: approve from the zero address");
        require(spender != address(0), "error: approve to the zero address");

        allowed_[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }

    // 函数调用者将币从from转到to（前提是from给该调用者的allowance充足）
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal {
        uint256 currentAllowance = allowance(owner, spender);
        if (currentAllowance != type(uint256).max) {
            require(
                currentAllowance >= amount,
                "error: insufficient allowance"
            );
            unchecked {
                _approve(owner, spender, currentAllowance - amount);
            }
        }
    }

    function increaseAllowance(
        address spender,
        uint256 addedValue
    ) public returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, allowance(owner, spender) + addedValue);
        return true;
    }

    function decreaseAllowance(
        address spender,
        uint256 subtractedValue
    ) public returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance = allowance(owner, spender);
        require(
            currentAllowance >= subtractedValue,
            "error: decreased allowance below zero"
        );
        unchecked {
            _approve(owner, spender, currentAllowance - subtractedValue);
        }

        return true;
    }
}
