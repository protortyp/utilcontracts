pragma solidity 0.6.6;


/**
 * @title Utils
 * @dev This contract is used to combine multiple web3 node calls into
 *      preferrably one single call.
 * @author Christian Engel - @chrsengel
 */
contract Utils {
  /**
   * @dev Get balances of an owner.
   * This includes ERC20 tokens or ether. To get the ETH balance
   * the token must be address(0x0).
   *
   * @param _tokens the tokens
   * @param _owner the owner address
   */
  function getBalances(address[] memory _tokens, address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256[] memory balances = new uint256[](_tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      if (_tokens[i] == address(0x0)) {
        balances[i] = address(_owner).balance;
      } else {
        balances[i] = MultiToken(_tokens[i]).balanceOf(_owner);
      }
    }
    return balances;
  }

  /**
   * @dev Get both the cToken balance and the underlying balance for a list of cTokens
   *
   * @param _tokens the cTokens
   * @param _owner the owner address
   */
  function getCompoundBalances(address[] memory _tokens, address _owner)
    public
    returns (uint256[] memory, uint256[] memory)
  {
    uint256[] memory balances = new uint256[](_tokens.length);
    uint256[] memory underlying = new uint256[](_tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      balances[i] = MultiToken(_tokens[i]).balanceOf(_owner);
      underlying[i] = MultiToken(_tokens[i]).balanceOfUnderlying(_owner);
    }
    return (balances, underlying);
  }

  /**
   * @dev Get the current supply rates of all cTokens.

   * This can be used to quickly calculate all APYs of all cTokens.
   *
   * APY = (SUPPLY_RATE * BLOCKS_PER_YEAR) / 1e18
   *
   * @param _tokens the cTokens
   */
  function getSupplyRates(address[] memory _tokens) public view returns (uint256[] memory) {
    uint256[] memory supplyRates = new uint256[](_tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      supplyRates[i] = MultiToken(_tokens[i]).supplyRatePerBlock();
    }
    return supplyRates;
  }

  /**
   * @dev Get the current borrow rates of all cTokens.
   *
   * @param _tokens the cTokens
   */
  function getBorrowRates(address[] memory _tokens) public view returns (uint256[] memory) {
    uint256[] memory borrowRates = new uint256[](_tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      borrowRates[i] = MultiToken(_tokens[i]).borrowRatePerBlock();
    }
    return borrowRates;
  }
}


/**
 + @title MultiToken
 * @dev Multi token interface that can be used to interact with cToken and
 *      other ERC20 contracts.
 */
interface MultiToken {
  function supplyRatePerBlock() external view returns (uint256);

  function borrowRatePerBlock() external view returns (uint256);

  function balanceOfUnderlying(address account) external returns (uint256);

  function balanceOf(address owner) external view returns (uint256);
}
