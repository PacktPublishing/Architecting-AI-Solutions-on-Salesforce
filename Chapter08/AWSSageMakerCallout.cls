global without sharing  class AWSSageMakerCallout {
    //replace with your own endpoint
	private static string endpoint = '<YOUR ENDPOINT>';
    
    //constants representing ordering of arguments
    private static Integer ORIGIN    = 0;
    private static Integer PRIORITY  = 1;
    private static Integer PRODUCT   = 2;
    private static Integer REASON    = 3;
    private static Integer CASETYPE  = 4;
    
    //method to get index of picklist value
    private static Integer getPicklistIndex(SObject sobj, String fieldName, String pickVal){ 
    	Schema.DescribeFieldResult fieldResult = sobj.getSobjectType().getDescribe().fields.getMap().get(fieldName).getDescribe();
		List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
		Integer i=0;
		Map<String,Integer> mapStat=new Map<String,Integer>();
        for(Schema.PicklistEntry pp:ple){
			mapStat.put(pp.getValue(),i++);
    	}
    	return mapStat.get(pickVal);
	}
    
    @InvocableMethod 
    public static List<String> getLiabilityState(List<List<String>> inputs) { 
        //setup input to callout
        List<String> inputList = inputs[0];
        
        //convert inputs to indices for processing
        List<Integer> intInputs = new List<Integer>();
        
        intInputs.add(getPicklistIndex((SObject)new Case(), 'Origin', inputList[ORIGIN]));
        intInputs.add(getPicklistIndex((SObject)new Case(), 'Priority', inputList[PRIORITY]));
        intInputs.add(getPicklistIndex((SObject)new Case(), 'Product__c', inputList[PRODUCT]));
        intInputs.add(getPicklistIndex((SObject)new Case(), 'Reason', inputList[REASON]));        
        intInputs.add(getPicklistIndex((SObject)new Case(), 'Type', inputList[CASETYPE]));
        
        String dataVals = String.join(intInputs, ',');
        string body = '{"data":"' + dataVals + '"}';
        
        //setup callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod('POST');
		req.setBody(body);

        // send the request, and return a response
        HttpResponse res = h.send(req);
        String resBody = res.getBody();
		Map<String, Object> parsedRes = (Map<String, Object>)JSON.deserializeUntyped(resBody);
        List<String> retVar = new List<String>();
        retVar.add((String)parsedRes.get('result'));
        return retVar;
    } 

}
