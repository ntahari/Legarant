@RestResource(urlMapping='/Contracts/*')
global with sharing class ContractManager {
    @HttpPost
    global static ID createContract(String AccountId, String status, Date StartDate, Integer ContractTerm) {
        Contract thisContract = new Contract(
            AccountId = AccountId,
            Status = status,
            StartDate = StartDate,
            ContractTerm = ContractTerm);
        insert thisContract;
        return thisContract.Id;
}   
    @HttpPatch
    global static ID updateContractFields() {
        RestRequest request = RestContext.request;
        String contractId = request.requestURI.substring(
            request.requestURI.lastIndexOf('/')+1);
        Contract thisContract = [SELECT Id FROM Contract WHERE Id = :contractId];
        // Deserialize the JSON string into name-value pairs
        Map<String, Object> params = (Map<String, Object>)JSON.deserializeUntyped(request.requestbody.tostring());
        // Iterate through each parameter field and value
        for(String fieldName : params.keySet()) {
            // Set the field and value on the Contract sObject
            thisContract.put(fieldName, params.get(fieldName));
        }
        System.debug('result: '+ thisContract);
        update thisContract;
        return thisContract.Id;
    }   
}
