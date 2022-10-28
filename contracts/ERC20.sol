// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./IERC20.sol";

contract PXR3 is IERC20 {
    
    uint256 public totalTknsSupply;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) allowances;

    string public name;
    string public symbol;
    string public decimals;

    constructor(string memory _name, string memory _symbol, string memory _decimals ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
    }

    modifier allowed (address _from, uint256 _value) {
        require (allowances[_from][msg.sender] >= _value, "Not enough allowance balance");
        _;
    }

    modifier enoughBalance(address _account, uint256 _value) {
        require(balances[_account] >= _value, "Not enough tokens to transfer");
        _;
    }

    modifier correctAddress(address _to) {
        require(_to != address(0), "Address is not correct");
        _;
    }
    
    function totalSupply() external view override returns (uint256) {
        return totalTknsSupply;
    }

    function balanceOf(address _owner)
        external
        view
        override
        returns (uint256)
    {
        return balances[_owner];
    }

    function transfer(address _to, uint256 _value)
        external
        override
        enoughBalance(msg.sender, _value)
        correctAddress(_to)
        returns (bool)
    {
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external override allowed(_from, _value) enoughBalance(_from, _value) correctAddress(_to) returns (bool) {
        
    }

    function approve(address _spender, uint256 _value)
        external
        override
        returns (bool)
    {}

    function allowance(address _owner, address _spender)
        external
        view
        override
        returns (uint256)
    {}
}