/**
 * Created by igordeychik on 5/18/2021.
 */

@IsTest
private class TestOpportunityManager {
    @IsTest
    static void testPutCalloutInsert() {
        RestRequest request = new RestRequest();
        request.requestURI =
                'https://cunning-badger-n3c04l-dev-ed.lightning.force.com//services/apexrest/Opportunity/';

        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ ' +
                '   \"opportunities\":[ ' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 1\",' +
                '         \"opportunityName\":\"order 1\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":1094.56,' +
                '         \"probability\":5,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"1\"' +
                '      },' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 1\",' +
                '         \"opportunityName\":\"order 2\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":2000.00,' +
                '         \"probability\":10,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"2\"' +
                '      } ]' +
                '}');
        RestContext.request = request;
        RestContext.response = new RestResponse();
        OpportunityManager.upsertOpportunity();

        System.assertEquals(2, [SELECT Id FROM Opportunity WHERE External_Id__c != NULL].size());
    }
    @IsTest
    static void testPutCalloutUpdate() {
        RestRequest request = new RestRequest();
        request.requestURI =
                'https://cunning-badger-n3c04l-dev-ed.lightning.force.com//services/apexrest/Opportunity/';

        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ ' +
                '   \"opportunities\":[ ' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 1\",' +
                '         \"opportunityName\":\"order 1\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":1094.56,' +
                '         \"probability\":5,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"1\"' +
                '      },' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 1\",' +
                '         \"opportunityName\":\"order 2\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":2000.00,' +
                '         \"probability\":10,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"2\"' +
                '      },' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 2\",' +
                '         \"opportunityName\":\"order 3\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":123.00,' +
                '         \"probability\":2,' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"3\"' +
                '      }' +
                '   ]' +
                '}');
        RestContext.request = request;
        RestContext.response = new RestResponse();
        OpportunityManager.upsertOpportunity();
        List<Opportunity>ops = [SELECT Amount,Account.Name FROM Opportunity WHERE External_Id__c != NULL];
        System.assertEquals(2, ops.size());
        request = new RestRequest();
        request.requestURI =
                'https://cunning-badger-n3c04l-dev-ed.lightning.force.com//services/apexrest/Opportunity/';

        request.httpMethod = 'PUT';
        request.addHeader('Content-Type', 'application/json');
        request.requestBody = Blob.valueOf('{ ' +
                '   \"opportunities\":[ ' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 2\",' +
                '         \"opportunityName\":\"order 1\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":10.00,' +
                '         \"probability\":5,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"1\"' +
                '      },' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 2\",' +
                '         \"opportunityName\":\"order 2\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":10.00,' +
                '         \"probability\":10,' +
                '         \"closeDate\":\"2019-11-12\",' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"2\"' +
                '      },' +
                '      { ' +
                '         \"accountName\":\"Test Account Name 2\",' +
                '         \"opportunityName\":\"order 3\",' +
                '         \"stage\":\"Prospecting\",' +
                '         \"amount\":123.00,' +
                '         \"probability\":2,' +
                '         \"type\":\"New Business\",' +
                '         \"_sid\":\"3\"' +
                '      }' +
                '   ]' +
                '}');
        RestContext.request = request;
        RestContext.response = new RestResponse();
        OpportunityManager.upsertOpportunity();
        ops = [SELECT Amount,Account.Name FROM Opportunity WHERE External_Id__c != NULL];
        System.assertEquals(2, ops.size());
        System.assertEquals(ops[0].Account.Name, 'Test Account Name 2');
        System.assertEquals(ops[1].Account.Name, 'Test Account Name 2');
        System.assertEquals(ops[1].Amount, 10.00);

    }
    @IsTest
    static void testDeleteCallout() {
        insert new Opportunity(StageName = 'Prospecting', CloseDate = Date.today(), Name = 'test', External_Id__c = '1');
        System.assertEquals(1, [SELECT Id FROM Opportunity].size());
        RestRequest request = new RestRequest();
        request.requestURI =
                'https://cunning-badger-n3c04l-dev-ed.lightning.force.com//services/apexrest/Opportunity/1';

        request.httpMethod = 'DELETE';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = new RestResponse();
        OpportunityManager.deleteOpportunity();
        System.assertEquals(0, [SELECT Id FROM Opportunity].size());
    }
    @IsTest
    static void testGetCallout() {
        insert new Opportunity(StageName = 'Prospecting', CloseDate = Date.today(), Name = 'test', External_Id__c = '1');
        insert new Opportunity(StageName = 'Prospecting', CloseDate = Date.today(), Name = 'test', External_Id__c = '2');

        RestRequest request = new RestRequest();
        request.requestURI =
                'https://cunning-badger-n3c04l-dev-ed.lightning.force.com//services/apexrest/Opportunity/1';

        request.httpMethod = 'GET';
        request.addHeader('Content-Type', 'application/json');
        RestContext.request = request;
        RestContext.response = new RestResponse();
        System.assertEquals(2, OpportunityManager.getOpportunities().size());
    }
}