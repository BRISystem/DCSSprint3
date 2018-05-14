/*********************************************************
The below trigger is used to create Households and contacts for
the Intake parent survey.Household and contacts will be created 
when the survey result is positive.

Created By: Sravani G
 Created Date:04/02/2018
**********************************************************/


trigger IntakeTrigger on Intake__c (before insert, before update, after insert,after update, after delete, before delete) {
      if(Trigger.isAfter){
        if(Trigger.isInsert || Trigger.isUpdate){
            if(IntakeHandler.bypassIntakeTrigger == false){
                     //handle account and contact insert if 'positive'
                   IntakeHandler.createAccountAndContacts();
            }
        }
    }
}