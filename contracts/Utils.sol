pragma solidity 0.6.6;
pragma experimental ABIEncoderV2;


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

  /**
   * @dev Get DSR contract DAI balances for a list of users
   *
   * @param _users array of users that have DAI in the DSR contract
   * @param _pot the MCD_POT contract address
   */
  function getDSRBalances(address[] memory _users, address _pot)
    public
    view
    returns (uint256[] memory)
  {
    uint256[] memory balances = new uint256[](_users.length);

    for (uint256 i = 0; i < balances.length; i++) {
      balances[i] = Dethlify(_users[i]).getDSRBalance(_pot);
    }
    return balances;
  }

  /**
   * @dev Get the last callbacks for a list of dethlify contracts
   *
   * @param _contracts the contract addresses
   */
  function getLasts(address[] memory _contracts) public view returns (uint256[] memory) {
    uint256[] memory lasts = new uint256[](_contracts.length);
    for (uint256 i = 0; i < _contracts.length; i++) {
      lasts[i] = Dethlify(_contracts[i]).last();
    }
    return lasts;
  }

  /**
   * @dev Get the lock period for a list of dethlify contracts
   *
   * @param _contracts the contract addresses
   */
  function getLocks(address[] memory _contracts) public view returns (uint256[] memory) {
    uint256[] memory locks = new uint256[](_contracts.length);
    for (uint256 i = 0; i < _contracts.length; i++) {
      locks[i] = Dethlify(_contracts[i]).lock();
    }
    return locks;
  }

  /**
   * @dev Get the versions for a list of dethlify contracts
   *
   * @param _contracts the contract addresses
   */
  function getVersions(address[] memory _contracts) public view returns (string[] memory) {
    string[] memory versions = new string[](_contracts.length);
    for (uint256 i = 0; i < _contracts.length; i++) {
      versions[i] = Dethlify(_contracts[i]).version();
    }
    return versions;
  }

  /**
   * @dev Get the token distributions for a list of heirs
   *
   * @param _heirs list of heirs
   * @param _tokens list of tokens
   * @param _contract the contract addresses
   */
  function getDistributions(
    address[] memory _heirs,
    address[] memory _tokens,
    address _contract
  ) public view returns (string[] memory) {
    string[] memory distributions = new string[](_heirs.length * _tokens.length);
    for (uint256 i = 0; i < _tokens.length; i++) {
      for (uint256 j = 0; j < _heirs.length; j++) {
        distributions[j + _heirs.length * i] = Dethlify(_contract).tokenDistribution(_tokens[i], _heirs[j]); // prettier-ignore
      }
    }
    return distributions;
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


/**
 + @title Dethlify
 * @dev Interface for dethlify smart contracts
 */
interface Dethlify {
  function getDSRBalance(address _pot) external view returns (uint256);

  function lock() external view returns (uint256);

  function last() external view returns (uint256);

  function version() external view returns (string memory);

  function tokenDistribution(address token, address heir) external view returns (string memory);
}
