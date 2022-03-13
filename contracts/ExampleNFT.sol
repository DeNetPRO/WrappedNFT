// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    WNFT - Wrapped NFT made for NFT Staking program in DeNet

    Minimal register size of NFT ~1MB
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract ExampleNFT is ERC721Enumerable {

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
    }

    uint private _counter = 0;
    mapping (uint=>string) _tokenURI;

    function mintMe(string calldata uri) public {
        _counter = _counter + 1;
        _safeMint(msg.sender, _counter);
        _tokenURI[_counter] = uri;
    }

    function mintFor(address _reciever, string calldata uri) public{
        _counter = _counter + 1;
        _safeMint(msg.sender, _counter);
        _tokenURI[_counter] = uri;
    }

    /**
     * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
     */
    function tokenURI(uint tokenId) public view override returns (string memory) {
        return _tokenURI[tokenId];
    }

    function counter() public view returns (uint) {
        return _counter;
    }

}
