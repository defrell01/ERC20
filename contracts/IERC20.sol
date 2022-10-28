// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

interface IERC20 {
    
    function totalSupply() external view returns (uint256); /// total amount of tokens

    function balanceOf(address _owner) external view returns (uint256);     // balance of specific user

    function transfer(address _to, uint256 _value) external returns (bool);     // transfer tokens from 1 user to another

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) external returns (bool);                                                 // transfer from other account to other

    function approve(address _spender, uint256 _value) external returns (bool);             // give smb approval to use ur tokens 

    function allowance(address _owner, address _spender)                            // returns the amount of tokens
        external                                                                    // that approved one can spend
        view                                                                        // from the account
        returns (uint256);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);     // emited when tokens are transfered

    event Approval(                                                                 
        address indexed _owner,                                                     
        address indexed _spender,
        uint256 _value
    );                                                                              // emited when approve function is done
}
