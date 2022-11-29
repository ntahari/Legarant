@IsTest
private class ContactManagerTest {
    @isTest static void testCreateContact() {
        // Call the method to test
        String resp = ContactManager.createContact(
            'Test FirstName', 'Test LastName', 'Test@test.com');
        Contact thisContact = [SELECT Id,FirstName FROM Contact];
        // Verify results
        System.assert(thisContact.Id != null);
        System.assertEquals(thisContact.FirstName, 'Test FirstName');
    }
    @isTest static void testDeleteContact() {
        Id recordId = createTestRecord();
        // Set up a test request
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://mindful-shark-8wkbjl-dev-ed.trailblaze.my.salesforce.com/services/apexrest/Contact/'
            + recordId;
        request.httpMethod = 'DELETE';
        RestContext.request = request;
        // Call the method to test
        ContactManager.deactiveContact();
        // Verify record is deleted
        Contact contactTest = [SELECT Id, IsActive__c FROM Contact WHERE Id=:recordId];
        System.assert(contactTest.IsActive__c == false);
    }
   
    @isTest static void testUpdateContactFields() {
        Id recordId = createTestRecord();
        RestRequest request = new RestRequest();
        request.requestUri =
            'https://mindful-shark-8wkbjl-dev-ed.trailblaze.my.salesforce.com/services/apexrest/Contact/'
            + recordId;
        request.httpMethod = 'PATCH';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{"FirstName": "test UpdateName"}');
        RestContext.request = request;
        // Update FirstName of existing record to test UpdateName
        ID thisContactId = ContactManager.updateContactFields();
        // Verify record was updated
        System.assert(thisContactId != null);
        Contact thisContact = [SELECT Id,FirstName FROM Contact WHERE Id=:thisContactId];
        System.assert(thisContact != null);
        System.assertEquals(thisContact.FirstName, 'test UpdateName');
    }  
    // Helper method
    static Id createTestRecord() {
        // Create test record
        Contact contactTest = new Contact(
            LastName='Test record',
            FirstName='Test firstName',
            Email='Test@test.com');
        insert contactTest;
        return contactTest.Id;
    }          
}