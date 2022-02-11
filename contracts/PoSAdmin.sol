// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/IPoSAdmin.sol";

/**
    @dev Contract PoSAdmin - modifier for ProofOfStorage API's
*/

contract PoSAdmin  is IPoSAdmin, Ownable {
    address public proofOfStorageAddress = address(0);
    address public governanceAddress;
    
    /**
        @dev Address of TB Token
    */
    address public _rewardTokenAddress;

    bool public paused = true;
    
    mapping(address => bool) _isGateway;
    
    constructor (address _pos, address _reward) {
        proofOfStorageAddress = _pos;
        _rewardTokenAddress = _reward;
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
        paused = true;
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
    
    /**
        @dev Possibility update token address for next updates, will removed at finalized version
    */
    function updateRewardTokenAddress(address _new) public onlyGovernance {
        _rewardTokenAddress = _new;
    }
}