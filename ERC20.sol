pragma solidity 0.8.26;

interface IERC20{
    function getTokenName() external view returns(string memory);

    function getTokenSymbol() external view returns(string memory);

    function totalSupply() external view returns(uint); //Total initial amount to tokens in a particular account
    
    function balanceOf(address account) external view returns(uint); //Checking balance of an account
    
    function transfer(address receiver, uint value) external returns(bool); //For transfering of tokens from one acc to another
    
    function approve(address spender, uint value) external returns(bool); //Approving of using owner's tokens
    
    function transferFrom(address _from, address _to, uint value) external returns(bool); //it is used when owner's approved address is spending tokens on owner's behalf

    function allowance(address _owner, address _spender) external view returns(uint); //Checking balance of approved tokens

    event Transfer(address _from, address _to, uint value);
    event Approval(address _owner, address _spender, uint value);
}

contract MyERC20Token is IERC20 {
    string name; //Token Name
    string symbol; //Token Symbol
    uint decimal; //Token decimal point
    address owner; //Initial owner of token
    
    uint _totalSupply = 50000; //BTC - 21 million
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) approved; // approved[owner][friends_address] = 5000;
    
    constructor() public {
        name = "Pune University Token";
        symbol = "SPPU";
        decimal = 0;
        owner = msg.sender;//msg.sender - address of user who is deploying this token smart contract
        balances[owner] = _totalSupply; //initial balance of owner
    }
    
    function getTokenName() public view returns(string memory){
        return name;
    }
    
    function getTokenSymbol() public view returns(string memory){
        return symbol;
    }
    
    function totalSupply() public override view returns(uint){
        return _totalSupply;
    }
    
    function balanceOf(address account) public override view returns(uint){
        return balances[account];
    }
    
    function transfer(address receiver, uint value) public override returns(bool){
        //require, assert, revert, if() ----> conditional statements

        require(value>0 && balances[owner] >= value);
        require(receiver != address(0),"Transfering to zero address is not possible"); //address(5) - 0x5555555555
    
        balances[owner] -= value; //balances[owner] = balances[owner] - value
        balances[receiver] += value;
        
        emit Transfer(owner,receiver,value);
        
        return true;
    }
    
    function approve(address spender, uint value) public override returns(bool){
        require(msg.sender == owner, "Only owner can perform this action");
        require(value>0 && balances[owner] >= value);
        require(spender != address(0),"Approval to zero address is not possible"); //address(5) - 0x5555555555
    
        approved[owner][spender] += value; //token assign 
        //require(approved[_from][msg.sender] >= value); //assigned token check
        
        emit Approval(owner,spender,value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint value) public override returns(bool){
        require(value>0 && balances[owner] >= value, "Transaction failed");
        require(approved[_from][msg.sender] >= value, "Insufficient token approved by owner to spender");
        require(_to != address(0),"Approval to zero address is not possible"); //address(5) - 0x5555555555
        
        balances[_to] += value; //receiver
        balances[_from] -= value; //owner
        
        approved[_from][msg.sender] -= value; //approved amount deduct
        
        return true;
    }
    
    function allowance(address _owner, address _spender) public override view returns(uint){
        return approved[_owner][_spender];
    }
    
}
