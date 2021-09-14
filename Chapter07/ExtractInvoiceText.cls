global without sharing class ExtractInvoiceText { 
    private static string task    = 'text';
    private static string modelID = 'OCRModel';
    
    @InvocableMethod 
    public static List<String> extractText(List<List<String>> e) { 
        ContentVersion base64Content = [SELECT Title, VersionData FROM 
                                        ContentVersion where Id = :e[0][0] ORDER BY Title LIMIT 1];    
        Blob fileBody =base64Content.VersionData;
        String fileAsString = EncodingUtil.base64Encode(fileBody);
        einsteinplay.Einstein_PredictionService service = new einsteinplay.Einstein_PredictionService(einsteinplay.Einstein_PredictionService.Types.OCR);
        
        einsteinplay.Einstein_PredictionResult predResult = service.predictOcrBase64(modelID, fileAsString, task, 2, null);
        system.debug('Probabilities: ' + predResult.probabilities);
		
        string retStr = '';
        
        for (einsteinplay.Einstein_Probability p : predResult.probabilities){
            retStr += p.label + '\n';
        }
        
        return new List<String>{retStr};
    } 

    global class ExtractVar { 
        @InvocableVariable(label='contentVersionId' required=true)  
        global Id contentVersionID;         
    } 
}