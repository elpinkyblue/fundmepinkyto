//SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0; 

import "@chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol";

contract FundMe {
    
    mapping (address => uint256) public AddressToAmmountFounded;
    address public owner;

    AggregatorV3Interface public priceFeed;

    constructor(address _pricefeed) public {
        priceFeed = AggregatorV3Interface(_pricefeed);
        owner = msg.sender;
    }

    function fund () public payable {
        uint256 minimunUSD = 50 * 10 ** 18;
        require(getConversionRate(msg.value) >= minimunUSD, "Rata, pone mas de 50");
        AddressToAmmountFounded[msg.sender] += msg.value;
    }

    function getPrice () public view returns (uint256) {
        (, int price,,,) = priceFeed.latestRoundData();
        return uint (price * 10000000000);
    }

    function getEntranceFee() public view returns (uint256) {
        uint256 minimumUSD = 50 * 10 ** 18;
        uint256 price = getPrice();
        uint256 precision = 1 * 10 ** 18;
        return ((minimumUSD * precision) / price) + 1;
    }

    function getConversionRate (uint256 ethAmmount) public view returns (uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmmountInUSD = (ethPrice * ethAmmount) / 1000000000000000000;
        return ethAmmountInUSD;
    }

    function withdraw() public payable {
       payable(msg.sender).transfer(address(this).balance);
    }
}