// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    (DFILE) is  DeNet File Token contract
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "./ERC20Vesting.sol";

contract DFILEToken is Ownable, ERC20 {
    using SafeMath for uint256;

    uint public tenYearsSupply = 1000000000000000000000000000;
    uint public currentSupply = 0;
    uint public thisYearSupply = 0;
    uint public timeNextYear = 0;
    uint public currentYear = 0;
    
    address public treasury = address(0);
    /* 
        Year supply
        1    | 2    | 3    | 4    | 5    | 6    | 7    | 8    | 9    | 10
        145  | 128  | 121  | 112  | 104  | 95   | 87   | 79   | 71   | 58
        145M | 273M | 394M | 506M | 610M | 705M | 792M | 871M | 942M | 1B 
    */
    uint[10] public supplyOfYear = [
        145000000000000000000000000,
        128000000000000000000000000,
        121000000000000000000000000,
        112000000000000000000000000,
        104000000000000000000000000,
        95000000000000000000000000,
        87000000000000000000000000,
        79000000000000000000000000,
        71000000000000000000000000, 
        58000000000000000000000000
    ];
    address[10] public vestingOfYear;

    /*
        100000 = 100%
        1000 = 1%
        100 = 0.1%
        10 = 0.01%
        1 = 0.001%
    */
    uint public sharesRatio =  100000;

    mapping (address => uint) public shares;
    mapping (uint32 => address) public sharesVector;
    uint32 public sharesCount = 0;
    uint public sharesAvailable = sharesRatio;

    /*
        Add Shares
    */
    function addShares(address _reciever, uint _size) public onlyOwner {
        require(sharesAvailable.sub(_size) > 0, "Wrong size");
        require(_size > 0, "Size < 0");

        if (shares[_reciever] == 0) {
            sharesVector[sharesCount] = _reciever;
            sharesCount = sharesCount + 1;
        }
        
        shares[_reciever] = shares[_reciever].add(_size);
        sharesAvailable = sharesAvailable.sub(_size);
    }

    /*
        Remove Shares
    */
    function removeShares(address _reciever, uint _size) public onlyOwner {
        require(shares[_reciever].sub(_size) >= 0, "Shares < _size");
        shares[_reciever] = shares[_reciever].sub(_size);
        sharesAvailable = sharesAvailable.add(_size);
    }

    constructor () ERC20("DeNet FIle Token", "DFILE") {
        _mint(address(this), tenYearsSupply);
    }

    /*
        @dev Minting year supply with shares and vesting
        
    */
    function smartMint() public onlyOwner {
        require(block.timestamp > timeNextYear, "Time is not available");
        require(sharesCount > 0, "Shares count = 0");
        uint _amount = supplyOfYear[currentYear];
        require(currentSupply.add(_amount) <= tenYearsSupply, "amount > available");
        uint transfered = 0;
        ERC20Vesting theVesting = new ERC20Vesting(address(this));
        vestingOfYear[currentYear] = address(theVesting);
        IERC20 thisToken = IERC20(address(this));
        thisToken.transfer(address(theVesting), _amount);

        for (uint32 i = 0; i < sharesCount; i = i + 1) {
            uint sendAmount = _amount.mul(shares[sharesVector[i]]).div(sharesRatio);
            theVesting.createVesting(sharesVector[i], uint64(block.timestamp), uint64(block.timestamp + 31536000), sendAmount);
            transfered = transfered.add(sendAmount);
        }

        require(treasury != address(0), "This year treasury not set!");
        uint _treasuryAmount = _amount.sub(transfered);
        theVesting.createVesting(treasury, uint64(block.timestamp), uint64(block.timestamp + 31536000), _treasuryAmount);
        
        transfered = transfered.add(_treasuryAmount);
        /*
            Make for next year
                1. reset treasury address
                2. nextTime + 365 days
                3. currentYear++
        */

        treasury = address(0);
        timeNextYear = block.timestamp + 31536000; // move next year;
        currentYear = currentYear + 1;
    }

    function setTreasury(address _new) public onlyOwner {
        require(_new != address(0), "_new = zero");
        require(_new != address(this), "_new = this");

        treasury = _new;
    }
}