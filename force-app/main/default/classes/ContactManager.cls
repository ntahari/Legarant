@RestResource(urlMapping='/Contact/*')
global with sharing class ContactManager {
    @HttpPost
    global static String createContact(String FirstName, String LastName, String Email) {
        List<Contact> existCont = [SELECT Id FROM Contact WHERE Email = :Email];
        if (existCont.size() > 0) {
            return 'This contact already exists: ' +existCont[0].Id;
        } 
        Contact thisContact = new Contact(
            FirstName = FirstName,
            LastName  = LastName,
            Email = Email);
        insert thisContact;
        // Return the Contact ID.
        return 'Your new contact ID is: ' +thisContact.Id;
    }

    @HttpPatch
    global static ID updateContactFields() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Case sObject
            thisContact.put(fieldName, params.get(fieldName));
        }
        update thisContact;
        return thisContact.Id;
    }    
    @HttpDelete
    global static void deactiveContact() {
        RestRequest request = RestContext.request;
        String contactId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contact thisContact = [SELECT Id FROM Contact WHERE Id = :contactId];
        //Update the customized field isActive to deactivate the contact
        thisContact.isActive__c = false;
        update thisContact;
    }     
}
