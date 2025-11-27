/**
 * @description       : 
 * @author            : batuayyildiz@gmail.com
 * @group             : 
 * @last modified on  : 11-27-2025
 * @last modified by  : batuhan.ayyildiz@cci.com.tr
**/
public with sharing class CustomUnitOfWork {
    
    // Holds the objects passed in like Contact, Account etc.
    List<SObjectType> types;
    // Holds new records to be inserted
    Map<String, List<SObject>> newListByType;
    // Holds existing records to be updated
    Map<String, List<SObject>> changedListByType;
    // Holds the relationship info between two objects
    Map<String, Relationships> relationshipsByType;

    public CustomUnitOfWork(List<SObjectType> types){
        this.types = types;
        this.newListByType = new Map<String, List<SObject>>();
        this.changedListByType = new Map<String, List<SObject>>();
        this.relationshipsByType = new Map<String, Relationships>();

        // Call the handleRegisterType for every sObjectTypes passed in
        for(SObjectType type : types){
            this.handleRegisterType(type);
        }
    }

    private void handleRegisterType(SObjectType type){
        String sObjType = type.getDescribe().getName();

        this.newListByType.put(sObjType, new List<SObject>());
        this.changedListByType.put(sObjType, new List<SObject>());
        this.relationshipsByType.put(sObjType, new Relationships());
    }

    public void registerNew(SObject sObj){
        String sObjType = sObj.getSObjectType().getDescribe().getName();
        // Add the coming sobj record to the newListByType map
        newListByType.get(sObjType).add(sObj);
    }

    public void registerChange(SObject sObj){
        String sObjType = sObj.getSObjectType().getDescribe().getName();
        // Add the coming sobj record to the changedListByType map
        changedListByType.get(sObjType).add(sObj);
    }

    public void commitWork(){
        // Set up the rollback mechanism
        SavePoint savepoint = Database.setSavepoint();

        try {
            doInsert();
            doUpdate();
        } 
        catch (Exception e) {
            // Probably there should be a logging but keep it simple
            System.debug('Exception >>' + e.getMessage());
            
            Database.rollback(savepoint);
        }
    }

    private void doInsert(){
        for(SObjectType type : types){
            insert newListByType.get(String.valueOf(type));
        }
    }

    private void doUpdate(){
        for(SObjectType type : types){
            update changedListByType.get(String.valueOf(type));
        }
    }


    private class Relationship{}

    private class Relationships{}


}