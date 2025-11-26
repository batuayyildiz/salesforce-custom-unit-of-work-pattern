/**
 * @description       : 
 * @author            : batuayyildiz@gmail.com
 * @group             : 
 * @last modified on  : 11-26-2025
 * @last modified by  : batuhan.ayyildiz@cci.com.tr
**/
@isTest
public with sharing class CustomUnitOfWork_Test {
    
    @isTest
    static void it_should_insert_new_records(){
        // Given
        List<SObjectType> types = new List<SObjectType>{Account.SObjectType, Contact.SObjectType};
        CustomUnitOfWork uow = new CustomUnitOfWork(types);
        uow.registerNew(new Account(Name = 'Test Account'));
        uow.registerNew(new Contact(FirstName = 'Test', LastName = 'Contact'));
        // When
        Test.startTest();
            uow.commitWork();
        Test.stopTest();
        // Then
        Contact testContact = [SELECT FirstName, LastName
                                   FROM Contact
                                   WHERE FirstName = 'Test' AND LastName = 'Contact' 
                                   LIMIT 1];

        Assert.areEqual('Test', testContact.FirstName, 'It should commit the contact record');
    }
}