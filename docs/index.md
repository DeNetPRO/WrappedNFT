# Solidity API

## Ownable

_Contract module which provides a basic access control mechanism, where
there is an account (an owner) that can be granted exclusive access to
specific functions.
By default, the owner account will be the one that deploys the contract. This
can later be changed with {transferOwnership}.
This module is used through inheritance. It will make available the modifier
&#x60;onlyOwner&#x60;, which can be applied to your functions to restrict their use to
the owner._

### _owner

```solidity
address _owner
```

### OwnershipTransferred

```solidity
event OwnershipTransferred(address previousOwner, address newOwner)
```

### constructor

```solidity
constructor() internal
```

_Initializes the contract setting the deployer as the initial owner._

### owner

```solidity
function owner() public view virtual returns (address)
```

_Returns the address of the current owner._

### onlyOwner

```solidity
modifier onlyOwner()
```

_Throws if called by any account other than the owner._

### renounceOwnership

```solidity
function renounceOwnership() public virtual
```

_Leaves the contract without owner. It will not be possible to call
&#x60;onlyOwner&#x60; functions anymore. Can only be called by the current owner.
NOTE: Renouncing ownership will leave the contract without an owner,
thereby removing any functionality that is only available to the owner._

### transferOwnership

```solidity
function transferOwnership(address newOwner) public virtual
```

_Transfers ownership of the contract to a new account (&#x60;newOwner&#x60;).
Can only be called by the current owner._

### _setOwner

```solidity
function _setOwner(address newOwner) private
```

## ERC20

_Implementation of the {IERC20} interface.
This implementation is agnostic to the way tokens are created. This means
that a supply mechanism has to be added in a derived contract using {_mint}.
For a generic mechanism see {ERC20PresetMinterPauser}.
TIP: For a detailed writeup see our guide
https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
to implement supply mechanisms].
We have followed general OpenZeppelin Contracts guidelines: functions revert
instead returning &#x60;false&#x60; on failure. This behavior is nonetheless
conventional and does not conflict with the expectations of ERC20
applications.
Additionally, an {Approval} event is emitted on calls to {transferFrom}.
This allows applications to reconstruct the allowance for all accounts just
by listening to said events. Other implementations of the EIP may not emit
these events, as it isn&#x27;t required by the specification.
Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
functions have been added to mitigate the well-known issues around setting
allowances. See {IERC20-approve}._

### _balances

```solidity
mapping(address &#x3D;&gt; uint256) _balances
```

### _allowances

```solidity
mapping(address &#x3D;&gt; mapping(address &#x3D;&gt; uint256)) _allowances
```

### _totalSupply

```solidity
uint256 _totalSupply
```

### _name

```solidity
string _name
```

### _symbol

```solidity
string _symbol
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

_Sets the values for {name} and {symbol}.
The default value of {decimals} is 18. To select a different value for
{decimals} you should overload it.
All two of these values are immutable: they can only be set once during
construction._

### name

```solidity
function name() public view virtual returns (string)
```

_Returns the name of the token._

### symbol

```solidity
function symbol() public view virtual returns (string)
```

_Returns the symbol of the token, usually a shorter version of the
name._

### decimals

```solidity
function decimals() public view virtual returns (uint8)
```

_Returns the number of decimals used to get its user representation.
For example, if &#x60;decimals&#x60; equals &#x60;2&#x60;, a balance of &#x60;505&#x60; tokens should
be displayed to a user as &#x60;5.05&#x60; (&#x60;505 / 10 ** 2&#x60;).
Tokens usually opt for a value of 18, imitating the relationship between
Ether and Wei. This is the value {ERC20} uses, unless this function is
overridden;
NOTE: This information is only used for _display_ purposes: it in
no way affects any of the arithmetic of the contract, including
{IERC20-balanceOf} and {IERC20-transfer}._

### totalSupply

```solidity
function totalSupply() public view virtual returns (uint256)
```

_See {IERC20-totalSupply}._

### balanceOf

```solidity
function balanceOf(address account) public view virtual returns (uint256)
```

_See {IERC20-balanceOf}._

### transfer

```solidity
function transfer(address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transfer}.
Requirements:
- &#x60;recipient&#x60; cannot be the zero address.
- the caller must have a balance of at least &#x60;amount&#x60;._

### allowance

```solidity
function allowance(address owner, address spender) public view virtual returns (uint256)
```

_See {IERC20-allowance}._

### approve

```solidity
function approve(address spender, uint256 amount) public virtual returns (bool)
```

