// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    WNFT - Wrapped NFT made for NFT Staking program in DeNet
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PoSAdmin.sol";
import "./interfaces/IWNFT.sol";

contract Wrapper is PoSAdmin, ERC721, IWrapper {
    using SafeMath for uint;

    constructor (address tbAddress) ERC721("DeNet WrappedNFT", "WNFT") PoSAdmin(address(0)) {
        _TBAddress = tbAddress;
    }
    
    uint256 private _wrappedSupply = 1;
    uint256 private _totalTraffic = 0;
    address private _TBAddress;
    uint public referalFee = 500; // 5% 
    uint public feePoint = 10000;

    mapping (uint => WrappedStruct) wrappedData;
   
    /**
        @dev Collect Traffic to NFT's and transfer referalFee to this contract
        @param length uint - size of arrays
        @param _tokenId - array of token ids [1,2,3]
        @param _traffic - array of amount of bytes [1024^3, 5x1024^3, 10x1024^3]
    */
    function collectTraffic(uint length, uint[] calldata _tokenId, uint[] calldata _traffic) public onlyGateway whenNotPaused {
        uint _trafficBefore = _totalTraffic;
        for (uint i = 0; i < length; i = i + 1) {
            if (_exists(_tokenId[i])) {
                wrappedData[_tokenId[i]].traffic = wrappedData[_tokenId[i]].traffic.add(_traffic[i]);
                _totalTraffic = _totalTraffic.add(_traffic[i]);
            }
        }
        uint charged = _totalTraffic.sub(_trafficBefore).mul(referalFee).div(feePoint).div(1073741824).mul(10e18);

        IERC20 token = IERC20(_TBAddress);
        token.transferFrom(msg.sender, address(this),  charged);
    }

    /**
        @dev (NFT.traffic - NFT.payedTraffic) x this.tbBalance / totalTraffic
        @param _itemId - NFT token id
        @return TB balance of this token
    */
    function getNFTBalance(uint _itemId) public view returns(uint) {
        IERC20 token = IERC20(_TBAddress);
        uint curBalance = token.balanceOf(address(this));
        uint share =  wrappedData[_itemId].traffic.sub(wrappedData[_itemId].payedTraffic).mul(curBalance).div(_totalTraffic);
        return share;
    }

    function claimReward(uint _itemId) public whenNotPaused {
        require(ownerOf(_itemId) == msg.sender, "claim: not owner");
        uint amountReturns = getNFTBalance(_itemId);
        wrappedData[_itemId].payedTraffic = wrappedData[_itemId].traffic;

        IERC20 token = IERC20(_TBAddress);
        token.transfer(msg.sender, amountReturns);
    }

    function getPointer(uint _tokenId) public view returns(bytes32) {
        return keccak256(
            abi.encodePacked(
                    wrappedData[_tokenId].oldAddress,
                    bytes32(wrappedData[_tokenId].tokenId)
        ));
    }
    
    mapping (bytes32 => uint) wrappedPointer;

    /**
        @dev Do it!

        1. Check is approved
        2. Check is sender == owner
        3. Create pointer: keccak(address, token_id)
        4. Create wrapped NFT
    */
    function wrap(address _contract, uint256 tokenId, bytes32 _contentHash, string calldata _DeNetStorageURI, uint contentSize) public whenNotPaused {
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
        wrappedData[curTokenId].traffic = 1; // one megabyte of data traffic base

        _totalTraffic = _totalTraffic.add(1);
    }

    /**
        @dev unwrap and burn

        1. Sender == Owner
        2. Transfer to Sender
        3. Burn wrapped
    */
    function unwrap(uint tokenId) public whenNotPaused {
        require(ownerOf(tokenId) == msg.sender, "unwrap: sender not owner of token");
        claimReward(tokenId);
        IERC721 origin = IERC721(wrappedData[tokenId].oldAddress);
        origin.transferFrom(address(this), msg.sender, wrappedData[tokenId].tokenId);
        wrappedData[tokenId].burned = true;
        _totalTraffic = _totalTraffic.sub(wrappedData[tokenId].traffic);
        _burn(tokenId);
    }
}