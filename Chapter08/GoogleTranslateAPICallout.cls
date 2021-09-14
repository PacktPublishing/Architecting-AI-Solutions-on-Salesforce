global without sharing class GoogleTranslateAPICallout {
    
	private static string endpoint = 'https://translation.googleapis.com/language/translate/v2';
    
    //replace with you API key
	private static string API_KEY = '<YOUR API KEY>';
    
    @InvocableMethod 
    public static List<String> getTranslation(List<String> inputs) { 
        //setup input to callout
        //only accepting one string for this example, bulkify if you want to use
        String inputStr = inputs[0];
        string body = '{"q":["' + inputStr + '"], "target":"zh"}';
        
        //setup callout
        Http h = new Http();
        HttpRequest req = new HttpRequest();
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint + '?key=' + API_KEY);
        req.setMethod('POST');
		req.setBody(body);

        // send the request, and return a response
        HttpResponse res = h.send(req);
        
        //get response and process JSON
        String resBody = res.getBody();
        
        Map<String, Object> parsedRes = (Map<String, Object>)JSON.deserializeUntyped(resBody);
        Map<String, Object> data = (Map<String, Object>)parsedRes.get('data');
        List<Object> translations = (List<Object>)data.get('translations');
        
        //generate response
        Map<String, Object> retTrans = (Map<String, Object>)translations[0];
        List<String> retVar = new List<String>();
        retVar.add((String)retTrans.get('translatedText'));
        return retVar;
    } 

}