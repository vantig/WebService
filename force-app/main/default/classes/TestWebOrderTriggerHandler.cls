@IsTest
private class TestWebOrderTriggerHandler {
  @TestSetup
  static void setup() {
    TestDataFactory.createOpportunitiesTestRecords(1);
    TestDataFactory.createWebOrdersTestRecords(1);
  }
  @IsTest
  static void testCreateWebOrdersWithRelated() {
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.assertEquals(2, countOfOpportunities, 'Insert  Opportunities Failed');
    System.assertEquals(2, countOfWebOrders, 'Insert  WebOrders Failed');
  }
  @IsTest
  static void testUpdateWebOrderWithRelated() {
    List<Web_Order__c> webOrders = [SELECT Name FROM Web_Order__c];
    webOrders[0].Name = 'updated';
    update webOrders[0];
    Integer countOfOpportunities = [
      SELECT Name
      FROM Opportunity
      WHERE Name = 'updated'
    ].size();
    Integer countOfWebOrders = [
      SELECT Name
      FROM Web_Order__c
      WHERE Name = 'updated'
    ].size();
    System.assertEquals(1, countOfOpportunities, 'Update  Opportunities Failed');
    System.assertEquals(1, countOfWebOrders, 'Update  WebOrders Failed');
  }
  @IsTest
  static void testDeleteWebOrderWithRelated() {
    List<Web_Order__c> webOrders = [SELECT Id FROM Web_Order__c];
    delete webOrders[0];
    Integer countOfOpportunities = [SELECT Id FROM Opportunity].size();
    Integer countOfWebOrders = [SELECT Id FROM Web_Order__c].size();
    System.assertEquals(1, countOfOpportunities, 'Delete  Opportunities Failed');
    System.assertEquals(1, countOfWebOrders, 'Delete  WebOrders Failed');
  }
}