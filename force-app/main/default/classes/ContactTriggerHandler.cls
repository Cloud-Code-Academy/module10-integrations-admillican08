/**
 * @description       :
 * @author            : admillican08@gmail.comcntct
 * @group             :
 * @last modified on  : 07-22-2024
 * @last modified by  : admillican08@gmail.com
 **/

public with sharing class ContactTriggerHandler extends TriggerHandler {
  public ContactTriggerHelper conTrigHelper;
  public List<Contact> conLst = new List<Contact>();
  public Map<Id, Contact> conMap1 = new Map<Id, Contact>();
  public Map<Id, Contact> conMap2 = new Map<Id, Contact>();

  public ContactTriggerHandler(List<sObject> recordsLst) {
    super();
    this.conTrigHelper = new ContactTriggerHelper();
    this.conLst = convertTriggerListToCons(recordsLst);
  }

  public ContactTriggerHandler(Map<Id, sObject> recordsMap) {
    super();
    this.conTrigHelper = new ContactTriggerHelper();
    this.conMap1 = convertTriggerMapToCons(recordsMap);
  }

  public ContactTriggerHandler(
    Map<Id, sObject> recordsMapOld,
    Map<Id, sObject> recordsMapNew
  ) {
    super();
    this.conTrigHelper = new ContactTriggerHelper();
    this.conMap1 = convertTriggerMapToCons(recordsMapOld);
    this.conMap2 = convertTriggerMapToCons(recordsMapNew);
  }

  public static List<Contact> convertTriggerListToCons(List<sObject> objLst) {
    List<Contact> conLst = new List<Contact>();
    for (sObject obj : objLst) {
      conLst.add((Contact) obj);
    }
    return conLst;
  }

  public static Map<Id, Contact> convertTriggerMapToCons(
    Map<Id, sObject> objMap
  ) {
    Map<Id, Contact> conMap = new Map<Id, Contact>();
    for (Id objId : objMap.keySet()) {
      sObject obj = objMap.get(objId);
      conMap.put(objId, (Contact) obj);
    }
    return conMap;
  }

  public override void beforeInsert() {
    conTrigHelper.setDummyJsonId(this.conLst);
  }

  public override void afterInsert() {
    conTrigHelper.getContactDataFromExternalSystem(this.conMap2.values());
  }

  public override void afterUpdate() {
    conTrigHelper.createContactInExternalSystem(this.conMap2.values());
  }
}
