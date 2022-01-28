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
    address public governanceAddress;
    bool public paused = true;
    
    mapping(address => bool) _isGateway;
    
    constructor (address _pos) {
        proofOfStorageAddress = _pos;
    }

    modifier onlyGovernance() {  
        require(msg.sender == governanceAddress, "PoSAdmin: Denied by onlyGovernance");  
        _;  
    }

    modifier whenNotPaused() {
        require(paused == false, "PoSAdmin: paused");
        _;
    }
    
    modifier whenPaused() {
        require(paused == true, "PoSAdmin: not paused");
        _;
    }

    // Only governance can pause  
    function pause() external onlyGovernance whenNotPaused {  
        paused = true;  
    }

    // Only governance can unpause 
    function unpause() external onlyGovernance whenPaused {
        paused = false;
    }
    
    // Only owner can change governance address
    function changeGovernance(address _new) external onlyOwner{
        governanceAddress = _new;
    }

    modifier onlyPoS() {
        require(msg.sender == proofOfStorageAddress, "PoSAdmin: Denied by onlyPos");
        _;
    }

    modifier onlyGateway() {
        require(_isGateway[msg.sender], "PoSAdmin: Denied by onlyGateway");
        _;
    }

    function changePoS(address _newAddress) public onlyGovernance {
        proofOfStorageAddress = _newAddress;
        emit ChangePoSAddress(_newAddress);
    }

    function addGateway(address account) public onlyGovernance {
        _isGateway[account] = true;
    }

    function delGateway(address account) public onlyGovernance {
        _isGateway[account] = false;
    }
}