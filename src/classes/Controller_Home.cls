public with sharing class Controller_Home extends Controller_Base {

	// video
    public String videoId{get; private set;}
    public String videoDesc{get; private set;}
    public String showPlayer{get; private set;}

    public Id contentBrand{get; set;}

	// articles
	public list<NewsAndArticles__c> articles {get; set;}
    public String articleUrl {get; set; }
    
    public Boolean innovationSectionName {
 		get{
 			return (siteTheme == 'Spirits');
		}
		private set;
	}
    	    
    public Controller_Home() {
		pageUrl = Page.HomePage.getUrl();
        
        //articles
        articles = Service_API.getNewsAndArticles();
				articleUrl = Page.NewsAndArticles.getUrl();
		
        HomeVideo__c[] videos = [Select videoId__c, description__c FROM HomeVideo__c WHERE current__c=true and Classification__c = :Service_API.getSectionTheme()];
        if (videos.size() == 1) {
            videoId      = videos[0].videoId__c;
            videoDesc    = videos[0].description__c;
            showPlayer   = 'block';
        } else {
            showPlayer = 'none';            
        }
    }
}