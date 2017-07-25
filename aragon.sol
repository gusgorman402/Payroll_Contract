contract workForce
{
    modifier onlyOwner()
    {
        require(msg.sender == owner);
        _;
    }

    struct Employee
    {
        uint employeeId;
        string employeeName;
        address employeeAddress;
        address[3] allowedTokens;
        uint yearlySalaryUSD;
        uint startDate;
        uint lastPayday;
        uint lastTokenConfigDay;
    }

    Employee[] workcrew;
    mapping( uint => uint ) employeeIdIndex;
    mapping( string => uint ) employeeNameIndex;
    uint employeeIndex = 1000;
    address owner;
    uint creationDate;

    function workForce() public
    {
        owner = msg.sender;
        creationDate = now;
    }

    function indexTheWorkcrew() private
    {
        for( uint x = 0; x < workcrew.length; x++ )
        {
            employeeIdIndex[ workcrew[x].employeeId ] = x;
            employeeNameIndex[ workcrew[x].employeeName ] = x;
        }
    }

    function addEmployee(address _employeeAddress, string _employeeName, address[3] _allowedTokens, uint _initialYearlySalary) onlyOwner
    {
        employeeIndex++;
        Employee memory newEmployee;
        newEmployee.employeeId = employeeIndex;
        newEmployee.employeeName = _employeeName;
        newEmployee.employeeAddress = _employeeAddress;
        newEmployee.allowTokens = _allowedTokens;
        newEmployee.yearlySalaryUSD = _initialUSDYearlySalary;
        newEmployee.startDate = now;
        newEmployee.lastPayday = now;
        newEmployee.lastTokenConfigDay = now;
        workcrew.push(newEmployee);
        indexTheWorkcrew();
    }

    function setEmployeeSalary(uint _employeeID, uint _yearlyUSDSalary) onlyOwner
    {
        workcrew[ employeeIdIndex[_employeeID] ].yearlySalaryUSD = _yearlyUSDSalary;
    }

    function removeEmployee(uint _employeeID) onlyOwner
    {
        delete workcrew[ employeeIdIndex[_employeeID] ];
        indexTheWorkcrew();
    }

    function addFunds() payable onlyOwner returns (uint) 
    {
        return this.balance;
    }

    function scapeHatch() onlyOwner
    {
        delete workcrew[];
        selfdestruct(owner);
    }

    function getEmployeeCount() constant onlyOwner returns (uint)
    {
        return workcrew.length;
    }

    function getEmployeeInfoByIdFromStruct(uint _employeeId) constant onlyOwner returns (Employee)
    {
        return workcrew[ employeeIdIndex[_employeeId] ];
    }

    function getEmployeeInfoById(uint _employeeId) constant onlyOwner returns (uint, string, uint, address, uint)
    {
        uint x = employeeIdIndex[_employeeId];
        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
    }
    
    function getEmployeeInfoByNameFromStruct(string _employeeName) constant onlyOwner returns (Employee)
    {
        return workcrew[ employeeNameIndex[_employeeName] ];
    }

    function getEmployeeInfoByName(string _employeeName) constant onlyOwner returns (uint, string, uint, address, uint)
    {
        uint x = employeeNameIndex[_employeeName];
        return (workcrew[x].employeeId, workcrew[x].employeeName, workcrew[x].startDate,
                workcrew[x].employeeAddress, workcrew[x].yearlySalaryUSD );
    }

    function calculatePayrollBurnrate() constant onlyOwner returns (uint)
    {
        uint monthlyPayout;
        for( uint x = 0; x < workcrew.length; x++ )
        {
            monthlyPayout += workcrew[x].yearlySalaryUSD / 12;
        }
        return monthlyPayout;
    }

    function calculatePayrollRunway() constant onlyOwner returns (uint)
    {
        uint dailyPayout = calculatePayrollBurnrate() / 30;
        uint daysRemaining = this.balance / dailyPayout;
        return daysRemaining;
    }

    function determineAllocation(address[] tokens, uint[] distribution)
    {
    }

    function payday(uint _employeeID) public
    {
        if( now < lastPayday + 4 weeks ){ throw; }
        if( msg.sender != workcrew[ employeeIdIndex[_employeeId] ].employeeAddress ){ throw; }
        uint paycheck = workcrew[ employeeIdIndex[_employeeId].yearlySalaryUSD / 12;
        msg.sender.transfer( paycheck );
    }
}
