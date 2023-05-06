// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.16;
import '@openzeppelin/contracts/ERC20/ERC20.sol';

contract CustomToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name , symbol) {
        _mint(msg.sender, 10000 * 10**18);
    }
}

contract Kswap {
    mapping (string => string) public tokenMap;
    tokenMap["CoinA"] = "CNA";
    tokenMap["CoinB"] = "CNB";
    tokenMap["CoinC"] = "CNC";

    string[] public tokens = ["CoinA","CoinB","CoinC"];
    mapping (string => ERC20) public tokenInstanceMap;
    uint ethValue = 0.0001 * 10**18;
    constructor() {
        for (uint i = 0; i<tokens.length; i++) {
            CustomToken token = new CustomToken(tokens[i], tokenMap(tokens[i]));
            tokenInstanceMap[tokens[i]] = token;
        }
    }

    function getBalance(string memory tokenName, address _address)  public view returns(uint) {
        return tokenInstanceMap[tokenName].balanceOf(_address);
    }

    function getName(string memory tokenName) public view returns(string memory) {
        return tokenInstanceMap[tokenName].name();
    }

    function getTokenAddress(string memory tokenName) public view returns(address) {
        return address(tokenInstanceMap[tokenName]);
    }

    function swapEthToToken(stirng memory tokenName) public payable returns(uint) {
        uint inputValue = msg.value;
        uint outputValue = (inputValue/ethValue) * 10**18;
        require(tokenInstanceMap[tokenName].transfer(msg.sender, outputValue));
        return outputValue;
    }

    function swapTokenToEth(string memory tokenName, uint _amount) public returns(uint)  {
        uint exactAmt = _amount / 10 ** 18;
        uint ethToBeTransferred = exactAmt * ethValue;
        tokenInstanceMap[tokenName].transferFrom(msg.sender, address(this), _amount);
        payable(msg.sender).transfer(ethToBeTransferred);
        return ethToBeTransferred;
    }
    function swapTokens(string memory token1, string memory token2, uint _amount) public {
        tokenInstanceMap[token1].transferFrom(msg.sender, address(this), _amount);
        tokenInstanceMap[token2].transfer(msg.sender, _amount);
    }

    function getEthBalance() public view returns(uint) {
        return address(this).balance;
    }
}