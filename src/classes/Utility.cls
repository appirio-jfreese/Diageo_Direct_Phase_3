/*******************************************************************************
	(c) 2013 Appirio, Inc.
Created By 	:	Vikash Goyal	(Appirio JDC) 
Story/Task	: US765/TA1462
Description	: Class contains the utility methods
*******************************************************************************/
global class Utility {
	
	private static String PRIVATE_KEY = 'mRMjHmlC1C+1L/Dkz8EJuw==';
	private static String ENCRYPTION_ALGO = 'AES128';
	
  
  webservice static string sendQuarterlyRequestEmail(List<String> contactIds){
  	String status = 'failure';
  	if(contactIds.size() > 0){
  		List<Messaging.Singleemailmessage> lstEmailMessages = new List<Messaging.Singleemailmessage>(); 		
  		String bodyText = 'This is a quarterly request to update your contact information for the ' + 
  											'Diageo National Accounts Program Communication emails. If you have changes ' +
  											'and/or would like to unsubscribe please click the link below. The link will ' +
  											'expire in 10 days. If you have no changes and want to continue receiving the program communications, '+
  											'there is no action required. Thank you.';
  	  //EmailTemplate template = [SELECT Id FROM EmailTemplate WHERE DeveloperName = 'Quarterly_Request_Email_Template'];
  	  for(Contact con : [SELECT Id, Name FROM Contact WHERE Id IN :contactIds]){
  	    String plainText = con.Id +'_'+ (Date.Today()).addDays(10);
  	    String encryptedText = encryptText(plainText);
  	    String encryptedUrl = 'http://dd3dev-diageodirect.cs10.force.com/signup?key='+Encodingutil.urlEncode(encryptedText, 'UTF-8');
  	    Messaging.Singleemailmessage mail = new Messaging.Singleemailmessage();
	  	  //mail.setTemplateId(template.Id);
	  	  mail.setHtmlBody('Hi '+con.Name+',<br/><p>'+bodyText+'</p><br/><p>'+encryptedUrl+'</p>');
	  	  mail.setTargetObjectId(con.Id);
	  	  lstEmailMessages.add(mail);
  	  }
  	
  	  List<Messaging.Sendemailresult> result = Messaging.sendEmail(lstEmailMessages);
  	  if(result[0].isSuccess()){
  	  	status = 'success';
  	  }
  	}
  	return status;
  }
  
  private static String encryptText(String plainText){
    String encodedCipherText = null;
    if(plainText != null && !plainText.trim().equals('')){
      encodedCipherText = plainText;
			Blob key = EncodingUtil.base64Decode(PRIVATE_KEY);
			Blob cipherText = Crypto.encryptWithManagedIV(ENCRYPTION_ALGO, key, Blob.valueOf(plainText));
			encodedCipherText = EncodingUtil.base64Encode(cipherText);
		}
		return encodedCipherText;
	}
  
}