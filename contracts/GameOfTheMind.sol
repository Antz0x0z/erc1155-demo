// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract GameOfTheMind is ERC1155, Ownable {

    string public name;
    string public symbol;

    uint256 private count;
    uint256 private i = 1;
    uint256 private z = 20;

    mapping (uint256 => mapping(address => uint256)) private _balances;
    mapping (uint256 => uint256) public tokenSupply;
    mapping (uint256 => address) private _owners;
    mapping (uint256 => string) private _tokenURI;

    struct Item {
        uint tokenId;
        address tokenHolder;
    }
    Item[] items;

    constructor() ERC1155("ipfs://bafybeifllg7g7hn2yspsqg7qh7757eidg646aipjigihzlvovio6pzutye/{id}.json") {
        name = "NOW BAYC Demo Tokens";
        symbol = "MNKY";
        count = z - i;
        for(i; i<z; i++){
            items.push(Item(i, msg.sender));
            require(_hasMinted(), "Already minted cheater!");
            tokenSupply[i]++;
            _mint(msg.sender, i, 1, "");
            }
    }
    function _mint(
        address _to,
        uint256 _id,
        uint256 _quantity,
        bytes memory _data
    ) internal override {
        super._mint(_to, _id, _quantity, _data);
        if (_data.length > 1) {
            _setURI(_id, string(_data));
        }
    }
    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(
            abi.encodePacked(
                "ipfs://bafybeifllg7g7hn2yspsqg7qh7757eidg646aipjigihzlvovio6pzutye/",
                Strings.toString(_tokenid),".json"
            )
        );
    }

    function getTokenId() external view returns(Item[] memory) {
        return items;
    }

    function _setURI(uint256 _id, string memory _uri) internal {
        _tokenURI[_id] = _uri;
        emit URI(_uri, _id);
    }

    function totalMinted() public view returns (uint256) {
        return count;
    } 

    function totalSupply(uint256 id) public view returns (uint256) {
        return tokenSupply[id];
    }

    function _hasMinted() private view returns (bool) {
        return
            ((balanceOf(msg.sender, i) + balanceOf(msg.sender, z)) > 0)
                ? false
                : true;
    }

    function _burn(
        address account,
        uint256 id,
        uint256 amount
    ) override internal virtual {
        require(account != address(0), "ERC1155: burn from the zero address");

        address operator = _msgSender();

        _beforeTokenTransfer(operator, account, address(0), asSingletonArray(id), asSingletonArray(amount), "");

        uint256 accountBalance = _balances[id][account];
        require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
        unchecked {
            _balances[id][account] = accountBalance - amount;
        }

        emit TransferSingle(operator, account, address(0), id, amount);
    }
    function asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
        uint256[] memory array = new uint256[](1);
        array[0] = element;

        return array;
    }
}