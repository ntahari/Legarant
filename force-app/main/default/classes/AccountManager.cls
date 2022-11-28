@RestResource(urlMapping='/Account/*')
global with sharing class AccountManager {
    @HttpPost
    global static ID createAccount(String Name) {
        Account thisAcc = new Account(Name = Name);
        insert thisAcc;
        return thisAcc.Id;
    } 
}
