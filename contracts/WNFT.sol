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
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./PoSAdmin.sol";
import "./interfaces/IWNFT.sol";

contract Wrapper is PoSAdmin, IWrapper, ERC721Enumerable {
    using SafeMath for uint;
    /**
        @dev Address of TB Token
    */
    address private _rewardTokenAddress;

    constructor (address tbAddress) ERC721("DeNet WrappedNFT", "WNFT") PoSAdmin(address(0)) {
        _rewardTokenAddress = tbAddress;
    }
    
    uint256 private _totalSupply = 1;
    uint256 private _totalTraffic = 0;
    uint public referalFee = 500; // 5% 
    uint public feePoint = 10000;

    mapping (uint => WrappedStruct) _wrappedData;

    /**
        @dev keccak(origin.address + origin.id) => WNFT Pointer
        
        First mint - binding pointer
        Burn - (storing porinter)
        Second mint - mint with old pointer
    */
    mapping (bytes32 => uint) wrappedPointer;

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
                _wrappedData[_tokenId[i]].traffic = _wrappedData[_tokenId[i]].traffic.add(_traffic[i]);
                _totalTraffic = _totalTraffic.add(_traffic[i]);
            }
        }
        uint charged = _totalTraffic.sub(_trafficBefore).mul(referalFee).div(feePoint).div(1073741824).mul(10e18);

        IERC20 token = IERC20(_rewardTokenAddress);
        token.transferFrom(msg.sender, address(this),  charged);
    }

    /**
        @dev return full metadata, for external apps can be expensive to check, but retuns full info
    */
    function getMetaData(uint _tokenId) public view override returns(WrappedStruct memory) {
        return _wrappedData[_tokenId];
    }

    /**
        @dev (NFT.traffic - NFT.payedTraffic) x this.tbBalance / totalTraffic
        @param _itemId - NFT token id
        @return TB balance of this token
    */
    function getNFTBalance(uint _itemId) public view override returns(uint) {
        IERC20 token = IERC20(_rewardTokenAddress);
        uint curBalance = token.balanceOf(address(this));
        uint share =  _wrappedData[_itemId].traffic.sub(_wrappedData[_itemId].payedTraffic).mul(curBalance).div(_totalTraffic);
        if (share < 953674316406) return 0; // means less 1 MB reward == 1 TB.div(2.pow(20)) == 953674316406
        return share;
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint tokenId) public view override returns (string memory) {
        return _wrappedData[tokenId].URI;
    }

    /**
    * @dev Return the content hash of resourse for `tokenId`.
    */
    function tokenContentHash(uint tokenId) public view override returns (bytes32) {
        return _wrappedData[tokenId].contentHash;
    }
    
    /**
        @dev _totalSupply - total amount of supplied WNFT's
    */
    function totalSupply() public view override returns(uint) {
        return _totalSupply;
    }

    /**
        @dev Owner of item can get collected reward
        Check owner of itemId, no need to check _exist, because in exist check owner != 0
        @notice Approved operator can claim reward on own address
    */
    function claimReward(uint _itemId) public override whenNotPaused {
        require(ownerOf(_itemId) == msg.sender || isApprovedForAll(ownerOf(_itemId), msg.sender), "claim: not owner or approved");
        /*
            Check, if it NFT not burned and owner = address of WNFT
        */
        ERC721 origin = ERC721(_wrappedData[_itemId].oldAddress);
        require(origin.ownerOf(_wrappedData[_itemId].tokenId) == address(this), "claim: origin.owner !+ this.governanceAddress");
        uint amountReturns = getNFTBalance(_itemId);
        if (amountReturns > 0) {
            _wrappedData[_itemId].payedTraffic = _wrappedData[_itemId].traffic;
            IERC20 token = IERC20(_rewardTokenAddress);
            token.transfer(msg.sender, amountReturns);
        }
    }

    /**
        @dev Claim many
        @param _itemIds - array of NFTids owned by user
    */
    function claimRewardMany(uint[] calldata _itemIds) public override whenNotPaused {
        for (uint i = 0; i < _itemIds.length; i = i + 1) {
            claimReward(_itemIds[i]);
        }
    }

    /**
        @dev Make NFT as WrappedNFT

        1. Check is approved
        2. Check is sender == owner
        3. Create pointer: keccak(address, token_id)
        4. Create wrapped NFT
    */
    function wrap(address _contract, uint256 tokenId, bytes32 _contentHash, string calldata _DeNetStorageURI, uint contentSize) public override whenNotPaused {
        IERC721 origin = IERC721(_contract);
        require(origin.getApproved(tokenId) == address(this), "wrap: Not approved");
        require(origin.ownerOf(tokenId) == msg.sender,"wrap: sender not owner");
        uint pointer = uint(keccak256(
                    abi.encodePacked(
                        _contract, bytes32(tokenId)
                    )
                ));
        
        _safeMint(msg.sender, pointer);
        _wrappedData[pointer].URI = _DeNetStorageURI;
        _wrappedData[pointer].contentSize = contentSize;
        _wrappedData[pointer].oldAddress = _contract;
        _wrappedData[pointer].tokenId = tokenId;
        _wrappedData[pointer].contentHash = _contentHash;
        _wrappedData[pointer].burned = false;
        _wrappedData[pointer].traffic = 1; // one megabyte of data traffic base

        _totalTraffic = _totalTraffic.add(1);
        origin.safeTransferFrom(msg.sender, address(this), tokenId);
        require(origin.ownerOf(tokenId) == address(this), "wrap: fail transferfrom");

        _totalSupply = _totalSupply + 1;
    }

    /**
        @dev SafeTransferFrom require this function
    */
    function onERC721Received(
        address _operator,
        address _from,
        uint256 _tokenId,
        bytes calldata _data ) public view returns(bytes4) {
            // acception tokens for transfer
            return 0x150b7a02;
    }

    /**
        @dev unwrap and burn

        1. Sender == Owner
        2. Transfer to Sender
        3. Burn wrapped
    */
    function unwrap(uint tokenId) public override whenNotPaused {
        require(ownerOf(tokenId) == msg.sender, "unwrap: sender not owner of token");
        claimReward(tokenId);
        IERC721 origin = IERC721(_wrappedData[tokenId].oldAddress);
        origin.transferFrom(address(this), msg.sender, _wrappedData[tokenId].tokenId);
        _wrappedData[tokenId].burned = true;
        _totalTraffic = _totalTraffic.sub(_wrappedData[tokenId].traffic);
        _burn(tokenId);
    }
}