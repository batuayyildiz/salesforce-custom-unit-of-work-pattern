/**
 * @description       : 
 * @author            : batuayyildiz@gmail.com
 * @group             : 
 * @last modified on  : 11-27-2025
 * @last modified by  : batuayyildiz@gmail.com
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

    @isTest
    static void it_should_update_existing_records(){
        // Given
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        List<SObjectType> types = new List<SObjectType>{Account.SObjectType, Contact.SObjectType};
        CustomUnitOfWork uow = new CustomUnitOfWork(types);
        acc.Name = 'Changed Account Name';
        uow.registerChange(acc);
        // When
        Test.startTest();
            uow.commitWork();
        Test.stopTest();
        // Then
        Account updatedAccount = [SELECT Name FROM Account LIMIT 1];
        Assert.areEqual('Changed Account Name', updatedAccount.Name, 'It should update the account record');
    }

    @isTest
    static void it_should_register_relationship(){
        // Given
        Account acc = new Account(Name = 'Test Account');
        Contact con = new Contact(FirstName = 'Test', LastName = 'Contact');
        CustomUnitOfWork uow = new CustomUnitOfWork(new List<SObjectType>{Account.SObjectType, Contact.SObjectType});
        uow.registerNew(acc);
        uow.registerNew(con);
        uow.registerRelationship(con, Contact.AccountId, acc);
        // When
        Test.startTest();
            uow.commitWork();
        Test.stopTest();
        // Then
        Contact updatedContact = [SELECT FirstName, LastName, AccountId
                                  FROM Contact
                                  LIMIT 1];
        Assert.isTrue(updatedContact.AccountId == acc.Id, 'It should register the relationship');
    }

}
