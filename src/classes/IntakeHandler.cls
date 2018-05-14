/***************************************************
This trigger handler is to create Household and person
record from Intake parent survey when survey result is positve
in Intake parent survey. Also this controller, associates 
Intake, Household and persons.

******************************************************/



Public class IntakeHandler
{
  public static boolean bypassIntakeTrigger = false;
  public static void CreateAccountAndContacts(){
  
   // Created the below maps to bulkify this trigger to create Households and persons and associate those to correct Intake surveys and Intake Referrals.
   
    Map<Id,Map<String,Id>>mIntakeIdmObjNameObj=new Map<Id,Map<String,Id>>();
    Map<Id,Intake__c>mPostiveSurveyResult=new Map<Id,Intake__c>();
    Map<Id,Account>mIntakeAccounts=new Map<Id,Account>();
    Map<Id,Id>mIntakeIdAccId = new Map<Id,Id>();
    Map<Id,Contact> mIntakeContacts = new Map<Id,Contact>();
    Map<Id,Id>mIntakeIdConId= new Map<Id,Id>();
    Map<Id,Contact> mIntakeAdultContacts = new Map<Id,Contact>();
    Map<Id,Contact> mIntakeAdult2Contacts = new Map<Id,Contact>();
    Map<Id,List<Contact>> mIntakelChildContacts = new Map<Id,List<Contact>>();
    Map<Id,Id> mIntakeIdAdultConId = new Map<Id,Id>();
    Map<Id,Id> mIntakeIdAdult2ConId = new Map<Id,Id>();
    Map<Id,Id> mAdultConIdToIntakeId = new Map<Id,Id>();
    Set<Id> sSuccessIntakeIds = new Set<Id>();
    Id profileId=userinfo.getProfileId();
    // Get the values from Intake handler custom setting. This will avoid the hardcoding in the controller.
    Intake_trigger_values__c intakeCS = Intake_trigger_values__c.getInstance('Intake trigger handler');
   
    
    //populate account map from Intake data for both insert and update. This Account map is used to save the created account ID's to associate the househoulds to Intake.
    
    for(Intake__c Intake:(List<Intake__c>)Trigger.NewMap.Values()){
       if(Trigger.isInsert){
          system.debug('Input recordtype ID :' + Intake.recordTypeId);
          system.debug('Input screen status' + Intake.BRI_Screen_Status__c );
        if((Intake.BRI_Survey_Result__c == 'positive' && Intake.BRI_Create_Household_And_Persons__c == true) || (Intake.recordTypeId == intakeCS.RecordTypeId__c  && Intake.BRI_Screen_Status__c == 'Positive' && profileId == intakeCS.ProfileId__c && Intake.BRI_Create_Household_And_Persons__c == true )){
           system.debug('VVVVV Control comes to inside');
           Account acct=new Account();
           if(Intake.Adult_1_Last_Name__c != '' && Intake.Adult_1_Last_Name__c != null){
           acct.Name=Intake.Adult_1_Last_Name__c;
           system.debug('NNNN Intake name :' + Intake.Name);
           acct.Intake_Number__c = Intake.id;
           acct.Test_Field__c = Intake.name;
      
           system.debug('xxx controll comes here');
           mPostiveSurveyResult.put(Intake.Id,Intake);
           mIntakeAccounts.put(Intake.Id,acct);
        }
               
       }
    }
        if(Trigger.isUpdate){
     /*    if((((Intake__c)Trigger.oldMap.get(Intake.Id)).BRI_Survey_Result__c !='positive' 
            && ((Intake__c)Trigger.oldMap.get(Intake.Id)).BRI_Create_Household_And_Persons__c != true) ||
            (Intake.BRI_Survey_Result__c == 'positive' && Intake.BRI_Create_Household_And_Persons__c == true)) */
            
            if((Intake.BRI_Survey_Result__c == 'positive' && Intake.BRI_Create_Household_And_Persons__c == true) || (Intake.recordTypeId == intakeCS.RecordTypeId__c  && Intake.BRI_Screen_Status__c == 'Positive' && profileId == intakeCS.ProfileId__c && Intake.BRI_Create_Household_And_Persons__c == true ))
              {
               Account acct= new Account();
                acct.name=Intake.Adult_1_Last_Name__c;
          //      system.debug('NNNN Intake name :' + Intake.Name);
                  acct.Intake_Number__c = Intake.id;
             // This text field is used to get intake number  from intake and we pre-defined this field  on Household New Homevisit quick action to autopopulate Referral number for cpcs and Parentsurvey Number for HFI on Homevisits.   
                  acct.Test_Field__c = Intake.name;
                mPostiveSurveyResult .put(Intake.id,Intake);
                mIntakeAccounts.put(Intake.Id,acct);
         }
        }
       
  }
       // check map size and insert account records
       
       if(mPostiveSurveyResult.size()>0){
          integer accIndex=0;
          List<Id>lIntakeIds=new list<Id>();
          lIntakeIds.addAll(mIntakeAccounts.keySet());
          
          
             Database.SaveResult[] lsr = Database.insert(mIntakeAccounts.values(),false);            
            for(Database.SaveResult sr: lsr){
                if(sr.isSuccess()){
                   mIntakeIdAccId.put(lIntakeIds.get(accIndex),sr.getId());
                    accIndex++;
                }else{
                    Database.Error[] dbErr = sr.getErrors();
                    Trigger.newMap.get(lIntakeIds.get(accIndex)).addError(dbErr[0].getMessage());
                    accIndex++;
                    } 
                   }
                  } //end of accounts Insert
                  
    //for all the accounts that are successfully inserted, create Adult contacts and all Child Contacts at a time and insert Adult Contacts.
        if(mIntakeIdAccId.size()>0){
            Map<String,Schema.RecordTypeInfo> contRTs = Schema.SObjectType.Contact.getRecordTypeInfosByName();
            
           //Create Contact records for each successful account - Intakes
           for(Id intakeId : mIntakeIdAccId.keySet()){
                  if(mIntakeAccounts.containsKey(intakeId)){

                         Intake__c intakeInfo = (Intake__c)Trigger.newMap.get(intakeId); 

                         //create adult Contact
                         Contact adultcon = new Contact();
                         adultcon.LastName = intakeInfo.Adult_1_Last_Name__c;
                         adultcon.FirstName = intakeInfo.Adult1_First_Name__c;
                         adultcon.MiddleName = intakeInfo.Adult_1_Middle_Name__c;
                         adultcon.accountId = mIntakeIdAccId.get(intakeId);
                         adultcon.recordtypeid = contRTs.get('Adult 1').getRecordTypeId();
                         adultcon.HomePhone = intakeInfo.Phone_No__c;
                         adultcon.Email = intakeInfo.Email__c;
                         adultcon.MailingCity=intakeInfo.city__c;
                         adultcon.BRI_Phone_Type__c = intakeInfo.Phone_Type__c;
                         adultcon.BRI_SS_Number__c = intakeInfo.Social_Security_Number__c;
                         adultcon.BRI_Language__c = intakeInfo.Languages_Spoken_At_Home__c;
                     
                         
                         
                         //Populate all other Adult fields from Intake Adult1 Fields
                         mIntakeAdultContacts.put(intakeId, adultcon);
                         
                         //Check all each child contact record fields from Intake as field1 != null && field2 != null for all mandatory fields in if condition
                         
                         if(intakeInfo.Child_Last_Name__c != '' && intakeInfo.Child_Last_Name__c != null){
                             system.debug('SSSS Control comes to child data population');
                              Contact childcon = new Contact();
                              childcon.LastName = intakeInfo.Child_Last_Name__c;                                                
                              childcon.recordtypeid = contRTs.get('TGT - Child').getRecordTypeId();
                              //system.debug('TGT _ CILD');
                              //populate all other available child fields from Intake
                              
                              childcon.MiddleName = intakeInfo.Child_Middle_Name__c;
                              childcon.FirstName = intakeInfo.Child_First_Name__c;
                              childcon.Birthdate = intakeInfo.Child_DOB__c;
                              // To associate the child contact with household
                              childcon.accountId = mIntakeIdAccId.get(intakeId);
                               
                              mIntakelChildContacts = populateChildCons(mIntakelChildContacts,IntakeId,childcon);
                         }
                         //repeat above code for each child contact fields.
                         
                         /*The below code is to create the Adult2 contact if the Adult2 details are populated in Intake parent survey*/
                         
                         if(intakeInfo.BRI_Adult_2_Last_Name__c != '' && intakeInfo.BRI_Adult_2_Last_Name__c != null){
                      //       system.debug('SSSS Control comes to child data population');
                              Contact adult2con = new Contact();
                              adult2con.LastName = intakeInfo.BRI_Adult_2_Last_Name__c ;
                              adult2con.FirstName = intakeInfo.BRI_Adult_2_First_Name__c;
                              adult2con.MiddleName = intakeInfo.BRI_Adult_2_Middle_Name__c;
                              adult2con.accountId = mIntakeIdAccId.get(intakeId);
                              adult2con.recordtypeid = contRTs.get('Adult 2').getRecordTypeId();
                              adult2con.HomePhone = intakeInfo.BRI_Adult_2_Phone__c;
                         //     adultcon.Email = intakeInfo.Email__c;
                              adult2con.MailingCity=intakeInfo.BRI_Adult_2_City__c;
                              adult2con.BRI_Phone_Type__c = intakeInfo.BRI_Adult_2_Phone_Type__c;
                              adult2con.BRI_SS_Number__c = intakeInfo.BRI_Adult_2_Social_Security_Number__c;
                              adult2con.BRI_Language__c = intakeInfo.BRI_Adult_2_Language__c;
                               
                              mIntakeAdult2Contacts.put(intakeId, adult2con);
                         }
                         
                         /* end */
                  }
           }
           
           //Insert Adult Contact Records and handle Error for unsuccessful Contacts. The below code is to associate the Accounts and contacts correctly.
           if(mIntakeAdultContacts.size()>0){
                integer conIndex = 0;
                List<Id> lIntakeIds = new List<Id>();
                lIntakeIds.addAll(mIntakeIdAccId.keySet());
             
                Database.SaveResult[] lsr = Database.insert(mIntakeAdultContacts.values(),false);            
                for(Database.SaveResult sr: lsr){
                    if(sr.isSuccess()){
                       mIntakeIdAdultConId.put(lIntakeIds.get(conIndex),sr.getId());
                       mAdultConIdToIntakeId.put(sr.getId(),lIntakeIds.get(conIndex));
                       conIndex ++;
                    }else{
                       Database.Error[] dbErr = sr.getErrors();
                       Trigger.newMap.get(lIntakeIds.get(conIndex)).addError(dbErr[0].getMessage());
                       conIndex ++;
                    }
                }
           }//code ends for Adult contacts insert
           
           //Below code is to insert Adult2 contacts in person object
           
           if(mIntakeAdult2Contacts.size()>0){
                integer con2Index = 0;
                List<Id> l2IntakeIds = new List<Id>();
                l2IntakeIds.addAll(mIntakeIdAccId.keySet());
             
                Database.SaveResult[] lsr = Database.insert(mIntakeAdult2Contacts.values(),false);            
                for(Database.SaveResult sr: lsr){
                    if(sr.isSuccess()){
                       mIntakeIdAdult2ConId.put(l2IntakeIds.get(con2Index),sr.getId());
            //           mAdult2ConIdToIntakeId.put(sr.getId(),l2IntakeIds.get(con2Index));
                       con2Index ++;
                    }else{
                       Database.Error[] dbErr = sr.getErrors();
                       Trigger.newMap.get(l2IntakeIds.get(con2Index)).addError(dbErr[0].getMessage());
                       con2Index ++;
                    }
                }
           }
           
           //End of Adult2 contact insert

           //Insert child Contact records with population of Adult Contact Ids.
           if(mIntakelChildContacts.size()>0){
              integer conIndex = 0;
              List<Id> lIntakeIds = new List<Id>();
              lIntakeIds.addAll(mIntakeIdAdultConId.keySet());
              List<Contact> lAllChildContacts = new List<Contact>();

              //populate Adult Contact on Child Contacts
              for(Id IntakeId: lIntakeIds){
                if(mIntakelChildContacts.containsKey(IntakeId)){
                  for(Contact childCont: mIntakelChildContacts.get(IntakeId)){
                    childCont.Adult1_Contact__c = mIntakeIdAdultConId.get(IntakeId);
                    childCont.Adult2_Contact__c = mIntakeIdAdult2ConId.get(IntakeId);
                    
                    lAllChildContacts.add(childCont);
                  }
                }
              }//end of populating Adult Contact on Childs

              //get all child contacts and insert them
              if(lAllChildContacts.size()>0){
                Database.SaveResult[] lsr = Database.insert(lAllChildContacts,false);
                for(Database.SaveResult sr: lsr){
                    if(sr.isSuccess()){
                       sSuccessIntakeIds.add(sr.getId());
                       conIndex ++;
                    }else{
                       Database.Error[] dbErr = sr.getErrors();
                       if(mAdultConIdToIntakeId.containsKey(lAllChildContacts.get(conIndex).Adult1_Contact__c)){
                          Id failedIntakeId = mAdultConIdToIntakeId.get(lAllChildContacts.get(conIndex).Adult1_Contact__c);
                          if(failedIntakeId != null && sSuccessIntakeIds.contains(failedIntakeId)){
                             sSuccessIntakeIds.remove(failedIntakeId);
                             Trigger.newMap.get(failedIntakeId).addError(dbErr[0].getMessage());
                          }
                       }
                       conIndex ++;
                    }
                }
              }//end of all Child Contacts insert  
            }
               
        }//end of Contacts Insert

       
        //Now populate Account Ids for Intake records that are successfully inserted both Accounts and Contacts.
        List<Intake__c> lIntakesToUpdate = new List<Intake__c>();
        for(Id intakeId : mIntakeIdAccId.keySet()){
             system.debug('control comes here');
              if( Trigger.newMap.containsKey(intakeId) && mIntakeIdAccId.containsKey(intakeId) ){
                    Intake__c inta = (Intake__c) Trigger.newMap.get(intakeId);
                    
                    Intake__c householdupdate = new Intake__c();
                    
                    householdupdate.BRI_Household__c = mIntakeIdAccId.get(intakeId);
                                       
                   // This below line to populate the Household related list for referral record type
                    if(Inta.recordTypeId == intakeCS.RecordTypeId__c){
                       householdupdate.BRI_Referrals__c = mIntakeIdAccId.get(intakeId);
                    } 
                    
                    householdupdate.Id = inta.Id;
                     lIntakesToUpdate.add(householdupdate);
              }
         }

       if( lIntakesToUpdate.size()>0){
             //before updating Intake data, bypass the Triggers to avoid fire again from here.
             IntakeHandler.bypassIntakeTrigger = true;
             Database.SaveResult[] lsr = Database.update(lIntakesToUpdate,false);
       } 
    }
    
//since this population has to happen for each child - moved this code to separate method
    public static Map<Id,List<Contact>> populateChildCons(Map<Id,List<Contact>> mIntakelChildContacts, Id IntakeId, Contact childcon){
      //check the map already has a key with Intake id - if so pull that value : list  and add our contact to it.
      if(mIntakelChildContacts.containsKey(IntakeId)){
        mIntakelChildContacts.get(IntakeId).add(childcon);
      }else{
        //create a new list and add our contact to that and put it in the map.
        List<Contact> lChildCons = new List<Contact>();
        lChildCons.add(childcon);
        mIntakelChildContacts.put(IntakeId,lChildCons);
      }
      return mIntakelChildContacts;
    }
       
       
}