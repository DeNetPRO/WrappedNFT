// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    WNFT - Wrapped NFT made for NFT Staking program in DeNet

    Minimal register size of NFT ~1MB
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ExampleNFT is ERC721 {

    constructor (string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        mintMe();
    }

    uint private _counter = 0;

    function mintMe() public {
        _counter = _counter + 1;
        _safeMint(msg.sender, _counter);
    } 

    function counter() public view returns (uint) {
        return _counter;
    }

}
