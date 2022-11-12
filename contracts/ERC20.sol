// SPDX-License-Identifier: MIT

pragma solidity ^0.8.9;

import "./IERC20.sol";

contract PXR3 is IERC20 {
    uint256 public _totalSupply; // total number of tokens

    mapping(address => uint256) private _balances; // the number of tokens each user has
    mapping(address => mapping(address => uint256)) private _allowances; // information who entrusted their money to whom

    string public name; // name of token
    string public symbol; // symbol of token
    uint8 public decimals; // number of decimals
    address owner; // address of owner

    modifier ownerOnly() {
        require(msg.sender == owner, "Not an owner");
        _;
    }

    modifier affordable(address _from, uint256 _value) {
        require(_balances[msg.sender] >= _value, "Not enough tokens");
        _;
    }

    modifier allowed(address _from, uint256 _value) {
        require(_allowances[_from][msg.sender] >= _value, "Not allowed");
        _;
    }

    modifier correctAddress(address _address) {
        require(_address != address(0), "Address is incorrect");
        _;
    }

    constructor(
        string memory _name,
        string memory _symbol,
        uint8 _decimals
    ) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        owner = msg.sender;
    }

  
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address _owner)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _balances[_owner];
    }

   
    function transfer(address _to, uint256 _value)
        public
        virtual
        override
        affordable(msg.sender, _value)
        correctAddress(_to)
        returns (bool)
    {
        _balances[msg.sender] -= _value;
        _balances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    )
        public
        virtual
        override
        allowed(_from, _value)
        affordable(_from, _value)
        correctAddress(_to)
        returns (bool)
    {
        _allowances[_from][msg.sender] -= _value;
        _balances[_from] -= _value;
        _balances[_to] += _value;

        emit Transfer(_from, _to, _value);
        return true;
    }

    
    function approve(address _spender, uint256 _value)
        public
        virtual
        override
        correctAddress(_spender)
        returns (bool)
    {
        _allowances[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);
        return true;
    }

  
    function allowance(address _owner, address _spender)
        public
        view
        virtual
        override
        returns (uint256)
    {
        return _allowances[_owner][_spender];
    }

  
    function burn(address account, uint256 amount)
        public
        ownerOnly
        affordable(account, amount)
    {
        _totalSupply -= amount;
        _balances[account] -= amount;

        emit Transfer(account, address(0), amount);
    }

   
    function mint(address account, uint256 amount) public ownerOnly {
        _totalSupply += amount;
        _balances[account] += amount;

        emit Transfer(address(0), account, amount);
    }
}
