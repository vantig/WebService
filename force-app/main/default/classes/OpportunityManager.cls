@RestResource(UrlMapping='/Opportunity/*')
global with sharing class OpportunityManager {
    @HttpGet
    global static List<Opportunity> getOpportunities() {

        return [
                SELECT Id,External_Id__c
                FROM Opportunity
                WHERE External_Id__c != NULL
        ];

    }
    @HttpPut
    global static void upsertOpportunity() {

        RestResponse res = RestContext.response;
        String jsonResponse = '';
        try {
            RestRequest req = RestContext.request;
            Blob body = req.requestBody;
            String requestString = body.toString();
            JSONtoOpportunities result = JSONtoOpportunities.parse(requestString);

            jsonResponse = JSON.serialize(Database.upsert(result.opportunities, Opportunity.External_Id__c.getDescribe().getSobjectField(), false));

            List<Opportunity>insertedOpportunitiesWithRelatedAccount = [SELECT External_Id__c FROM Opportunity WHERE External_Id__c IN :JSONtoOpportunitiesHelper.namesOfRelatedAccounts.keySet()];



            AccountHelper accHelper = new AccountHelper(new List<String>(new Set<String>(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.values())));

            accHelper.reQueryByNames();

            for (Opportunity opp : insertedOpportunitiesWithRelatedAccount) {

                opp.AccountId = accHelper.getAccount(JSONtoOpportunitiesHelper.namesOfRelatedAccounts.get(opp.External_Id__c)).Id;

            }

            Database.update(insertedOpportunitiesWithRelatedAccount, false) ;


            res.addHeader('Content-Type', 'application/json;charset=UTF-8');
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 200;
        } catch (Exception e) {
            res.addHeader('Content-Type', 'application/json;charset=UTF-8');
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 400;
        }
    }

    @HttpDelete
    global static void deleteOpportunity() {
        RestRequest request = RestContext.request;
        String oppId = request.requestURI.substring(
                request.requestURI.lastIndexOf('/') + 1);
        Opportunity opp = [SELECT External_Id__c FROM Opportunity WHERE External_Id__c = :oppId];
        RestResponse res = RestContext.response;
        String jsonResponse = '';
        try {
            jsonResponse = JSON.serialize(Database.delete(opp) );
            res.addHeader('Content-Type', 'application/json;charset=UTF-8');
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 200;
        } catch (Exception e) {
            res.addHeader('Content-Type', 'application/json;charset=UTF-8');
            res.responseBody = Blob.valueOf(jsonResponse);
            res.statusCode = 400;
        }

    }

}