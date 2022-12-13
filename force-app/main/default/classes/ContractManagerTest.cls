@IsTest
private class ContractManagerTest {
    @isTest static void testCreateContract() {
        // Call the method to test
        String resp = ContractManager.createContract(
            '0017S00000KVRznQAH', 'Draft', System.today(), 3);
        Contract thisContract = [SELECT Id, ContractTerm  FROM Contract];
        // Verify results
        System.assert(thisContract.Id != null);
        System.assertEquals(thisContract.ContractTerm, 3);
    }
   
    @isTest static void testUpdateContractFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://mindful-shark-8wkbjl-dev-ed.trailblaze.my.salesforce.com/services/apexrest/Contracts/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"Status": "Activated"}');
        RestContext.request = request;

        // Update ContractTerm of existing record
        Test.startTest();
        ID thisContractId = ContractManager.updateContractFields();
        Test.stopTest();

        // Verify record was updated
        System.assert(thisContractId != null);
        Contract thisContract = [SELECT Id,Status FROM Contract WHERE Id=:thisContractId];
        System.assert(thisContract != null);
        System.assertEquals(thisContract.Status, 'Activated');
    }  
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Contract contractTest = new Contract(
            AccountId = '0017S00000KVRznQAH',
            Status = 'Draft',
            StartDate = System.today(),
            ContractTerm = 3);
        Test.startTest();
        insert contractTest;
        Test.stopTest();
        return contractTest.Id;
    }          
}