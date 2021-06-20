pragma solidity 0.6.0;

interface IERC20{
    function totalSupply() external view returns(uint); //Total initial amount to tokens in a particular account
    
    function balanceOf(address account) external view returns(uint); //Checking balance of an account
    
    function transfer(address receiver, uint value) external returns(bool); //For transfering of tokens from one acc to another
    
    function approve(address spender, uint value) external returns(bool); //Approving of using owner's tokens
    
    function transferFrom(address _from, address _to, uint value) external returns(bool); //it is used when my approved address is spending tokens on my behalf

    function allowance(address _owner, address _spender) external view returns(uint); //Checking balance of approved tokens

    event Transfer(address _from, address _to, uint value);
    event Approval(address _owner, address _spender, uint value);
}

contract MyERC20Token is IERC20 {
    string name;
    string symbol;
    uint decimal;
    address owner;
    
    uint _totalSupply = 50000;
    
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) approved; // approved[owner][friends_address] = 5000;
    
    constructor() public {
        name = "KU_CSE_TOKEN";
        symbol = "CS50";
        decimal = 0;
        owner = msg.sender;
        balances[owner] = 50000;
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
        
        require(value>0 && balances[owner] >= value);
        require(receiver != address(0),"Transfering to zero address is not possible"); //address(5) - 0x5555555555
    
        balances[owner] -= value;
        balances[receiver] += value;
        
        emit Transfer(owner,receiver,value);
        
        return true;
    }
    
    function approve(address spender, uint value) public override returns(bool){
        require(value>0 && balances[owner] >= value);
        require(spender != address(0),"Approval to zero address is not possible"); //address(5) - 0x5555555555
    
        approved[owner][spender] = value;
        
        emit Approval(owner,spender,value);
        return true;
    }
    
    function transferFrom(address _from, address _to, uint value) public override returns(bool){
        require(value>0 && balances[owner] >= value && approved[_from][_to]>=value);
        require(_to != address(0),"Approval to zero address is not possible"); //address(5) - 0x5555555555
        
        balances[_to] += value;
        balances[_from] -= value;
        
        approved[_from][_to] -= value;
        
        return true;
    }
    
    function allowance(address _owner, address _spender) public override view returns(uint){
        return approved[_owner][_spender];
    }
    
}
