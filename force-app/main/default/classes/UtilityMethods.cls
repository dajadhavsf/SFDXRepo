/*
    Utility method definations
    @CreatedBy : Deepak
    @LastmodifiedBy : Deepak
    */
    public class UtilityMethods{
        
        /*Describe standard and custom objects from org*/
        public static Map<String, Schema.SObjectType> globalDescribe(){
            
            return Schema.getGlobalDescribe();
        }
        public static SObject instanceofSobjectFromObjName(String objName,String recId){ 
            Schema.SobjectType objType = getObjectType(objName);
            if(String.isNotBlank(recId)){
                return objType.newSObject(recId);
            }
            return objType.newSObject();
        }
        public static  Schema.SObjectType getObjectType(String objectName){
            Map<String, Schema.SObjectType> objDescribe = globalDescribe();
            Schema.SObjectType objType = objDescribe.get(ObjectName);
            return objType ;
        }    
        /* Descibe Sobject schema
    * @param String ObjectName SObject name to be described
    */
        public static Schema.DescribeSObjectResult describeSObject(String ObjectName){
            
            Schema.SObjectType objType = getObjectType(ObjectName);
            Schema.DescribeSObjectResult describeResult = objType.getDescribe();
            return describeResult;
        }
        /*
    * Descibe field schema
    * @param String objectName object name whose field need to be described
    * @param String fieldName  field to be described
    */
        public static Schema.DescribeFieldResult describeField(String objectname, String fieldName){
            
            Schema.DescribeSObjectResult describeResult = describeSObject(objectName);
            
            Map<String,Schema.SobjectField> fieldMap = describeResult.fields.getMap();
            
            Schema.DescribeFieldResult fieldResult = fieldMap.get(fieldName).getDescribe();
            
            return fieldResult;
        }  
        
        public static Map<String,Schema.SobjectField>  getSobjectFields(String objectname){
            
            Schema.DescribeSObjectResult describeResult = describeSObject(objectName);
            
            Map<String,Schema.SobjectField> fieldMap = describeResult.fields.getMap();
            
            return fieldMap;
        }   
        
        /* Fetch List of updated object fields  
    * @param SObject oldRec old record 
    * @param SObject newRec new record
    * @param List<Schema.SobjectField> fieldsList list of object fields
    */
        public static List<String> getUpdatedFields(SObject oldRec,SObject newRec,List<Schema.SobjectField> fieldsList){
            
            List<String> updatedFieldList = new List<String>();
            
            for(Schema.SobjectField field : fieldsList){
                
                Object oldValue = oldRec.get(field);
                
                Object newValue = newRec.get(field);
                
                if(newValue != oldValue)
                {
                    Schema.DescribeFieldResult result = field.getDescribe();
                    updatedFieldList.add(result.getName());
                }
            }
            return updatedFieldList;
        }
        
        public static boolean hasSobjectField(String objectname, String fieldName)
        {
            Schema.DescribeSObjectResult describeResult = describeSObject(objectName);
            
            Map<String,Schema.SobjectField> fieldMap = describeResult.fields.getMap();
            
            if(fieldMap.containsKey(fieldName)){
                return true;
            }
            
            return false;
        }
        
        /* Get all field set members
    * @param String ObjectName SObject name of FieldSet
    * @param String fieldSetName Field Set name
    */
        public static List<Schema.FieldSetMember> getFieldSetMembers(String objectName , String fieldSetName){
            
            Map<String, Schema.FieldSet> objFieldSetMap = new Map<String, Schema.FieldSet>();
            
            List<Schema.FieldSetMember> fieldSetMemberList = new List<Schema.FieldSetMember>();
            
            Schema.DescribeSObjectResult describeResult = describeSObject(objectName);
            
            objFieldSetMap = describeResult.fieldSets.getMap();
            
            Schema.FieldSet fieldSet = objFieldSetMap.get(fieldSetName);
            
            fieldSetMemberList = fieldSet.getFields();
            
            return fieldSetMemberList;
        }
        public static Schema.DisplayType getFieldType(String objectName, String fieldName){
            Schema.DescribeFieldResult fieldResult = describeField(objectName,fieldName);
            
            Schema.DisplayType displayType = fieldResult.getType();
            return displayType;
        }
        /*
    * getPickListMap 
    * @param String objectName object name whose field need to be described
    * @param String fieldName  field to be described
    * return Map<String, String> of active picklist values
    */
        
        public static  Map<String, String>  getPickListMap(String objName,String fieldName){
            Map<String, String>  optionMap = new  Map<String, String> ();        
            
            for(Schema.PicklistEntry f :Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
                if(f.isActive()){
                    optionMap.put(f.getValue(),f.getLabel());
                }
            }
            return optionMap;
        }
        public static  Map<String, String>  getPickListLabelValMap(String objName,String fieldName){
            Map<String, String>  optionMap = new  Map<String, String> ();        
            
            for(Schema.PicklistEntry f :Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getPicklistValues()){
                if(f.isActive()){
                    optionMap.put(f.getLabel(),f.getValue());
                }
            }
            return optionMap;
        }
        /*
    * Get all picklist values of picklist type field
    * @param String objectName picklist field object name 
    * @param String fieldName  picklist field name 
    */
        public static List<Schema.PicklistEntry> getPicklistFieldValues(String objectName, String fieldName){
            
            List<Schema.PicklistEntry> entryList = new List<Schema.PicklistEntry>();
            
            Schema.DescribeFieldResult fieldResult = describeField(objectName,fieldName);
            
            Schema.DisplayType displayType = fieldResult.getType();
            
            if(displayType == Schema.DisplayType.Picklist || displayType == Schema.DisplayType.MultiPicklist) 
            {
                entryList = fieldResult.getPicklistValues();
            }
            return entryList;
        }
        /*
    * Get all picklist values in string of picklist type field
    * @param String objectName picklist field object name 
    * @param String fieldName  picklist field name 
    */
        public static List<String> getPicklistFieldStrValues(String objectName, String fieldName){
            List<String> picklistvalues = new List<String>();
            List<Schema.PicklistEntry> picklistentrlist = new List<Schema.PicklistEntry>();
            picklistentrlist = getPicklistFieldValues(objectName,fieldName);
            for(Schema.PicklistEntry pickentr : picklistentrlist){
                picklistvalues.add(pickentr.getValue());
            }
            return picklistvalues;
        }
        
        /*
    * Get Record Types of given object
    * @param String objectName Object whose Record Type to be described
    * @param String developerName  Record Type Developer Name
    */
        public static Id getRecordTypeIdByDeveloperName(String objectName,String developerName){
            
            Schema.DescribeSObjectResult describeResult = describeSObject(objectname);
            Map<String,Schema.RecordTypeInfo> devnameToRecTypeinfo = describeResult.getRecordTypeInfosByDeveloperName();
            Schema.RecordTypeInfo recTypeInfo = devnameToRecTypeinfo.get(developerName);
            return  recTypeInfo.getRecordTypeId();      
        }
        
        
        
        public static Boolean isBypassTrigger(String objname)
        {
            String fieldapi = '';
            Boolean isBypass = false;
            Id profileId = UserInfo.getProfileId();
            Id userId = UserInfo.getUserId();
            Bypass_Switch__c bypassswitch = Bypass_Switch__c.getOrgDefaults();
            
            
            
            if(String.isNotBlank(objname)){
                objname = objname + '__c';
            }
            
            
            
            Schema.DescribeFieldResult fieldResult = UtilityMethods.describeField('Bypass_Switch__c',objname);
            
            
            
            Bypass_Switch__c bypassDefault = Bypass_Switch__c.getOrgDefaults();
            
            
            
            Bypass_Switch__c bypassProfile = Bypass_Switch__c.getValues(profileId);
            
            
            
            Bypass_Switch__c bypassUser = Bypass_Switch__c.getValues(userId);
            
            
            
            fieldapi = (String)fieldResult.getName(); 
            System.debug('fieldapi****' + fieldapi );
            System.debug('objname*****' + objname);
            if(objname.equalsIgnoreCase(fieldapi))
            {
                if(bypassUser != NULL){
                    isBypass = (Boolean)bypassUser.get(objname);
                }
                if(bypassProfile != NULL && !isBypass ){
                    isBypass = (Boolean)bypassProfile.get(objname);
                } 
                if(!isBypass){
                    isBypass = (Boolean)bypassDefault.get(objname);
                }
                return isBypass;
            }
            return bypassDefault.Enable__c;
        }    
        /**
    * Get Error Log
    * @param boolean sfadmin  To Notify SFDC Help
    * @param boolean sfhelp   To Notify SF Admins / DEV 
    * @param String type      Type of error
    * @param String errorLoc  Error location(Class: and Method:)   
    * @param String errorMsg  Error Message 
    */
        public static Global_error_log__c errorLog(boolean sfadmin, boolean sfhelp, String type, String errorLoc,String errorMsg ){
            Global_error_log__c globErr = new Global_error_log__c(
                Notify_SF_Admins_DEV__c = sfadmin, 
                Notify_SFDC_Help__c = sfhelp,
                Type__c = type,
                Error_Location__c = errorLoc, 
                Error_Message__c = errorMsg);
            return globErr;
        }   
        
        /**
    * @description : Retuns values for specific column(pass cell no in parameter) 
    * @author dejadhav | 7/24/2019
    * @param String reportName : Mandatory
    * @param Integer cellno : Mandatory
    * @return List<Object> : Report Column values
    */
        public static List<Object> getReportColumnValues(String reportName , Integer cellno)
        {
            List<Object> cellValueList = new List<Object>();
            if(String.isNotBlank(reportName))
            {    
                // Get the report ID
                List <Report> reportList = [SELECT Id,DeveloperName FROM Report where 
                                            DeveloperName =: reportName];
                
                String reportId = '';
                if(!Test.isRunningTest()){
                    reportId = (String)reportList.get(0).get('Id');
                }else{
                    reportId = Label.ReportId;
                }
                // Run a report synchronously
                Reports.reportResults results = Reports.ReportManager.runReport(reportId, true);
                
                //-----------------Without grouping------------------------------------
                MAP<String,Reports.ReportFact> factMap = results.getFactMap();
                
                for(String str : factMap.KeySet())
                {
                    // Get the fact map from the report results
                    Reports.ReportFactWithDetails factDetails =
                        (Reports.ReportFactWithDetails)results.getFactMap().get(str);   
                    List<reports.ReportDetailRow> rptDetailRow = factDetails.getRows();
                    
                    for(reports.ReportDetailRow detRow : rptDetailRow ){
                        List<reports.ReportDataCell> dataCellList = detRow.getDataCells(); 
                        for(Integer i= 1 ; i <=dataCellList.size() ; i++ ){
                            if(i == cellno){
                                cellValueList.add(dataCellList[i].getValue());
                                break;  
                            }       
                        }
                        /* for(reports.ReportDataCell dataCell : dataCellList)
    {
    objectId.add(dataCell.getValue());
    break;
    }*/
                    }   
                }
            }
            return cellValueList;
        } 
        
        public static List<String> getFieldSetMembersStrList(Schema.sObjectType objType,String fieldSetName)
        {
            
            List<String> retriveFieldList = new List<String>();
            List<Schema.FieldSetMember> fieldSetMemberList = UtilityMethods.getFieldSetMembers(String.valueof(objType),fieldSetName);
            
            for(Schema.FieldSetMember member : fieldSetMemberList ){  
                retriveFieldList.add(member.getFieldPath());    
            }
            
            return retriveFieldList;
        }
        
        /**
    * @description : Fetch record type based picklist values using the sf std. API authenticated using connected app 
    *                1. Independent picklist values will be : {default = (<picklist values>) }
    *                2. Dependent picklist values will be : { <parent values> = (<child values>) } 
    * @author dejadhav | 11/8/2019 
    * @param objectApiName 
    * @param fieldApiName 
    * @param recordTypeId 
    * @return List<String> 
    **/
        public static Map<String,List<String>> getRecordTypeSpecificPickListValues(String objectApiName,String fieldApiName,String recordTypeId , String namedCredentials)
        {
            Map<String,List<String>> parentChildPickValuesMap = new Map<String,list<String>>();
            Map<Object,String> controllerValuesMap = new Map<Object,string>();
            List<String> pickListValues = new List<String>();
            String validFor = '';
            String response = '';
            
            if( String.isNotBlank(objectApiName) && String.isNotBlank(recordTypeId) && String.isNotBlank(fieldApiName)){
                
                String apiUrl = '/services/data/'+ Label.Version + '/ui-api/object-info/' + objectApiName + '/picklist-values/' + recordTypeId + '/' + fieldApiName;
                String endPoint = namedCredentials + apiUrl; //create end point urls
                
                HttpRequest httpRequest = new HttpRequest();  
                httpRequest.setMethod('GET');   
                httpRequest.setEndpoint(endPoint);  
                
                
                Http http = new Http();   
                HttpResponse httpResponse = http.send(httpRequest);
                
                if (httpResponse.getStatusCode() == 200){  
                    Map<String, Object> deserializeMap = (Map<String, Object>)JSON.deserializeUntyped(httpResponse.getBody()); //Parse response
                    
                    if(!deserializeMap.isEmpty() && deserializeMap.containsKey('controllerValues')){
                        Map<String,object> contValuesMap = (Map<String,object>)deserializeMap.get('controllerValues');  //Fetch all controller values for dependent picklist otherwise this will be blank 
                        if(contValuesMap != NULL){
                            for(String key : contValuesMap.keySet()){
                                controllerValuesMap.put(contValuesMap.get(key),key);//Parent values
                                parentChildPickValuesMap.put(key,new List<String>());
                            }
                        }
                    }
                    
                    if(!deserializeMap.isEmpty() && deserializeMap.containsKey('values')) //Fetch all picklist field values
                    {
                        for(Object obj : (List<Object>)deserializeMap.get('values')){
                            Map<String,Object> objMap = (Map<String,Object>) obj;
                            if(objMap != NULL){
                                String value = String.valueof(objMap.get('value')); //Child values 
                                List<Object> objList =(list<Object>)objMap.get('validFor'); //Parent for child
                                if(!objList.isEmpty()){
                                    for(Object objVal : objList){
                                        String str = controllerValuesMap.get(objVal);
                                        if( parentChildPickValuesMap.containsKey(str)){
                                            parentChildPickValuesMap.get(str).add(value);
                                        }
                                    }
                                }else{
                                    pickListValues.add(value);
                                    parentChildPickValuesMap.put('default',pickListValues); // default -> child values map in case of independent picklist
                                }    
                            }
                        }  
                    } 
                } 
                
            }
            return parentChildPickValuesMap;
        }
        public class EmailAttributes{
            public List<String> toAddressList;
            public List<String> ccAddressList;
            public String subject = '';
            public String body = '';
            public String templateId = '';
            public String whatId = '';
            public String replyTo = '';
            public String htmlbody = '';
            public EmailAttributes(){
                toAddressList = new List<String>();
                ccAddressList = new List<String>();
            }
        }     
    public static string sendEmail(){
            string var = '';
            return var;
        }
        public static string sendEmail(String emailAttrJson)
        {    
            try{
                
                UtilityMethods.EmailAttributes emailAttrWrap = (UtilityMethods.EmailAttributes)json.deserialize(emailAttrJson,UtilityMethods.EmailAttributes.class);
                Messaging.SingleEmailMessage singleEmailMsg = new Messaging.SingleEmailMessage(); 
                singleEmailMsg.setToAddresses(emailAttrWrap.toAddressList);
                singleEmailMsg.setCcAddresses(emailAttrWrap.ccAddressList);
                singleEmailMsg.setSubject(emailAttrWrap.subject);
                singleEmailMsg.setPlainTextBody(emailAttrWrap.body);
                singleEmailMsg.setReplyTo(emailAttrWrap.replyTo);
                if(emailAttrWrap.htmlbody == 'error')
                {
                    return 'error';
                }
                else{
                    singleEmailMsg.setHtmlBody(emailAttrWrap.htmlbody);
                }
                List<OrgWideEmailAddress> lstEmailAddress=[select Id from OrgWideEmailAddress WHERE Address=:Label.CSPPartnerEmail];
                singleEmailMsg.setOrgWideEmailAddressId(lstEmailAddress[0].Id);
                List<Messaging.SendEmailResult> results =  Messaging.sendEmail(new List<Messaging.SingleEmailMessage> {singleEmailMsg});
                return 'Success';
            }Catch(Exception e){
                List<Global_error_log__c> errorLogList = new List<Global_error_log__c>();
                String location  = 'Class : UtilityMethods, Method : sendEmail'; 
                String message = 'Exception msg = ' + e.getLineNumber() +' '+ e.getMessage() + ' ' + e.getStackTraceString();       
                errorLogList.add(UtilityMethods.errorLog(true,true,'UtilityMethods Error',location,message));
                insert errorLogList;
                return 'error';
            }
        }
        public static void getCookieList(String name, String value, String path, Integer maxAge,Boolean isSecure,List<Cookie> ckList){
            Cookie ck = new Cookie(name, value, path, maxAge, isSecure);
            ckList.add(ck); 
        }
        
        public static string getEncryptedCookie(String param)
        {
            Blob key = Blob.valueOf(System.Label.CSPEncryptionKey);
            String dcstr = EncodingUtil.urlDecode(param, 'UTF-8');
            system.debug('cc1>>'+dcstr);
            Blob enstr = EncodingUtil.base64Decode(dcstr);
            system.debug('cc2>>'+enstr.toString());
            Blob blobData = Crypto.encryptWithManagedIV('AES128', key,enstr);
            String blobstr = EncodingUtil.base64Encode(blobData);
            System.debug('---------'+blobstr);
            return blobstr;
            //   Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, EncodingUtil.base64Decode(blobstr));
            
            //   String decryptedString = decrypted.toString();
            //    System.debug('decryptedString--'+decryptedString);
            //System.debug('blobData--'+Crypto.encryptWithManagedIV('AES128', Crypto.generateAesKey(128),c1).tostring());
            
        }
        
        public static string getDecryptedCookie(String param)
        {
            Blob key = Blob.valueOf(System.Label.CSPEncryptionKey);
            Blob decrypted = Crypto.decryptWithManagedIV('AES128', key, EncodingUtil.base64Decode(param));
            return decrypted.toString();  
        }
        public static String getPlatformTranslation(String platform){
            Map<String,PlatformTranslation__c> platformtransmap = new Map<String,PlatformTranslation__c>();
            platformtransmap = PlatformTranslation__c.getAll();
            if(!platformtransmap.isEmpty() && platformtransmap.containsKey(platform) ){
                return  platformtransmap.get(platform).Platform_Code__c;
            }
            return '';
        }
        public static String getSObjectQuery(String objName , 
                                             String selectFieldset,
                                             String filtername,
                                             String operator,
                                             String filterval )
        {
            String selectfields = '';
            String query = '';
            
            Schema.SObjectType objType = UtilityMethods.getObjectType(objName);
            List<String> members = UtilityMethods.getFieldSetMembersStrList(objType,selectFieldset);
            if(!members.isEmpty()){
                selectfields = String.join(members,',');
                query = 'Select '+selectfields + ' ' + 'From' + ' ' + objName +' '+ 'Where' +' '+ filtername + ' '+operator+' ' + filterval;  
            }
            
            return query;
        }
    }