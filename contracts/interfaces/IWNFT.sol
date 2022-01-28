// SPDX-License-Identifier: MIT
/*
    Created by DeNet
*/

pragma solidity ^0.8.0;

interface IWrapper {
    struct WrappedStruct {
        string URI;
        uint contentSize; // in bytes
        uint traffic; // uint traffic 
        uint payedTraffic; // Amount of tokens TB/Year
        bytes32 contentHash; // Hash of content
        address oldAddress; // address of old collection
        uint tokenId; // id of old collection
        bool burned; // is it burned;
    }
}