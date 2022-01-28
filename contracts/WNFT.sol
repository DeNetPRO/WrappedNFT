// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    WNFT - Wrapped NFT made for NFT Staking program in DeNet
*/

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract Wrapper is Ownable, ERC721 {
    using SafeMath for uint;

    constructor () ERC721("DeNet WrappedNFT", "WNFT") {}
    
    uint256 private _wrappedSupply = 1;
    uint256 private _totalTraffic = 0;

    struct WrappedStruct {
        string URI;
        uint contentSize; // in bytes
        uint traffic; // uint traffic 
        uint balance; // Amount of tokens TB/Year
        bytes32 contentHash; // Hash of content
        address oldAddress; // address of old collection
        uint tokenId; // id of old collection
        bool burned; // is it burned;
    }

    function getPointer(uint _tokenId) public view returns(bytes32) {
        return keccak256(
            abi.encodePacked(
                    wrappedData[_tokenId].oldAddress,
                    bytes32(wrappedData[_tokenId].tokenId)
        ));
    }
    
    mapping (uint => WrappedStruct) wrappedData;
    mapping (bytes32 => uint) wrappedPointer;

    /**
        @dev Do it!

        1. Check is approved
        2. Check is sender == owner
        3. Create pointer: keccak(address, token_id)
        4. Create wrapped NFT
    */
    function wrap(address _contract, uint256 tokenId, bytes32 _contentHash, string calldata _DeNetStorageURI, uint contentSize) public {
        IERC721 origin = IERC721(_contract);
        require(origin.getApproved(tokenId) == address(this), "wrap: Not approved");
        require(origin.ownerOf(tokenId) == msg.sender,"wrap: sender not owner");
        bytes32 pointer = keccak256(
                    abi.encodePacked(
                        _contract, bytes32(tokenId)
                    )
                );
        uint curTokenId = 0;
        origin.safeTransferFrom(msg.sender, address(this), tokenId);
        require(origin.ownerOf(tokenId) == address(this), "wrap: fail transferfrom");


        if (wrappedPointer[pointer] != 0 ) {
            curTokenId = wrappedPointer[pointer];
        } else {
            curTokenId = _wrappedSupply;
            wrappedPointer[pointer] = curTokenId;
            _wrappedSupply = _wrappedSupply + 1;
        }
        _safeMint(msg.sender, curTokenId);
        wrappedData[curTokenId].URI = _DeNetStorageURI;
        wrappedData[curTokenId].contentSize = contentSize;
        wrappedData[curTokenId].oldAddress = _contract;
        wrappedData[curTokenId].tokenId = tokenId;
        wrappedData[curTokenId].contentHash = _contentHash;
        wrappedData[curTokenId].burned = false;
        wrappedData[curTokenId].traffic = 1048576; // one megabyte of data traffic base

        _totalTraffic = _totalTraffic.add(1048576);
    }

    /**
        @dev unwrap and burn

        1. Sender == Owner
        2. Transfer to Sender
        3. Burn wrapped
    */
    function unwrap(uint tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "unwrap: sender not owner of token");
        IERC721 origin = IERC721(wrappedData[tokenId].oldAddress);
        origin.transferFrom(address(this), msg.sender, wrappedData[tokenId].tokenId);
        wrappedData[tokenId].burned = true;
        _totalTraffic = _totalTraffic.sub(wrappedData[tokenId].traffic);
        _burn(tokenId);
    }
}