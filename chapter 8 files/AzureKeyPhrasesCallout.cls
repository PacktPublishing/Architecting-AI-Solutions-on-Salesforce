global without sharing  class AzureKeyPhrasesCallout {
    //replace with your own endpoint
	private static string endpoint = '<YOUR ENDPOINT>';
    
    //replace with you API key
	private static string API_KEY = '<YOUR API KEY>';
    
    @InvocableMethod 
    public static List<String> getKeyPhrases(List<String> inputs) { 
        //setup input to callout
        //only accepting one string for this example, bulkify if you want to use
        String inputStr = inputs[0];
        System.debug(inputStr);
        string body = '{"documents":[{"language":"en", "id":"1", "text": "' + inputStr + '"}]}';
        
        //setup callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setHeader('Ocp-Apim-Subscription-Key', API_KEY);
        req.setMethod('POST');
		req.setBody(body);

        // send the request, and return a response
        HttpResponse res = h.send(req);
        
        //get response and process JSON
        String resBody = res.getBody();
        Map<String, Object> parsedRes = (Map<String, Object>)JSON.deserializeUntyped(resBody);
        List<Object> docs = (List<Object>)parsedRes.get('documents');
        List<Object> keyPhrases = (List<Object>)((Map<String, Object>)docs[0]).get('keyPhrases');
        
        //combine returned phrases into single return string
        List<String> tmpRes = new List<String>();
        for (Object o : keyPhrases){
        	tmpRes.add((String)o);
        }
        List<String> retVar = new List<String>();
        retVar.add(String.join(tmpRes, ','));
        return retVar;
    } 

}