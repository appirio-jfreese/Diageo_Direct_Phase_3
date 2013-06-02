public class Test_Service_ContentItem {

    public static testmethod void testServiceUpload(){
        
        Service_ContentItem sci = new Service_ContentItem();
        AggregateResultHolder ag = new AggregateResultHolder();
        sci.aggregated = ag;
        Boolean isIpad = sci.isIpadComponent;
        Boolean editable = sci.editable;     
        Datetime createdDate1 = sci.createdDate1;     
        Datetime lastLoginDateItem1 = sci.lastLoginDateItem1;     
        String cvid1 = sci.cvid1;     
        String cvidlow1 = sci.cvidlow1;     
        String imageRes1 = sci.imageRes1;     
        String fileType1 = sci.fileType1;     
        String fileSize1 = sci.fileSize1;     
        Boolean displayUploadDate1 = sci.displayUploadDate1;     
        Boolean showDownloadShare1 = sci.showDownloadShare1;     
        Boolean showListButtons1 = sci.showListButtons1;     
        Boolean isVideo1 = sci.isVideo1;     
        String videoId1 = sci.videoId1;     
        Boolean previewAvailable1 = sci.previewAvailable1;     
        String previewId1 = sci.previewId1;
        String width1 = sci.width1;
        String height1 = sci.height1;
        String margin1 = sci.margin1;
        Boolean renderAsList1 = sci.renderAsList1;
        String description2 = sci.description2;
        set<id> basketIds = sci.basketIds;     
        set<id> followIds = sci.followIds;     
        Boolean inBasket = sci.inBasket;
        Boolean inFollow = sci.inFollow;
        Date getcreatedDate2 = sci.getcreatedDate2();
        Boolean getisNew = sci.getisNew();
    }

}