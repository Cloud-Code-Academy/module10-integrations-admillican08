/**
 * @description       :
 * @author            : admillican08@gmail.com
 * @group             :
 * @last modified on  : 07-22-2024
 * @last modified by  : admillican08@gmail.com
 **/

public with sharing class ContactTriggerHelper {
  // When a contact is inserted (before insert)
  // if DummyJSON_Id__c is null, generate a random number between 0 and 100 and set this as the contact's
  // DummyJSON_Id__c value
  public void setDummyJsonId(List<Contact> conLst) {
    Double dbl = Math.random() * 100;
    Integer randomInt = Integer.valueOf(dbl.round());
    for (Contact con : conLst) {
      if (String.isBlank(con.DummyJSON_Id__c)) {
        con.DummyJSON_Id__c = String.valueOf(randomInt);
      }
    }
  }

  //When a contact is inserted (after insert)
  // if DummyJSON_Id__c is less than or equal to 100, call the getDummyJSONUserFromId API
  public void getContactDataFromExternalSystem(List<Contact> conLst) {
    for (Contact con : conLst) {
      String jsonIdStr = con.DummyJSON_Id__c;
      if (!String.isBlank(jsonIdStr) && Integer.valueOf(jsonIdStr) <= 100) {
        DummyJSONCallout.getDummyJSONUserFromId(jsonIdStr);
      }
    }
  }

  //When a contact is updated (after update)
  // if DummyJSON_Id__c is greater than 100, call the postCreateDummyJSONUser API
  public void createContactInExternalSystem(List<Contact> conLst) {
    for (Contact con : conLst) {
      String jsonIdStr = con.DummyJSON_Id__c;
      if (!String.isBlank(jsonIdStr) && Integer.valueOf(jsonIdStr) >= 100) {
        DummyJSONCallout.postCreateDummyJSONUser(con.Id);
      }
    }
  }
}
