public with sharing class TestPopup {

    public Boolean displayPopup {get;set;}

  
    public void showPopup()
    {
        
    displayPopup = true;

    
    }
    
    public void closePopup() {
        displayPopup = false;
        
    }
    
//    public PageReference redirectPopup()
  //  {
    //displayPopup = false;
      //  //Please uncomment below 3 statements and replace YourObjectId
      //  PageReference p=new Pagereference('/lightning/r/Appointment__c/a025g000003JzxnAAC/view');
        // p.setRedirect(true);
         //return p;
        
    //}
    


}