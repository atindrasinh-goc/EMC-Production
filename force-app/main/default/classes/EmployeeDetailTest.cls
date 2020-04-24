@isTest
public class EmployeeDetailTest {
    public static testmethod void employeeTest(){
        EmployeeDetails empDetail = new EmployeeDetails();
        empDetail.userId    = '01I31000001qwea';
        empDetail.firstName = 'test';
        empDetail.lastName  = 'EmployeeDetail';
        empDetail.email     = 'test123@gmail.com';
        empDetail.zipCode   = '382225';
        empDetail.city      = 'Cincinnati';
        empDetail.state     = 'Ohio';
        empDetail.employeeId     = '00B310000065iFf';
        empDetail.activationDate = '8/3/2019 12:00 AM';
        empDetail.role           = 'Driver';
        empDetail.managerId      = 'a001h000001swsP';
        empDetail.managerName    = 'Natvar';
        empDetail.vehicalType    = 'tesType';
        List<String> listDrivingStates = new List<String> {'CA','LA','OH','NY'};
        empDetail.drivingStates  = listDrivingStates;
        empDetail.deactivaedDate = '20/3/2019 06:00 AM';
        empDetail.lastPayDate    = '10/3/2019 10:00 AM';
        //empDetail.editmode       = true;
         empDetail.cellphone ='';
        empDetail.resetReimbursementLink = false;
        empDetail.IsDeactivated = false;
        empDetail.compliancestatus ='';
        empDetail.accountId      = '0011h00000LNa1f';
        empDetail.IsMassDeactivated = true;
        empDetail.approvalThreshold = '50';
        empDetail.appVersion = '5';
        empDetail.totalreimbursement = '57';
        empDetail.monthlymileageLimit = '1200';
        empDetail.fixedamount = '500';
        empDetail.branchName = 'abc';
        
    }
}