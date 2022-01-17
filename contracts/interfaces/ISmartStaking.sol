// SPDX-License-Identifier: MIT
/*
    Created by DeNet
*/
pragma solidity ^0.8.0;

interface ISmartStaking {
    function changeBalance(address _holderAddress, uint _balance) external;
    function getHolderStatus(address _holder) external view  returns(uint8);
}