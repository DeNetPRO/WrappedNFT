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

    /**
        @dev Owner of item can get collected reward
        Check owner of itemId, no need to check _exist, because in exist check owner != 0
    */
    function claimReward(uint _itemId) external;

    /**
        @dev Claim many
        @param _itemIds - array of NFTids owned by user
    */
    function claimRewardMany(uint[] calldata _itemIds) external;

    /**
        @dev Make NFT as WrappedNFT

        1. Check is approved
        2. Check is sender == owner
        3. Create pointer: keccak(address, token_id)
        4. Create wrapped NFT
    */
    function wrap(
        address _contract,
        uint256 tokenId,
        bytes32 _contentHash,
        string calldata _DeNetStorageURI,
        uint contentSize) external;

    /**
        @dev unwrap and burn

        1. Sender == Owner
        2. Transfer to Sender
        3. Burn wrapped
    */
    function unwrap(uint tokenId) external;
    
    /**
        @dev return Content Hash of NFT
    */
    function tokenContentHash(uint _itemId) external view returns(bytes32);

    /**
        @dev returns NFT Balanc of earned tokens
    */
    function getNFTBalance(uint _itemId) external view returns(uint);
    
    /**
        @dev return full metadata, for external apps can be expensive to check, but retuns full info
    */
    function getMetaData(uint _tokenId) external view returns(WrappedStruct memory);
}