_See {IERC20-approve}.
Requirements:
- &#x60;spender&#x60; cannot be the zero address._

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public virtual returns (bool)
```

_See {IERC20-transferFrom}.
Emits an {Approval} event indicating the updated allowance. This is not
required by the EIP. See the note at the beginning of {ERC20}.
Requirements:
- &#x60;sender&#x60; and &#x60;recipient&#x60; cannot be the zero address.
- &#x60;sender&#x60; must have a balance of at least &#x60;amount&#x60;.
- the caller must have allowance for &#x60;&#x60;sender&#x60;&#x60;&#x27;s tokens of at least
&#x60;amount&#x60;._

### increaseAllowance

```solidity
function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool)
```

_Atomically increases the allowance granted to &#x60;spender&#x60; by the caller.
This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.
Emits an {Approval} event indicating the updated allowance.
Requirements:
- &#x60;spender&#x60; cannot be the zero address._

### decreaseAllowance

```solidity
function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool)
```

_Atomically decreases the allowance granted to &#x60;spender&#x60; by the caller.
This is an alternative to {approve} that can be used as a mitigation for
problems described in {IERC20-approve}.
Emits an {Approval} event indicating the updated allowance.
Requirements:
- &#x60;spender&#x60; cannot be the zero address.
- &#x60;spender&#x60; must have allowance for the caller of at least
&#x60;subtractedValue&#x60;._

### _transfer

```solidity
function _transfer(address sender, address recipient, uint256 amount) internal virtual
```

_Moves &#x60;amount&#x60; of tokens from &#x60;sender&#x60; to &#x60;recipient&#x60;.
This internal function is equivalent to {transfer}, and can be used to
e.g. implement automatic token fees, slashing mechanisms, etc.
Emits a {Transfer} event.
Requirements:
- &#x60;sender&#x60; cannot be the zero address.
- &#x60;recipient&#x60; cannot be the zero address.
- &#x60;sender&#x60; must have a balance of at least &#x60;amount&#x60;._

### _mint

```solidity
function _mint(address account, uint256 amount) internal virtual
```

_Creates &#x60;amount&#x60; tokens and assigns them to &#x60;account&#x60;, increasing
the total supply.
Emits a {Transfer} event with &#x60;from&#x60; set to the zero address.
Requirements:
- &#x60;account&#x60; cannot be the zero address._

### _burn

```solidity
function _burn(address account, uint256 amount) internal virtual
```

_Destroys &#x60;amount&#x60; tokens from &#x60;account&#x60;, reducing the
total supply.
Emits a {Transfer} event with &#x60;to&#x60; set to the zero address.
Requirements:
- &#x60;account&#x60; cannot be the zero address.
- &#x60;account&#x60; must have at least &#x60;amount&#x60; tokens._

### _approve

```solidity
function _approve(address owner, address spender, uint256 amount) internal virtual
```

_Sets &#x60;amount&#x60; as the allowance of &#x60;spender&#x60; over the &#x60;owner&#x60; s tokens.
This internal function is equivalent to &#x60;approve&#x60;, and can be used to
e.g. set automatic allowances for certain subsystems, etc.
Emits an {Approval} event.
Requirements:
- &#x60;owner&#x60; cannot be the zero address.
- &#x60;spender&#x60; cannot be the zero address._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual
```

_Hook that is called before any transfer of tokens. This includes
minting and burning.
Calling conditions:
- when &#x60;from&#x60; and &#x60;to&#x60; are both non-zero, &#x60;amount&#x60; of &#x60;&#x60;from&#x60;&#x60;&#x27;s tokens
will be transferred to &#x60;to&#x60;.
- when &#x60;from&#x60; is zero, &#x60;amount&#x60; tokens will be minted for &#x60;to&#x60;.
- when &#x60;to&#x60; is zero, &#x60;amount&#x60; of &#x60;&#x60;from&#x60;&#x60;&#x27;s tokens will be burned.
- &#x60;from&#x60; and &#x60;to&#x60; are never both zero.
To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

### _afterTokenTransfer

```solidity
function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual
```

_Hook that is called after any transfer of tokens. This includes
minting and burning.
Calling conditions:
- when &#x60;from&#x60; and &#x60;to&#x60; are both non-zero, &#x60;amount&#x60; of &#x60;&#x60;from&#x60;&#x60;&#x27;s tokens
has been transferred to &#x60;to&#x60;.
- when &#x60;from&#x60; is zero, &#x60;amount&#x60; tokens have been minted for &#x60;to&#x60;.
- when &#x60;to&#x60; is zero, &#x60;amount&#x60; of &#x60;&#x60;from&#x60;&#x60;&#x27;s tokens have been burned.
- &#x60;from&#x60; and &#x60;to&#x60; are never both zero.
To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

## IERC20

_Interface of the ERC20 standard as defined in the EIP._

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

_Returns the amount of tokens in existence._

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

_Returns the amount of tokens owned by &#x60;account&#x60;._

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

_Moves &#x60;amount&#x60; tokens from the caller&#x27;s account to &#x60;recipient&#x60;.
Returns a boolean value indicating whether the operation succeeded.
Emits a {Transfer} event._

### allowance

```solidity
function allowance(address owner, address spender) external view returns (uint256)
```

_Returns the remaining number of tokens that &#x60;spender&#x60; will be
allowed to spend on behalf of &#x60;owner&#x60; through {transferFrom}. This is
zero by default.
This value changes when {approve} or {transferFrom} are called._

### approve

```solidity
function approve(address spender, uint256 amount) external returns (bool)
```

