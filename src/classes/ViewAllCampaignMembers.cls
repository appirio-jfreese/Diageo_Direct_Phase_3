public class ViewAllCampaignMembers {
    public Campaign camp {get;set;}
    public List<CampaignMember> campMembers{get; private set;}
    
    public ViewAllCampaignMembers(ApexPages.StandardController stdController) {
        this.camp = (Campaign)stdController.getRecord();
        this.campMembers = [select Id, Status, Contact.title, Contact.FirstName, Contact.LastName,
                            Contact.Owner.Name,ContactId,
                            Contact.Phone, Contact.MobilePhone, Contact.Email,
                            Lead.Email, Lead.MobilePhone, Lead.Phone, Lead.Company, Lead.Title, 
                            Lead.FirstName, Lead.LastName, LeadId, Lead.Owner.Name 
                            from CampaignMember
                            where CampaignId=:camp.Id];
    }
}