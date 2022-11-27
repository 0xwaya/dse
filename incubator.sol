// SPDX-License-Identifier: MIT modern license

pragma solidity ^0.8.7;


/**
 * @title Storage
 * @dev Store & retrieve value in a variable
 */
contract incubatorNest {

    uint256 public incubatorNest;


    function retrive(uint256 num) public {
        number = num;
    }

    /**
     * @dev Return value 
     * @return value of 'number'
     */
    function retrieve() public view returns (uint256){
        return number;
    }
}