_Sets &#x60;amount&#x60; as the allowance of &#x60;spender&#x60; over the caller&#x27;s tokens.
Returns a boolean value indicating whether the operation succeeded.
IMPORTANT: Beware that changing an allowance with this method brings the risk
that someone may use both the old and the new allowance by unfortunate
transaction ordering. One possible solution to mitigate this race
condition is to first reduce the spender&#x27;s allowance to 0 and set the
desired value afterwards:
https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
Emits an {Approval} event._

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) external returns (bool)
```

_Moves &#x60;amount&#x60; tokens from &#x60;sender&#x60; to &#x60;recipient&#x60; using the
allowance mechanism. &#x60;amount&#x60; is then deducted from the caller&#x27;s
allowance.
Returns a boolean value indicating whether the operation succeeded.
Emits a {Transfer} event._

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

_Emitted when &#x60;value&#x60; tokens are moved from one account (&#x60;from&#x60;) to
another (&#x60;to&#x60;).
Note that &#x60;value&#x60; may be zero._

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

_Emitted when the allowance of a &#x60;spender&#x60; for an &#x60;owner&#x60; is set by
a call to {approve}. &#x60;value&#x60; is the new allowance._

## IERC20Metadata

_Interface for the optional metadata functions from the ERC20 standard.
_Available since v4.1.__

### name

```solidity
function name() external view returns (string)
```

_Returns the name of the token._

### symbol

```solidity
function symbol() external view returns (string)
```

_Returns the symbol of the token._

### decimals

```solidity
function decimals() external view returns (uint8)
```

_Returns the decimals places of the token._

## ERC721

_Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
the Metadata extension, but not including the Enumerable extension, which is available separately as
{ERC721Enumerable}._

### _name

```solidity
string _name
```

### _symbol

```solidity
string _symbol
```

### _owners

```solidity
mapping(uint256 &#x3D;&gt; address) _owners
```

### _balances

```solidity
mapping(address &#x3D;&gt; uint256) _balances
```

### _tokenApprovals

```solidity
mapping(uint256 &#x3D;&gt; address) _tokenApprovals
```

### _operatorApprovals

```solidity
mapping(address &#x3D;&gt; mapping(address &#x3D;&gt; bool)) _operatorApprovals
```

### constructor

```solidity
constructor(string name_, string symbol_) public
```

_Initializes the contract by setting a &#x60;name&#x60; and a &#x60;symbol&#x60; to the token collection._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### balanceOf

```solidity
function balanceOf(address owner) public view virtual returns (uint256)
```

_See {IERC721-balanceOf}._

### ownerOf

```solidity
function ownerOf(uint256 tokenId) public view virtual returns (address)
```

_See {IERC721-ownerOf}._

### name

```solidity
function name() public view virtual returns (string)
```

_See {IERC721Metadata-name}._

### symbol

```solidity
function symbol() public view virtual returns (string)
```

_See {IERC721Metadata-symbol}._

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view virtual returns (string)
```

_See {IERC721Metadata-tokenURI}._

### _baseURI

```solidity
function _baseURI() internal view virtual returns (string)
```

_Base URI for computing {tokenURI}. If set, the resulting URI for each
token will be the concatenation of the &#x60;baseURI&#x60; and the &#x60;tokenId&#x60;. Empty
by default, can be overriden in child contracts._

### approve

```solidity
function approve(address to, uint256 tokenId) public virtual
```

_See {IERC721-approve}._

### getApproved

```solidity
function getApproved(uint256 tokenId) public view virtual returns (address)
```

_See {IERC721-getApproved}._

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool approved) public virtual
```

_See {IERC721-setApprovalForAll}._

### isApprovedForAll

```solidity
function isApprovedForAll(address owner, address operator) public view virtual returns (bool)
```

_See {IERC721-isApprovedForAll}._

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) public virtual
```

_See {IERC721-transferFrom}._

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) public virtual
```

_See {IERC721-safeTransferFrom}._

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes _data) public virtual
```

_See {IERC721-safeTransferFrom}._

### _safeTransfer

```solidity
function _safeTransfer(address from, address to, uint256 tokenId, bytes _data) internal virtual
```

_Safely transfers &#x60;tokenId&#x60; token from &#x60;from&#x60; to &#x60;to&#x60;, checking first that contract recipients
are aware of the ERC721 protocol to prevent tokens from being forever locked.
&#x60;_data&#x60; is additional data, it has no specified format and it is sent in call to &#x60;to&#x60;.
This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
implement alternative mechanisms to perform token transfer, such as signature-based.
Requirements:
- &#x60;from&#x60; cannot be the zero address.
- &#x60;to&#x60; cannot be the zero address.
- &#x60;tokenId&#x60; token must exist and be owned by &#x60;from&#x60;.
- If &#x60;to&#x60; refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
Emits a {Transfer} event._

### _exists

```solidity
function _exists(uint256 tokenId) internal view virtual returns (bool)
```

_Returns whether &#x60;tokenId&#x60; exists.
Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
Tokens start existing when they are minted (&#x60;_mint&#x60;),
and stop existing when they are burned (&#x60;_burn&#x60;)._

### _isApprovedOrOwner

```solidity
function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool)
```

_Returns whether &#x60;spender&#x60; is allowed to manage &#x60;tokenId&#x60;.
Requirements:
- &#x60;tokenId&#x60; must exist._

### _safeMint

```solidity
function _safeMint(address to, uint256 tokenId) internal virtual
```

_Safely mints &#x60;tokenId&#x60; and transfers it to &#x60;to&#x60;.
Requirements:
- &#x60;tokenId&#x60; must not exist.
- If &#x60;to&#x60; refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
Emits a {Transfer} event._

### _safeMint

```solidity
function _safeMint(address to, uint256 tokenId, bytes _data) internal virtual
```

_Same as {xref-ERC721-_safeMint-address-uint256-}[&#x60;_safeMint&#x60;], with an additional &#x60;data&#x60; parameter which is
forwarded in {IERC721Receiver-onERC721Received} to contract recipients._

### _mint

```solidity
function _mint(address to, uint256 tokenId) internal virtual
```

_Mints &#x60;tokenId&#x60; and transfers it to &#x60;to&#x60;.
WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
Requirements:
- &#x60;tokenId&#x60; must not exist.
- &#x60;to&#x60; cannot be the zero address.
Emits a {Transfer} event._

### _burn

```solidity
function _burn(uint256 tokenId) internal virtual
```

_Destroys &#x60;tokenId&#x60;.
The approval is cleared when the token is burned.
Requirements:
- &#x60;tokenId&#x60; must exist.
Emits a {Transfer} event._

### _transfer

```solidity
function _transfer(address from, address to, uint256 tokenId) internal virtual
```

_Transfers &#x60;tokenId&#x60; from &#x60;from&#x60; to &#x60;to&#x60;.
 As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
Requirements:
- &#x60;to&#x60; cannot be the zero address.
- &#x60;tokenId&#x60; token must be owned by &#x60;from&#x60;.
Emits a {Transfer} event._

### _approve

```solidity
function _approve(address to, uint256 tokenId) internal virtual
```

_Approve &#x60;to&#x60; to operate on &#x60;tokenId&#x60;
Emits a {Approval} event._

### _checkOnERC721Received

```solidity
function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes _data) private returns (bool)
```

_Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
The call is not executed if the target address is not a contract._

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | address representing the previous owner of the given token ID |
| to | address | target address that will receive the tokens |
| tokenId | uint256 | uint256 ID of the token to be transferred |
| _data | bytes | bytes optional data to send along with the call |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool whether the call correctly returned the expected magic value |

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual
```

_Hook that is called before any token transfer. This includes minting
and burning.
Calling conditions:
- When &#x60;from&#x60; and &#x60;to&#x60; are both non-zero, &#x60;&#x60;from&#x60;&#x60;&#x27;s &#x60;tokenId&#x60; will be
transferred to &#x60;to&#x60;.
- When &#x60;from&#x60; is zero, &#x60;tokenId&#x60; will be minted for &#x60;to&#x60;.
- When &#x60;to&#x60; is zero, &#x60;&#x60;from&#x60;&#x60;&#x27;s &#x60;tokenId&#x60; will be burned.
- &#x60;from&#x60; and &#x60;to&#x60; are never both zero.
To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

## IERC721

_Required interface of an ERC721 compliant contract._

### Transfer

```solidity
event Transfer(address from, address to, uint256 tokenId)
```

_Emitted when &#x60;tokenId&#x60; token is transferred from &#x60;from&#x60; to &#x60;to&#x60;._

### Approval

```solidity
event Approval(address owner, address approved, uint256 tokenId)
```

_Emitted when &#x60;owner&#x60; enables &#x60;approved&#x60; to manage the &#x60;tokenId&#x60; token._

### ApprovalForAll

```solidity
event ApprovalForAll(address owner, address operator, bool approved)
```

_Emitted when &#x60;owner&#x60; enables or disables (&#x60;approved&#x60;) &#x60;operator&#x60; to manage all of its assets._

### balanceOf

```solidity
function balanceOf(address owner) external view returns (uint256 balance)
```

_Returns the number of tokens in &#x60;&#x60;owner&#x60;&#x60;&#x27;s account._

### ownerOf

```solidity
function ownerOf(uint256 tokenId) external view returns (address owner)
```

_Returns the owner of the &#x60;tokenId&#x60; token.
Requirements:
- &#x60;tokenId&#x60; must exist._

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId) external
```

_Safely transfers &#x60;tokenId&#x60; token from &#x60;from&#x60; to &#x60;to&#x60;, checking first that contract recipients
are aware of the ERC721 protocol to prevent tokens from being forever locked.
Requirements:
- &#x60;from&#x60; cannot be the zero address.
- &#x60;to&#x60; cannot be the zero address.
- &#x60;tokenId&#x60; token must exist and be owned by &#x60;from&#x60;.
- If the caller is not &#x60;from&#x60;, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
- If &#x60;to&#x60; refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
Emits a {Transfer} event._

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 tokenId) external
```

_Transfers &#x60;tokenId&#x60; token from &#x60;from&#x60; to &#x60;to&#x60;.
WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
Requirements:
- &#x60;from&#x60; cannot be the zero address.
- &#x60;to&#x60; cannot be the zero address.
- &#x60;tokenId&#x60; token must be owned by &#x60;from&#x60;.
- If the caller is not &#x60;from&#x60;, it must be approved to move this token by either {approve} or {setApprovalForAll}.
Emits a {Transfer} event._

### approve

```solidity
function approve(address to, uint256 tokenId) external
```

_Gives permission to &#x60;to&#x60; to transfer &#x60;tokenId&#x60; token to another account.
The approval is cleared when the token is transferred.
Only a single account can be approved at a time, so approving the zero address clears previous approvals.
Requirements:
- The caller must own the token or be an approved operator.
- &#x60;tokenId&#x60; must exist.
Emits an {Approval} event._

### getApproved

```solidity
function getApproved(uint256 tokenId) external view returns (address operator)
```

_Returns the account approved for &#x60;tokenId&#x60; token.
Requirements:
- &#x60;tokenId&#x60; must exist._

### setApprovalForAll

```solidity
function setApprovalForAll(address operator, bool _approved) external
```

_Approve or remove &#x60;operator&#x60; as an operator for the caller.
Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
Requirements:
- The &#x60;operator&#x60; cannot be the caller.
Emits an {ApprovalForAll} event._

### isApprovedForAll

```solidity
function isApprovedForAll(address owner, address operator) external view returns (bool)
```

_Returns if the &#x60;operator&#x60; is allowed to manage all of the assets of &#x60;owner&#x60;.
See {setApprovalForAll}_

### safeTransferFrom

```solidity
function safeTransferFrom(address from, address to, uint256 tokenId, bytes data) external
```

_Safely transfers &#x60;tokenId&#x60; token from &#x60;from&#x60; to &#x60;to&#x60;.
Requirements:
- &#x60;from&#x60; cannot be the zero address.
- &#x60;to&#x60; cannot be the zero address.
- &#x60;tokenId&#x60; token must exist and be owned by &#x60;from&#x60;.
- If the caller is not &#x60;from&#x60;, it must be approved to move this token by either {approve} or {setApprovalForAll}.
- If &#x60;to&#x60; refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
Emits a {Transfer} event._

## IERC721Receiver

_Interface for any contract that wants to support safeTransfers
from ERC721 asset contracts._

### onERC721Received

```solidity
function onERC721Received(address operator, address from, uint256 tokenId, bytes data) external returns (bytes4)
```

_Whenever an {IERC721} &#x60;tokenId&#x60; token is transferred to this contract via {IERC721-safeTransferFrom}
by &#x60;operator&#x60; from &#x60;from&#x60;, this function is called.
It must return its Solidity selector to confirm the token transfer.
If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
The selector can be obtained in Solidity with &#x60;IERC721.onERC721Received.selector&#x60;._

## ERC721Enumerable

_This implements an optional extension of {ERC721} defined in the EIP that adds
enumerability of all the token ids in the contract as well as all token ids owned by each
account._

### _ownedTokens

```solidity
mapping(address &#x3D;&gt; mapping(uint256 &#x3D;&gt; uint256)) _ownedTokens
```

### _ownedTokensIndex

```solidity
mapping(uint256 &#x3D;&gt; uint256) _ownedTokensIndex
```

### _allTokens

```solidity
uint256[] _allTokens
```

### _allTokensIndex

```solidity
mapping(uint256 &#x3D;&gt; uint256) _allTokensIndex
```

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

### tokenOfOwnerByIndex

```solidity
function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual returns (uint256)
```

_See {IERC721Enumerable-tokenOfOwnerByIndex}._

### totalSupply

```solidity
function totalSupply() public view virtual returns (uint256)
```

_See {IERC721Enumerable-totalSupply}._

### tokenByIndex

```solidity
function tokenByIndex(uint256 index) public view virtual returns (uint256)
```

_See {IERC721Enumerable-tokenByIndex}._

### _beforeTokenTransfer

```solidity
function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual
```

_Hook that is called before any token transfer. This includes minting
and burning.
Calling conditions:
- When &#x60;from&#x60; and &#x60;to&#x60; are both non-zero, &#x60;&#x60;from&#x60;&#x60;&#x27;s &#x60;tokenId&#x60; will be
transferred to &#x60;to&#x60;.
- When &#x60;from&#x60; is zero, &#x60;tokenId&#x60; will be minted for &#x60;to&#x60;.
- When &#x60;to&#x60; is zero, &#x60;&#x60;from&#x60;&#x60;&#x27;s &#x60;tokenId&#x60; will be burned.
- &#x60;from&#x60; cannot be the zero address.
- &#x60;to&#x60; cannot be the zero address.
To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks]._

### _addTokenToOwnerEnumeration

```solidity
function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private
```

_Private function to add a token to this extension&#x27;s ownership-tracking data structures._

| Name | Type | Description |
| ---- | ---- | ----------- |
| to | address | address representing the new owner of the given token ID |
| tokenId | uint256 | uint256 ID of the token to be added to the tokens list of the given address |

### _addTokenToAllTokensEnumeration

```solidity
function _addTokenToAllTokensEnumeration(uint256 tokenId) private
```

_Private function to add a token to this extension&#x27;s token tracking data structures._

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | uint256 ID of the token to be added to the tokens list |

### _removeTokenFromOwnerEnumeration

```solidity
function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private
```

_Private function to remove a token from this extension&#x27;s ownership-tracking data structures. Note that
while the token is not assigned a new owner, the &#x60;_ownedTokensIndex&#x60; mapping is _not_ updated: this allows for
gas optimizations e.g. when performing a transfer operation (avoiding double writes).
This has O(1) time complexity, but alters the order of the _ownedTokens array._

| Name | Type | Description |
| ---- | ---- | ----------- |
| from | address | address representing the previous owner of the given token ID |
| tokenId | uint256 | uint256 ID of the token to be removed from the tokens list of the given address |

### _removeTokenFromAllTokensEnumeration

```solidity
function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private
```

_Private function to remove a token from this extension&#x27;s token tracking data structures.
This has O(1) time complexity, but alters the order of the _allTokens array._

| Name | Type | Description |
| ---- | ---- | ----------- |
| tokenId | uint256 | uint256 ID of the token to be removed from the tokens list |

## IERC721Enumerable

_See https://eips.ethereum.org/EIPS/eip-721_

### totalSupply

```solidity
function totalSupply() external view returns (uint256)
```

_Returns the total amount of tokens stored by the contract._

### tokenOfOwnerByIndex

```solidity
function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId)
```

_Returns a token ID owned by &#x60;owner&#x60; at a given &#x60;index&#x60; of its token list.
Use along with {balanceOf} to enumerate all of &#x60;&#x60;owner&#x60;&#x60;&#x27;s tokens._

### tokenByIndex

```solidity
function tokenByIndex(uint256 index) external view returns (uint256)
```

_Returns a token ID at a given &#x60;index&#x60; of all the tokens stored by the contract.
Use along with {totalSupply} to enumerate all tokens._

## IERC721Metadata

_See https://eips.ethereum.org/EIPS/eip-721_

### name

```solidity
function name() external view returns (string)
```

_Returns the token collection name._

### symbol

```solidity
function symbol() external view returns (string)
```

_Returns the token collection symbol._

### tokenURI

```solidity
function tokenURI(uint256 tokenId) external view returns (string)
```

_Returns the Uniform Resource Identifier (URI) for &#x60;tokenId&#x60; token._

## Address

_Collection of functions related to the address type_

### isContract

```solidity
function isContract(address account) internal view returns (bool)
```

_Returns true if &#x60;account&#x60; is a contract.
[IMPORTANT]
&#x3D;&#x3D;&#x3D;&#x3D;
It is unsafe to assume that an address for which this function returns
false is an externally-owned account (EOA) and not a contract.
Among others, &#x60;isContract&#x60; will return false for the following
types of addresses:
 - an externally-owned account
 - a contract in construction
 - an address where a contract will be created
 - an address where a contract lived, but was destroyed
&#x3D;&#x3D;&#x3D;&#x3D;_

### sendValue

```solidity
function sendValue(address payable recipient, uint256 amount) internal
```

_Replacement for Solidity&#x27;s &#x60;transfer&#x60;: sends &#x60;amount&#x60; wei to
&#x60;recipient&#x60;, forwarding all available gas and reverting on errors.
https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
of certain opcodes, possibly making contracts go over the 2300 gas limit
imposed by &#x60;transfer&#x60;, making them unable to receive funds via
&#x60;transfer&#x60;. {sendValue} removes this limitation.
https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
IMPORTANT: because control is transferred to &#x60;recipient&#x60;, care must be
taken to not create reentrancy vulnerabilities. Consider using
{ReentrancyGuard} or the
https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern]._

### functionCall

```solidity
function functionCall(address target, bytes data) internal returns (bytes)
```

_Performs a Solidity function call using a low level &#x60;call&#x60;. A
plain &#x60;call&#x60; is an unsafe replacement for a function call: use this
function instead.
If &#x60;target&#x60; reverts with a revert reason, it is bubbled up by this
function (like regular Solidity function calls).
Returns the raw returned data. To convert to the expected return value,
use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight&#x3D;abi.decode#abi-encoding-and-decoding-functions[&#x60;abi.decode&#x60;].
Requirements:
- &#x60;target&#x60; must be a contract.
- calling &#x60;target&#x60; with &#x60;data&#x60; must not revert.
_Available since v3.1.__

### functionCall

```solidity
function functionCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[&#x60;functionCall&#x60;], but with
&#x60;errorMessage&#x60; as a fallback revert reason when &#x60;target&#x60; reverts.
_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[&#x60;functionCall&#x60;],
but also transferring &#x60;value&#x60; wei to &#x60;target&#x60;.
Requirements:
- the calling contract must have an ETH balance of at least &#x60;value&#x60;.
- the called Solidity function must be &#x60;payable&#x60;.
_Available since v3.1.__

### functionCallWithValue

```solidity
function functionCallWithValue(address target, bytes data, uint256 value, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[&#x60;functionCallWithValue&#x60;], but
with &#x60;errorMessage&#x60; as a fallback revert reason when &#x60;target&#x60; reverts.
_Available since v3.1.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[&#x60;functionCall&#x60;],
but performing a static call.
_Available since v3.3.__

### functionStaticCall

```solidity
function functionStaticCall(address target, bytes data, string errorMessage) internal view returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[&#x60;functionCall&#x60;],
but performing a static call.
_Available since v3.3.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-}[&#x60;functionCall&#x60;],
but performing a delegate call.
_Available since v3.4.__

### functionDelegateCall

```solidity
function functionDelegateCall(address target, bytes data, string errorMessage) internal returns (bytes)
```

_Same as {xref-Address-functionCall-address-bytes-string-}[&#x60;functionCall&#x60;],
but performing a delegate call.
_Available since v3.4.__

### verifyCallResult

```solidity
function verifyCallResult(bool success, bytes returndata, string errorMessage) internal pure returns (bytes)
```

_Tool to verifies that a low level call was successful, and revert if it wasn&#x27;t, either by bubbling the
revert reason using the provided one.
_Available since v4.3.__

## Context

_Provides information about the current execution context, including the
sender of the transaction and its data. While these are generally available
via msg.sender and msg.data, they should not be accessed in such a direct
manner, since when dealing with meta-transactions the account sending and
paying for execution may not be the actual sender (as far as an application
is concerned).
This contract is only required for intermediate, library-like contracts._

### _msgSender

```solidity
function _msgSender() internal view virtual returns (address)
```

### _msgData

```solidity
function _msgData() internal view virtual returns (bytes)
```

## Strings

_String operations._

### _HEX_SYMBOLS

```solidity
bytes16 _HEX_SYMBOLS
```

### toString

```solidity
function toString(uint256 value) internal pure returns (string)
```

_Converts a &#x60;uint256&#x60; to its ASCII &#x60;string&#x60; decimal representation._

### toHexString

```solidity
function toHexString(uint256 value) internal pure returns (string)
```

_Converts a &#x60;uint256&#x60; to its ASCII &#x60;string&#x60; hexadecimal representation._

### toHexString

```solidity
function toHexString(uint256 value, uint256 length) internal pure returns (string)
```

_Converts a &#x60;uint256&#x60; to its ASCII &#x60;string&#x60; hexadecimal representation with fixed length._

## ERC165

_Implementation of the {IERC165} interface.
Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
for the additional interface id that will be supported. For example:
&#x60;&#x60;&#x60;solidity
function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
    return interfaceId &#x3D;&#x3D; type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
}
&#x60;&#x60;&#x60;
Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) public view virtual returns (bool)
```

_See {IERC165-supportsInterface}._

## IERC165

_Interface of the ERC165 standard, as defined in the
https://eips.ethereum.org/EIPS/eip-165[EIP].
Implementers can declare support of contract interfaces, which can then be
queried by others ({ERC165Checker}).
For an implementation, see {ERC165}._

### supportsInterface

```solidity
function supportsInterface(bytes4 interfaceId) external view returns (bool)
```

_Returns true if this contract implements the interface defined by
&#x60;interfaceId&#x60;. See the corresponding
https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
to learn more about how these ids are created.
This function call must use less than 30 000 gas._

## SafeMath

_Wrappers over Solidity&#x27;s arithmetic operations.
NOTE: &#x60;SafeMath&#x60; is no longer needed starting with Solidity 0.8. The compiler
now has built in overflow checking._

### tryAdd

```solidity
function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the addition of two unsigned integers, with an overflow flag.
_Available since v3.4.__

### trySub

```solidity
function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the substraction of two unsigned integers, with an overflow flag.
_Available since v3.4.__

### tryMul

```solidity
function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the multiplication of two unsigned integers, with an overflow flag.
_Available since v3.4.__

### tryDiv

```solidity
function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the division of two unsigned integers, with a division by zero flag.
_Available since v3.4.__

### tryMod

```solidity
function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256)
```

_Returns the remainder of dividing two unsigned integers, with a division by zero flag.
_Available since v3.4.__

### add

```solidity
function add(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the addition of two unsigned integers, reverting on
overflow.
Counterpart to Solidity&#x27;s &#x60;+&#x60; operator.
Requirements:
- Addition cannot overflow._

### sub

```solidity
function sub(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the subtraction of two unsigned integers, reverting on
overflow (when the result is negative).
Counterpart to Solidity&#x27;s &#x60;-&#x60; operator.
Requirements:
- Subtraction cannot overflow._

### mul

```solidity
function mul(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the multiplication of two unsigned integers, reverting on
overflow.
Counterpart to Solidity&#x27;s &#x60;*&#x60; operator.
Requirements:
- Multiplication cannot overflow._

### div

```solidity
function div(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the integer division of two unsigned integers, reverting on
division by zero. The result is rounded towards zero.
Counterpart to Solidity&#x27;s &#x60;/&#x60; operator.
Requirements:
- The divisor cannot be zero._

### mod

```solidity
function mod(uint256 a, uint256 b) internal pure returns (uint256)
```

_Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
reverting when dividing by zero.
Counterpart to Solidity&#x27;s &#x60;%&#x60; operator. This function uses a &#x60;revert&#x60;
opcode (which leaves remaining gas untouched) while Solidity uses an
invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero._

### sub

```solidity
function sub(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the subtraction of two unsigned integers, reverting with custom message on
overflow (when the result is negative).
CAUTION: This function is deprecated because it requires allocating memory for the error
message unnecessarily. For custom revert reasons use {trySub}.
Counterpart to Solidity&#x27;s &#x60;-&#x60; operator.
Requirements:
- Subtraction cannot overflow._

### div

```solidity
function div(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the integer division of two unsigned integers, reverting with custom message on
division by zero. The result is rounded towards zero.
Counterpart to Solidity&#x27;s &#x60;/&#x60; operator. Note: this function uses a
&#x60;revert&#x60; opcode (which leaves remaining gas untouched) while Solidity
uses an invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero._

### mod

```solidity
function mod(uint256 a, uint256 b, string errorMessage) internal pure returns (uint256)
```

_Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
reverting with custom message when dividing by zero.
CAUTION: This function is deprecated because it requires allocating memory for the error
message unnecessarily. For custom revert reasons use {tryMod}.
Counterpart to Solidity&#x27;s &#x60;%&#x60; operator. This function uses a &#x60;revert&#x60;
opcode (which leaves remaining gas untouched) while Solidity uses an
invalid opcode to revert (consuming all remaining gas).
Requirements:
- The divisor cannot be zero._

## DAppMarket

### constructor

```solidity
constructor(address tbAddress) public
```

### _totalSupply

```solidity
uint256 _totalSupply
```

### _totalTraffic

```solidity
uint256 _totalTraffic
```

### _TBAddress

```solidity
address _TBAddress
```

### referalFee

```solidity
uint256 referalFee
```

### feePoint

```solidity
uint256 feePoint
```

### publishFee

```solidity
uint256 publishFee
```

### DAppData

```solidity
mapping(uint256 &#x3D;&gt; struct IDAppMarket.DAppStruct) DAppData
```

### collectTraffic

```solidity
function collectTraffic(uint256 length, uint256[] _tokenId, uint256[] _traffic) public
```

_Collect Traffic to NFT&#x27;s and transfer referalFee to this contract_

| Name | Type | Description |
| ---- | ---- | ----------- |
| length | uint256 | uint - size of arrays |
| _tokenId | uint256[] | - array of token ids [1,2,3] |
| _traffic | uint256[] | - array of amount of bytes [1024^3, 5x1024^3, 10x1024^3] |

### getMetaData

```solidity
function getMetaData(uint256 _tokenId) public view returns (struct IDAppMarket.DAppStruct)
```

_return full metadata, for external apps can be expensive to check, but retuns full info_

### getNFTBalance

```solidity
function getNFTBalance(uint256 _itemId) public view returns (uint256)
```

_(NFT.traffic - NFT.payedTraffic) x this.tbBalance / totalTraffic_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemId | uint256 | - NFT token id |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | TB balance of this token |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

_Returns the Uniform Resource Identifier (URI) for &#x60;tokenId&#x60; token._

### tokenContentHash

```solidity
function tokenContentHash(uint256 tokenId) public view returns (bytes32)
```

_Return the content hash of resourse for &#x60;tokenId&#x60;._

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

_totalSupply - amount of minted dapps tokens_

### claimReward

```solidity
function claimReward(uint256 _itemId) public
```

_Owner of item can get collected reward
Check owner of itemId, no need to check _exist, because in exist check owner !&#x3D; 0_

### claimRewardMany

```solidity
function claimRewardMany(uint256[] _itemIds) public
```

_Claim many_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemIds | uint256[] | - array of NFTids owned by user |

### wrappedPointer

```solidity
mapping(bytes32 &#x3D;&gt; uint256) wrappedPointer
```

_keccak(origin.address + origin.id) &#x3D;&gt; WNFT id_

### CreateDApp

```solidity
function CreateDApp(string dAppURI, bytes32 _contentHash) public
```

_Creating DApp as NFT_

### updateVersion

```solidity
function updateVersion(uint256 tokenId, string dAppURI, bytes32 contentHash) public
```

_owner can deploy updates, if content hash modified_

### onERC721Received

```solidity
function onERC721Received(address _operator, address _from, uint256 _tokenId, bytes _data) public view returns (bytes4)
```

_SafeTransferFrom require this function_

## DeNetDNS

### _TBAddress

```solidity
address _TBAddress
```

### constructor

```solidity
constructor(address tbAddress) public
```

### DeNetDNS

```solidity
struct DeNetDNS {
  string URI;
  string DomainZone;
  bytes32 URIHash;
  uint256 nextPaymentBefore;
  uint256 DAppID;
  bytes32 DAppContentHash;
}
```

## ExampleNFT

### constructor

```solidity
constructor(string _name, string _symbol) public
```

### _counter

```solidity
uint256 _counter
```

### mintMe

```solidity
function mintMe() public
```

### counter

```solidity
function counter() public view returns (uint256)
```

## PoSAdmin

_Contract PoSAdmin - modifier for ProofOfStorage API&#x27;s
- onlyOldAddress
- onlyGovernance
- whenNotPaused
- whenPaused
- onlyGateway_

### proofOfStorageAddress

```solidity
address proofOfStorageAddress
```

### newAddress

```solidity
address newAddress
```

### governanceAddress

```solidity
address governanceAddress
```

### oldAddress

```solidity
address oldAddress
```

### paused

```solidity
bool paused
```

### _isGateway

```solidity
mapping(address &#x3D;&gt; bool) _isGateway
```

### constructor

```solidity
constructor(address _pos) public
```

### onlyOldAddress

```solidity
modifier onlyOldAddress()
```

### onlyGovernance

```solidity
modifier onlyGovernance()
```

### whenNotPaused

```solidity
modifier whenNotPaused()
```

### whenPaused

```solidity
modifier whenPaused()
```

### pause

```solidity
function pause() external
```

### unpause

```solidity
function unpause() external
```

### changeGovernance

```solidity
function changeGovernance(address _new) external
```

### setOldAddress

```solidity
function setOldAddress(address _new) external
```

### setNewAddress

```solidity
function setNewAddress(address _new) external
```

### onlyPoS

```solidity
modifier onlyPoS()
```

### onlyGateway

```solidity
modifier onlyGateway()
```

### changePoS

```solidity
function changePoS(address _newAddress) public
```

### addGateway

```solidity
function addGateway(address account) public
```

### delGateway

```solidity
function delGateway(address account) public
```

## Wrapper

_Contract WNFT - Wrapped NFT made for NFT Staking program in DeNet
- Minimal reward ~1MB
- Amount of reward 5% (constant) of traffic, will upgraded in future with governance_

### _rewardTokenAddress

```solidity
address _rewardTokenAddress
```

_Address of TB Token_

### constructor

```solidity
constructor(address tbAddress) public
```

### _totalSupply

```solidity
uint256 _totalSupply
```

### _totalTraffic

```solidity
uint256 _totalTraffic
```

### referalFee

```solidity
uint256 referalFee
```

### feePoint

```solidity
uint256 feePoint
```

### _wrappedData

```solidity
mapping(uint256 &#x3D;&gt; struct IWrapper.WrappedStruct) _wrappedData
```

### collectTraffic

```solidity
function collectTraffic(uint256 length, uint256[] _tokenId, uint256[] _traffic) public
```

_Collect Traffic to NFT&#x27;s and transfer referalFee to this contract_

| Name | Type | Description |
| ---- | ---- | ----------- |
| length | uint256 | uint - size of arrays |
| _tokenId | uint256[] | - array of token ids [1,2,3] |
| _traffic | uint256[] | - array of amount of bytes [1024^3, 5x1024^3, 10x1024^3] |

### getMetaData

```solidity
function getMetaData(uint256 _tokenId) public view returns (struct IWrapper.WrappedStruct)
```

_return full metadata, for external apps can be expensive to check, but retuns full info_

### getNFTBalance

```solidity
function getNFTBalance(uint256 _itemId) public view returns (uint256)
```

_(NFT.traffic - NFT.payedTraffic) x this.tbBalance / totalTraffic_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemId | uint256 | - NFT token id |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | TB balance of this token |

### tokenURI

```solidity
function tokenURI(uint256 tokenId) public view returns (string)
```

_Returns the Uniform Resource Identifier (URI) for &#x60;tokenId&#x60; token._

### tokenContentHash

```solidity
function tokenContentHash(uint256 tokenId) public view returns (bytes32)
```

_Return the content hash of resourse for &#x60;tokenId&#x60;._

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

__totalSupply - total amount of supplied WNFT&#x27;s_

### claimReward

```solidity
function claimReward(uint256 _itemId) public
```

Approved operator can claim reward on own address

_Owner of item can get collected reward
Check owner of itemId, no need to check _exist, because in exist check owner !&#x3D; 0_

### claimRewardMany

```solidity
function claimRewardMany(uint256[] _itemIds) public
```

_Claim many_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemIds | uint256[] | array of NFTids owned by user |

### wrap

```solidity
function wrap(address originAddress, uint256 tokenId, bytes32 originContentHash, string storageURI, uint256 contentSize) public
```

_Make NFT as WrappedNFT
1. Create pointer: keccak(address, token_id)
2. TransferFrom origin to this
3. Fill Metadata_

### unwrap

```solidity
function unwrap(uint256 tokenId) public
```

_unwrap and burn
1. Sender &#x3D;&#x3D; Owner or Approved
2. Transfer to Sender
3. Burn wrapped_

## IDAppMarket

### DAppStruct

```solidity
struct DAppStruct {
  string URI;
  uint256 traffic;
  uint256 payedTraffic;
  bytes32 contentHash;
  bool burned;
  bytes32[] versionHashes;
  uint256 currentVersion;
}
```

### claimReward

```solidity
function claimReward(uint256 _itemId) external
```

_Owner of item can get collected reward
Check owner of itemId, no need to check _exist, because in exist check owner !&#x3D; 0_

### claimRewardMany

```solidity
function claimRewardMany(uint256[] _itemIds) external
```

_Claim many_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemIds | uint256[] | - array of NFTids owned by user |

### tokenContentHash

```solidity
function tokenContentHash(uint256 _itemId) external view returns (bytes32)
```

_return Content Hash of NFT_

### getNFTBalance

```solidity
function getNFTBalance(uint256 _itemId) external view returns (uint256)
```

_returns NFT Balanc of earned tokens_

### getMetaData

```solidity
function getMetaData(uint256 _tokenId) external view returns (struct IDAppMarket.DAppStruct)
```

_return full metadata, for external apps can be expensive to check, but retuns full info_

### updateVersion

```solidity
function updateVersion(uint256 tokenId, string dAppURI, bytes32 contentHash) external
```

### CreateDApp

```solidity
function CreateDApp(string dAppURI, bytes32 _contentHash) external
```

## IPoSAdmin

### ChangePoSAddress

```solidity
event ChangePoSAddress(address newPoSAddress)
```

## IWrapper

### WrappedStruct

```solidity
struct WrappedStruct {
  string URI;
  uint256 contentSize;
  uint256 traffic;
  uint256 payedTraffic;
  bytes32 contentHash;
  address oldAddress;
  uint256 tokenId;
  bool burned;
}
```

### claimReward

```solidity
function claimReward(uint256 _itemId) external
```

_Owner of item can get collected reward
Check owner of itemId, no need to check _exist, because in exist check owner !&#x3D; 0_

### claimRewardMany

```solidity
function claimRewardMany(uint256[] _itemIds) external
```

_Claim many_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _itemIds | uint256[] | - array of NFTids owned by user |

### wrap

```solidity
function wrap(address _contract, uint256 tokenId, bytes32 _contentHash, string _DeNetStorageURI, uint256 contentSize) external
```

_Make NFT as WrappedNFT
1. Check is approved
2. Check is sender &#x3D;&#x3D; owner
3. Create pointer: keccak(address, token_id)
4. Create wrapped NFT_

### unwrap

```solidity
function unwrap(uint256 tokenId) external
```

_unwrap and burn
1. Sender &#x3D;&#x3D; Owner
2. Transfer to Sender
3. Burn wrapped_

### tokenContentHash

```solidity
function tokenContentHash(uint256 _itemId) external view returns (bytes32)
```

_return Content Hash of NFT_

### getNFTBalance

```solidity
function getNFTBalance(uint256 _itemId) external view returns (uint256)
```

_returns NFT Balanc of earned tokens_

### getMetaData

```solidity
function getMetaData(uint256 _tokenId) external view returns (struct IWrapper.WrappedStruct)
```

_return full metadata, for external apps can be expensive to check, but retuns full info_

## TokenMock

### constructor

```solidity
constructor(string name, string symbol) public
```

### mint

```solidity
function mint(address account, uint256 amount) external
```

### burn

```solidity
function burn(address account, uint256 amount) external
```

