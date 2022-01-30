// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    WNFT - Wrapped NFT made for NFT Staking program in DeNet

    Minimal register size of NFT ~1MB
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
                require(_traffic[i] > 0, "collectTraffic: traffic == 0");
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
        if (share < 931322574) return 0; // means less 1 MB reward
        return share;
    }
    
    /**
        @dev wrappedSupply - amount of minted wrapped tokens
    */
    function wrappedSupply() public view returns(uint) {
        return _wrappedSupply;
    }

    /**
        @dev Owner of item can get collected reward
        Check owner of itemId, no need to check _exist, because in exist check owner != 0
    */
    function claimReward(uint _itemId) public whenNotPaused {
        require(ownerOf(_itemId) == msg.sender, "claim: not owner");
        /*
            Check, if it NFT not burned and owner = address of WNFT
        */
        ERC721 origin = ERC721(wrappedData[_itemId].oldAddress);
        require(origin.ownerOf(wrappedData[_itemId].tokenId) == address(this), "claim: origin.owner !+ this.governanceAddress");
        uint amountReturns = getNFTBalance(_itemId);
        if (amountReturns > 0) {
            wrappedData[_itemId].payedTraffic = wrappedData[_itemId].traffic;
            IERC20 token = IERC20(_TBAddress);
            token.transfer(msg.sender, amountReturns);
        }
    }

    /**
        @dev Claim many
        @param _itemIds - array of NFTids owned by user
    */
    function claimRewardMany(uint[] calldata _itemIds) public whenNotPaused {
        for (uint i = 0; i < _itemIds.length; i = i + 1) {
            claimReward(_itemIds[i]);
        }
    }
    
    /**
        @dev keccak(origin.address + origin.id) => WNFT id
    */
    mapping (bytes32 => uint) wrappedPointer;

    /**
        @dev Make NFT as WrappedNFT

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
        origin.safeTransferFrom(msg.sender, address(this), tokenId);
        require(origin.ownerOf(tokenId) == address(this), "wrap: fail transferfrom");
    }

    /**
        @dev SafeTransferFrom require this function
    */
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data ) public view returns(bytes4) {
            uint itemId = wrappedPointer[
                    keccak256(
                        abi.encodePacked(
                            msg.sender,
                            bytes32(_tokenId)
                        )
                    )
                ];
            require(itemId
                 != 0, "reciever: Not found NFT");
            require(_from == ownerOf(itemId), "reciever: not Owner");
            return 0x150b7a02;
    }

    /**
        @dev helpful for external games or apps to check, that WNFT is original NFT
        
        other contract calls to getPointer(_tokenId) => keccak(origin.address + origin.id)
    */
    function getPointer(uint _tokenId) public view returns(bytes32) {
        return keccak256(
            abi.encodePacked(
                    wrappedData[_tokenId].oldAddress,
                    bytes32(wrappedData[_tokenId].tokenId)
        ));
    }

    /**
        @dev return full metadata, for external apps can be expensive to check, but retuns full info
    */
    function getMetaData(uint _tokenId) public view returns(WrappedStruct memory) {
        return wrappedData[_tokenId];
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

    function safeMigrate(uint[] calldata _itemIds) public whenPaused onlyGovernance {
        require(newAddress != address(0), "safeMigrate: newAddress not set");
        IWrapper _contract = IWrapper(newAddress);
        for (uint i = 0; i < _itemIds.length; i++) {
            // approve for transfer from
            IERC721 origin = IERC721(wrappedData[_itemIds[i]].oldAddress);
            if (origin.ownerOf(wrappedData[_itemIds[i]].tokenId) == address(this)) {
                origin.approve(newAddress, wrappedData[_itemIds[i]].tokenId);
                _contract.MigrateWNFT(wrappedData[_itemIds[i]]);
            }
        }
    }
    /**
        @dev For future updates migration function
    */
    function MigrateWNFT(WrappedStruct calldata _item) public override onlyOldAddress  {
        IERC721 origin = IERC721(_item.oldAddress);
        require(origin.ownerOf(_item.tokenId) == msg.sender, "migrate: sender not owner");
    }
}