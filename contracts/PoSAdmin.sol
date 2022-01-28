// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    Contract is modifier only
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPoSAdmin.sol";

contract PoSAdmin  is IPoSAdmin, Ownable {
    address public proofOfStorageAddress = address(0);
    mapping(address => bool) _isGateway;
    
    constructor (address _pos) {
        proofOfStorageAddress = _pos;
    }

    modifier onlyPoS() {
        require(msg.sender == proofOfStorageAddress, "PoSAdmin: Denied by onlyPos");
        _;
    }

    modifier onlyGateway() {
        require(_isGateway[msg.sender], "PoSAdmin: Denied by onlyGateway");
        _;
    }

    function changePoS(address _newAddress) public onlyOwner {
        proofOfStorageAddress = _newAddress;
        emit ChangePoSAddress(_newAddress);
    }

    function addGateway(address account) public onlyOwner {
        _isGateway[account] = true;
    }

    function delGateway(address account) public onlyOwner {
        _isGateway[account] = false;
    }

}