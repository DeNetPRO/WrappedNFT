// SPDX-License-Identifier: MIT

/*
    Created by DeNet
*/

pragma solidity ^0.8.0; 

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MultiSender is Ownable {
    
    mapping (address=>bool) _gateway;
    address _token;

    constructor (address ercToken) {
        _token = ercToken;
    }

    modifier onlyGate() {
        require(_gateway[msg.sender], "Access denied by PoS");
        _;
    }

    function addGate(address _new) public onlyOwner {
        _gateway[_new] = true;
    }

    function delGate(address _old) public onlyOwner {
        _gateway[_old] = false;
    }

    function commitOnly(address _reciever, uint _amount) public onlyGate {
        IERC20 tok = IERC20(_token);
        tok.transfer(_reciever, _amount);
    }

    function commitMany(address[] calldata _reciever, uint[] calldata _amount) public onlyGate {
        IERC20 tok = IERC20(_token);
        for (uint i = 0; i < _reciever.length; i = i + 1) {
            tok.transfer(_reciever[i], _amount[i]);
        }
    }
}