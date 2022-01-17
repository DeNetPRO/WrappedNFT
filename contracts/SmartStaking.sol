// SPDX-License-Identifier: MIT
/*
    Created by DeNet

    DeMet Smart Staking

    This is contract for reward smart holders in DeNet File Token
*/

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./interfaces/ISmartStaking.sol";

contract SmartStaking is Ownable, ISmartStaking {
    using SafeMath for uint256;

    mapping (address => uint) public holderShare;
    mapping (address => uint) public holderPurschasedBalance; // Withdrawed tokens
    mapping (address => uint) public holderdBalance; // Amount of tokens in balance
    
    mapping (address => uint8) public holderStatus; 

    uint public constant SHARES_RATIO =  100000; // 100%
    uint public constant LOST_PROFIT = 10000; // 10% to loose profit from exitors of next years
    uint public constant LOST_STAKING = 30000; // 30% to loose staking from next years forever

    function _dropFromStaking(address _holderAddress) internal {
        holderStatus[_holderAddress] = 2;
    }

    function _dropFromProfit(address _holderAddress) internal {
        holderStatus[_holderAddress] = 1;
    }

    /**
    *    @return uint9 (0-2): 0 - Extra is availalbe, 1 - Loose extra, 2 - Loose All
    */
    function getHolderStatus(address _holder) public view override returns(uint8) {
        return holderStatus[_holder];
    }

    /*
        function called from DeNetFile Token Contract, when balance updated
    */
    function changeBalance(address _holderAddress, uint _balance) public override onlyOwner {
        holderdBalance[_holderAddress] = _balance;
        if (_balance < holderPurschasedBalance[_holderAddress]) {
            uint _pBal = holderPurschasedBalance[_holderAddress];
            
            if (holderStatus[_holderAddress] < 1) {
                if (_pBal.mul(LOST_PROFIT).div(SHARES_RATIO) < _balance.sub(_pBal)) {
                    _dropFromProfit(_holderAddress);
                }
            }

            if (holderStatus[_holderAddress] < 2) {
                if (_pBal.mul(LOST_STAKING).div(SHARES_RATIO) < _balance.sub(_pBal)) {
                    _dropFromStaking(_holderAddress);
                }
            }
        }
    }
}