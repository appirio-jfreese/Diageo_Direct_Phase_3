public with sharing class PerformanceController {
	
	public String userMode {get;set;}
	
	public Boolean showDueDate {get;set;}
	public Boolean showLevel {get;set;}
	public Boolean showGoalName {get;set;}
	public Boolean showGBrand {get;set;}
	public Boolean showIBrand {get;set;}
	public Boolean showGoalType {get;set;}
	public Boolean showGoalFor {get;set;}
	public Boolean showPriority {get;set;}
	public Boolean showRecType {get;set;}
	public Boolean showState {get;set;}
	public Boolean showGroupBy {get;set;}
	public Boolean showSortBy {get;set;}
	
	public Integer resultSize {get;set;}
	public Integer chartHeight {get;set;}
	
	public List<SelectOption> dateSelections {get;set;}
	public List<SelectOption> levelSelections {get;set;}
	public List<SelectOption> nameSelections {get;set;}
	public List<SelectOption> gBrandSelections {get;set;}
	public List<SelectOption> iBrandSelections {get;set;}
	public List<SelectOption> typeSelections {get;set;}
	public List<SelectOption> forSelections {get;set;}
	public List<SelectOption> priorSelections {get;set;}
	public List<SelectOption> rtSelections {get;set;}
	public List<SelectOption> stateSelections {get;set;}
	public List<SelectOption> groupBySelections {get;set;}
	public List<SelectOption> sortBySelections {get;set;}
	
	public String dateSel {get;set;}
	public String levelSel {get;set;}
	public String nameSel {get;set;}
	public String gBrandSel {get;set;}
	public String iBrandSel {get;set;}
	public String typeSel {get;set;}
	public String forSel {get;set;}
	public String forLabel {get;set;}
	public String priorSel {get;set;}
	public String rtSel {get;set;}
	public String stateSel {get;set;}
	public String groupBySel {get;set;}
	public String sortBySel {get;set;}
	
	public String chartTitle {get;set;}
	public String leftAxisLabel {get;set;}
	
	public List<Data> byStateData {get;set;}
	public List<Data> dataToUse {get;set;}
	
	public static Set<String> WEST_STATES = new Set<String>{
		'ID',
		'IA',
		'MI',
		'MT',
		'OH',
		'OR',
		'UT',
		'WY'
		};
	public static Set<String> EAST_STATES = new Set<String>{
		'AL',
		'ME',
		'MS',
		'NH',
		'NC',
		'PA',
		'VT',
		'VA',
		'WV'
		};
		
	public class Data {
		String name {get;set;}
		Decimal dispValue {get;set;}
		Decimal actualValue {get;set;}
		String fullName {get;set;}
		String tipValue {get;set;}
		
		public Data(String fullName, Decimal actualValue){
			this.fullName = fullName;
			if(fullName.length() > 40){
				this.name = fullName.substring(0, 40);
			} else {
				this.name = fullName;
			}
			this.actualValue = actualValue;
			this.dispValue = actualValue;
			if(this.dispValue > 100){
				this.dispValue = 100;
			}
			this.tipValue = String.valueOf(Math.floor(actualValue)) + '%';
		}
	}

	public PerformanceController(){
		determineUserMode();
		determineVisibility();
		populateDateDropdowns();
		dateChanged();
	}
	
	private void determineUserMode(){
		String profileName = [SELECT Id, Name FROM Profile WHERE Id = :UserInfo.getProfileId()].Name;
		if(profileName == 'System Administrator' || profileName == 'Control - SAM'){
			userMode = 'sam';
			return;
		}

		Id userId = UserInfo.getUserId();
		List<Territory__c> terrs = [
			SELECT Id,
				   SAM__c,
				   Director__c,
				   Manager__c,
				   OwnerId
			  FROM Territory__c
			 WHERE SAM__c = :userId
			 	OR Director__c = :userId
			 	OR Manager__c = :userId
			 	OR OwnerId = :userId
		];
		
		Boolean isSam = false;
		Boolean isDirector = false;
		Boolean isManager = false;
		
		for(Territory__c terr : terrs){
			if(isSam == false && terr.SAM__c == userId){
				isSam = true;
			}
			if(isDirector == false && terr.Director__c == userId){
				isDirector = true;
			}
			if(isManager == false && terr.Manager__c == userId){
				isManager = true;
			}
		}
		if(isSam && !isDirector && !isManager){
			userMode = 'sam';
		} else if(!isSam && isDirector && !isManager){
			userMode = 'dir';
		} else if(!isSam && !isDirector && isManager){
			userMode = 'mgr';
		} else if(!isSam && isDirector && isManager){
			userMode = 'dir';
			showLevel = true;
		} else {
			userMode = 'rep';
		}
	}
	
	private void determineVisibility(){
		if(showLevel != true){
			showLevel = false;
		}
		showDueDate = true;
		showGoalName = true;
		showGBrand = true;
		showIBrand = true;
		showGoalType = true;
		showPriority = true;
		showRecType = true;
		showState = true;
		showGroupBy = true;
		showSortBy = true;
		
		showGoalFor = true;
		if(userMode == 'sam'){
			forLabel = 'Director';
		} else if(userMode == 'dir'){
			forLabel = 'Manager';
		} else if(userMode == 'mgr'){
			forLabel = 'Rep';
		} else if(userMode == 'rep'){
			forLabel = 'Rep';
		}
	}
	
	private void populateDateDropdowns(){
		dateSelections = new List<SelectOption>();
		dateSelections.add(new SelectOption('last', 'Last Month'));
		dateSelections.add(new SelectOption('this', 'This Month'));
		dateSelections.add(new SelectOption('next', 'Next Month'));
		
		if(showLevel){
			levelSelections = new List<SelectOption>();
			levelSelections.add(new SelectOption('dir', 'Director'));
			levelSelections.add(new SelectOption('mgr', 'Manager'));
		}
		
		/*dateSelections = new List<SelectOption>();
		Date startD = Date.newInstance(2012, 10, 1);
		Date endD = Date.today().toStartOfMonth().addYears(2);
		Date tempStart = startD;
		
		dateSelections.add(new SelectOption('all', '--- All ---'));
		while(tempStart != endD){
			Date tempEnd = tempStart.addMonths(1).addDays(-1);
			String encode = encodeDateSelection(tempStart, tempEnd);
			dateSelections.add(new SelectOption(encode, monthString(tempStart)));
			tempStart = tempStart.addMonths(1);
		}*/
		
		setInitialValues();
	}
	
	private void setInitialValues(){
		dateSel = 'this';
		levelSel = 'dir';
		nameSel = 'all';
		gBrandSel = 'all';
		iBrandSel = 'all';
		typeSel = 'all';
		forSel = 'all';
		priorSel = 'all';
		rtSel = 'all';
		groupBySel = 'Brand';
		sortBySel = 'perc';
	}
	
	/*
	private String encodeDateSelection(Date startD, Date endD){
		String startS = DateTime.newInstance(startD.year(),startD.month(),startD.day()).format('yyyy-MM-dd');
		String endS = DateTime.newInstance(endD.year(),endD.month(),endD.day()).format('yyyy-MM-dd');
		return startS + '|' + endS;
	}
	
	private String monthString(Date d){
		if(d.month() == 1){
			return 'January ' + d.year();
		} else if(d.month() == 2){
			return 'February ' + d.year();
		} else if(d.month() == 3){
			return 'March ' + d.year();
		} else if(d.month() == 4){
			return 'April ' + d.year();
		} else if(d.month() == 5){
			return 'May ' + d.year();
		} else if(d.month() == 6){
			return 'June ' + d.year();
		} else if(d.month() == 7){
			return 'July ' + d.year();
		} else if(d.month() == 8){
			return 'August ' + d.year();
		} else if(d.month() == 9){
			return 'September ' + d.year();
		} else if(d.month() == 10){
			return 'October ' + d.year();
		} else if(d.month() == 11){
			return 'November ' + d.year();
		}
		return 'December ' + d.year();
	}
	*/
	
	private String encodeDate(Date d){
		String s = DateTime.newInstance(d.year(),d.month(),d.day()).format('yyyy-MM-dd');
		return s;
	}
	
	public void dateChanged(){
		refreshGoalDropdowns();
	}
	
	public void levelChanged(){
		userMode = levelSel;
		determineVisibility();
		refreshGoalDropdowns();
	}
	
	private void refreshGoalDropdowns(){
		String q = 'SELECT Id';
		q += ', Name';
		q += ', Long_Name__c';
		q += ', Goal_Type__c';
		q += ', Goal_For__c';
		q += ', Goal_For__r.Name';
		q += ', Priority__c';
		q += ', RecordTypeId';
		q += ', RecordType.Name';
		q += ', State__c';
		q += ', Minimum_of_Accounts__c';
		q += ', Action_Complete__c';
		
		q += ', (SELECT Id, Generic_Brand__c, Individual_Brand__c FROM Goal_Product_Links__r)';
		
		q += ' FROM Goal__c';
		q += ' WHERE Minimum_of_Accounts__c != null';
		q += ' AND Action_Complete__c != null';
		q += ' AND Name LIKE \'%-%\'';
		q += ' AND Goal_Type__c LIKE \'% - Control\'';
		q += ' AND Goal_For__c != null';
		q += ' AND State__c != null';
		q += ' AND Priority__c != null';
		
		if(dateSel == 'last'){
			String startString = encodeDate(Date.today().toStartOfMonth().addMonths(-1));
			String endString = encodeDate(Date.today().toStartOfMonth().addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		} else if(dateSel == 'this'){
			String startString = encodeDate(Date.today().toStartOfMonth());
			String endString = encodeDate(Date.today().toStartOfMonth().addMonths(1).addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		} else if(dateSel == 'next'){
			String startString = encodeDate(Date.today().toStartOfMonth().addMonths(1));
			String endString = encodeDate(Date.today().toStartOfMonth().addMonths(2).addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		}
		
		if(userMode == 'sam'){
			q += ' AND Goal_Level__c = \'Director\'';
		} else if(userMode == 'dir'){
			q += ' AND Goal_Level__c = \'Manager\'';
		} else if(userMode == 'mgr'){
			q += ' AND Goal_Level__c = \'Rep\'';
		} else if(userMode == 'rep'){
			q += ' AND Goal_Level__c = \'Rep\'';
		}
		
		//q+= ' LIMIT 1000';
		
		//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'DAVE TEST, PLEASE IGNORE: ' + q));
		
		Set<String> shortNames = new Set<String>();
		Set<String> gBrands = new Set<String>();
		Set<String> iBrands = new Set<String>();
		Set<String> goalTypes = new Set<String>();
		Set<String> forNames = new Set<String>();
		Set<String> priorTypes = new Set<String>();
		Set<String> rtNames = new Set<String>();
		Set<String> stateNames = new Set<String>();
		
		for(Goal__c goal : Database.query(q)){
			String shortName;
			if(goal.Long_Name__c == null){
				shortName = goal.Name.split(' - ')[0];
			} else {
				shortName = goal.Long_Name__c.split(' - ')[1];
			}
			shortNames.add(shortName);
			for(Goal_Product_Link__c gpl : goal.Goal_Product_Links__r){
				if(gpl.Generic_Brand__c != null){
					gBrands.add(gpl.Generic_Brand__c);
				}
				if(gpl.Individual_Brand__c != null){
					iBrands.add(gpl.Individual_Brand__c);
				}
			}
			goalTypes.add(goal.Goal_Type__c);
			forNames.add(goal.Goal_For__r.Name);
			priorTypes.add(goal.Priority__c);
			rtNames.add(goal.RecordType.Name);
			stateNames.add(goal.State__c);
		}
		
		nameSelections = new List<SelectOption>();
		nameSelections.add(new SelectOption('all', '--- All ---'));
		List<String> sortedKeys = new List<String>(shortNames);
		sortedKeys.sort();
		for(String name : sortedKeys){
			String truncName = name;
			if(name.length() > 50){
				truncName = name.substring(0, 50);
			}
			nameSelections.add(new SelectOption(truncName, truncName));
		}
		
		gBrandSelections = new List<SelectOption>();
		gBrandSelections.add(new SelectOption('all', '--- All ---'));
		sortedKeys = new List<String>(gBrands);
		sortedKeys.sort();
		for(String name : sortedKeys){
			gBrandSelections.add(new SelectOption(name, name));
		}
		
		iBrandSelections = new List<SelectOption>();
		iBrandSelections.add(new SelectOption('all', '--- All ---'));
		sortedKeys = new List<String>(iBrands);
		sortedKeys.sort();
		for(String name : sortedKeys){
			iBrandSelections.add(new SelectOption(name, name));
		}
		
		typeSelections = new List<SelectOption>();
		typeSelections.add(new SelectOption('all', '--- All ---'));
		List<String> sortedGoalTypes = new List<String>(goalTypes);
		sortedGoalTypes.sort();
		for(String typee : sortedGoalTypes){
			typeSelections.add(new SelectOption(typee, typee));
		}
		
		forSelections = new List<SelectOption>();
		forSelections.add(new SelectOption('all', '--- All ---'));
		sortedKeys = new List<String>(forNames);
		sortedKeys.sort();
		for(String name : sortedKeys){
			forSelections.add(new SelectOption(name, name));
		}
		
		priorSelections = new List<SelectOption>();
		priorSelections.add(new SelectOption('all', '--- All ---'));
		List<String> sortedPriorTypes = new List<String>(priorTypes);
		sortedPriorTypes.sort();
		for(String prior : sortedPriorTypes){
			priorSelections.add(new SelectOption(prior, prior));
		}
		
		rtSelections = new List<SelectOption>();
		rtSelections.add(new SelectOption('all', '--- All ---'));
		sortedKeys = new List<String>(rtNames);
		sortedKeys.sort();
		for(String name : sortedKeys){
			rtSelections.add(new SelectOption(name, name));
		}
		
		stateSelections = new List<SelectOption>();
		stateSelections.add(new SelectOption('all', '--- All ---'));
		if(userMode == 'sam'){
			stateSelections.add(new SelectOption('east', '--- All East ---'));
			stateSelections.add(new SelectOption('west', '--- All West ---'));
		}
		sortedKeys = new List<String>(stateNames);
		sortedKeys.sort();
		for(String name : sortedKeys){
			stateSelections.add(new SelectOption(name, name));
		}
		
		groupBySelections = new List<SelectOption>();
		groupBySelections.add(new SelectOption('Name', 'Name'));
		groupBySelections.add(new SelectOption('Brand', 'Brand'));
		groupBySelections.add(new SelectOption('Subdivision', 'Subdivision'));
		groupBySelections.add(new SelectOption('State__c', 'State'));
		groupBySelections.add(new SelectOption('Owner.Name', forLabel));
		
		sortBySelections = new List<SelectOption>();
		sortBySelections.add(new SelectOption('perc', 'Percentage'));
		sortBySelections.add(new SelectOption('name', 'Name'));
		
		//check to see if previous selections are still in the list
		if(shortNames.contains(nameSel) == false){
			nameSel = 'all';
		}
		if(gBrands.contains(gBrandSel) == false){
			gBrandSel = 'all';
		}
		if(iBrands.contains(iBrandSel) == false){
			iBrandSel = 'all';
		}
		if(goalTypes.contains(typeSel) == false){
			typeSel = 'all';
		}
		if(forNames.contains(forSel) == false){
			forSel = 'all';
		}
		if(priorTypes.contains(priorSel) == false){
			priorSel = 'all';
		}
		if(rtNames.contains(rtSel) == false){
			rtSel = 'all';
		}
		if(stateNames.contains(stateSel) == false){
			stateSel = 'all';
		}
		
		refreshCharts();
	}
	
	public void nameChanged(){
		refreshCharts();
	}
	
	public void gBrandChanged(){
		refreshCharts();
	}
	
	public void iBrandChanged(){
		refreshCharts();
	}
	
	public void typeChanged(){
		refreshCharts();
	}
	
	public void forChanged(){
		refreshCharts();
	}
	
	public void priorChanged(){
		refreshCharts();
	}
	
	public void rtChanged(){
		refreshCharts();
	}
	
	public void stateChanged(){
		refreshCharts();
	}
	
	public void groupByChanged(){
		refreshCharts();
	}
	
	public void sortByChanged(){
		refreshCharts();
	}
	
	public void refreshCharts(){
		dataToUse = new List<Data>();
		resultSize = 0;
		
		Map<String, Decimal> minsByGroupName = new Map<String, Decimal>();
		Map<String, Decimal> compsByGroupName = new Map<String, Decimal>();
		
		//SELECT Name, SUM(Minimum_of_Accounts__c) goalCount, SUM(Action_Complete__c) actCount FROM Goal__c WHERE Name LIKE '%-%' GROUP BY Name
		
		String q = 'SELECT COUNT(Id) numCount';
		if(groupBySel == 'Brand'){
			q += ', Name groupBy';
		} else if(groupBySel == 'Subdivision'){
			q += ', State__c groupBy';
		} else {
			q += ', ' + groupBySel + ' groupBy';
		}
		q += ', SUM(Minimum_of_Accounts__c) goalCount';
		q += ', SUM(Action_Complete__c) actCount';
		
		q += ' FROM Goal__c';
		q += ' WHERE Minimum_of_Accounts__c != null';
		q += ' AND Action_Complete__c != null';
		q += ' AND Name LIKE \'%-%\'';
		q += ' AND Goal_Type__c LIKE \'% - Control\'';
		q += ' AND Goal_For__c != null';
		q += ' AND State__c != null';
		q += ' AND Priority__c != null';
		
		if(dateSel == 'last'){
			String startString = encodeDate(Date.today().toStartOfMonth().addMonths(-1));
			String endString = encodeDate(Date.today().toStartOfMonth().addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		} else if(dateSel == 'this'){
			String startString = encodeDate(Date.today().toStartOfMonth());
			String endString = encodeDate(Date.today().toStartOfMonth().addMonths(1).addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		} else if(dateSel == 'next'){
			String startString = encodeDate(Date.today().toStartOfMonth().addMonths(1));
			String endString = encodeDate(Date.today().toStartOfMonth().addMonths(2).addDays(-1));
			q += ' AND Due_Date__c >= ' + startString;
			q += ' AND Due_Date__c <= ' + endString;
		}
		
		if(userMode == 'sam'){
			q += ' AND Goal_Level__c = \'Director\'';
		} else if(userMode == 'dir'){
			q += ' AND Goal_Level__c = \'Manager\'';
		} else if(userMode == 'mgr'){
			q += ' AND Goal_Level__c = \'Rep\'';
		} else if(userMode == 'rep'){
			q += ' AND Goal_Level__c = \'Rep\'';
		}
		
		if(typeSel != 'all'){
			q += ' AND Goal_Type__c = \'' + typeSel + '\''; 
		}
		if(forSel != 'all'){
			q += ' AND Goal_For__r.Name = \'' + forSel + '\''; 
		}
		if(priorSel != 'all'){
			q += ' AND Priority__c = \'' + priorSel + '\''; 
		}
		if(rtSel != 'all'){
			q += ' AND RecordType.Name = \'' + rtSel + '\''; 
		}
		if(stateSel == 'east'){
			q += ' AND State__c IN :EAST_STATES';
		} else if(stateSel == 'west'){
			q += ' AND State__c IN :WEST_STATES';	
		} else if(stateSel != 'all'){
			q += ' AND State__c = \'' + stateSel + '\''; 
		}
		if(nameSel != 'all'){
			if(nameSel.length() == 50){
				q += ' AND Name LIKE \'%' + nameSel + '%\'';
			} else {
				q += ' AND Name LIKE \'%' + nameSel + ' - %\'';
			}
		}
		if(gBrandSel != 'all' || iBrandSel != 'all'){
			q += ' AND Product_Link_Count__c > 0';
			q += ' AND Name LIKE \'%' + gBrandSel.replace('\'', '\\\'') + '%\'';
		}
		
		if(groupBySel == 'Brand'){
			q += ' GROUP BY Name';
		} else if(groupBySel == 'Subdivision'){
			q += ' GROUP By State__c';
		} else {
			q += ' GROUP BY ' + groupBySel;
		}
		
		//ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.INFO, 'quick dave test, please ignore: ' + q));
		
		for(AggregateResult agr : Database.query(q)){
			String groupName = String.valueOf(agr.get('groupBy'));
			resultSize += Integer.valueOf(agr.get('numCount'));
			Integer goalCount = Integer.valueOf(agr.get('goalCount'));
			Integer actCount = Integer.valueOf(agr.get('actCount'));
			
			if(groupBySel == 'Brand'){
				Set<String> matchingBrandNames = new Set<String>();
				for(SelectOption gBrandOpt : gBrandSelections){
					if(groupName.contains(gBrandOpt.getValue())){
						matchingBrandNames.add(gBrandOpt.getValue());
					}
				}
				if(matchingBrandNames.size() == 0){
					resultSize -= Integer.valueOf(agr.get('numCount'));
				} else {
					for(String bName : matchingBrandNames){
						groupName = bName;
						Decimal existingMin = minsByGroupName.get(groupName);
						Decimal existingComp;
						if(existingMin == null){
							existingMin = 0;
							existingComp = 0;
						} else {
							existingComp = compsByGroupName.get(groupName);
						}
						existingMin += goalCount;
						existingComp += actCount;
						minsByGroupName.put(groupName, existingMin);
						compsByGroupName.put(groupName, existingComp);
					}
				}
			} else {
				if(groupBySel == 'Name'){
					String shortName;
					String[] splitName = groupName.split(' - ');
					if(splitName.size() <= 1){
						shortName = splitName[0];
					} else if(splitName[1].contains('Premise')){
						shortName = splitName[0];
					} else {
						shortName = splitName[1];
					}
					groupName = shortName;
				} else if(groupBySel == 'Subdivision'){
					if(WEST_STATES.contains(groupName)){
						groupName = 'West';
					} else if(EAST_STATES.contains(groupName)){
						groupName = 'East';
					} else {
						groupName = 'Other';
					}
				}
	
				Decimal existingMin = minsByGroupName.get(groupName);
				Decimal existingComp;
				if(existingMin == null){
					existingMin = 0;
					existingComp = 0;
				} else {
					existingComp = compsByGroupName.get(groupName);
				}
				existingMin += goalCount;
				existingComp += actCount;
				minsByGroupName.put(groupName, existingMin);
				compsByGroupName.put(groupName, existingComp);
			}
		}
		
		Map<String, Decimal> percsByName = new Map<String, Decimal>();
		Map<Decimal, String> namesByPerc = new Map<Decimal, String>();
		for(String groupName : minsByGroupName.keySet()){
			Decimal min = minsByGroupName.get(groupName);
			Decimal comp = compsByGroupName.get(groupName);
			Decimal perc = 0;
			if(min != 0){
				perc = Math.floor(comp / min * 100);
			}
			percsByName.put(groupName, perc);
			while(namesByPerc.get(perc) != null){
				perc += 0.00001;
			}
			namesByPerc.put(perc, groupName);
		}
		if(sortBySel == 'perc'){
			List<Decimal> allPercs = new List<Decimal>(namesByPerc.keySet());
			allPercs.sort();
			for(Decimal perc : allPercs){
				String groupName = namesByPerc.get(perc);
				dataToUse.add(new Data(groupName, perc));
			}
		} else if(sortBySel == 'name'){
			List<String> allNames = new List<String>(percsByName.keySet());
			allNames.sort();
			for(Integer i = allNames.size() - 1; i >= 0; i--){
				String name = allNames[i];
				Decimal groupPerc = percsByName.get(name);
				dataToUse.add(new Data(name, groupPerc));
			}
		}
		
		if(groupBySel == 'State__c'){
			chartTitle = 'By State';
			leftAxisLabel = 'State';
		} else if(groupBySel == 'Name'){
			chartTitle = 'By Name';
			leftAxisLabel = 'Name';
		} else if(groupBySel == 'Owner.Name'){
			chartTitle = 'By ' + forLabel;
			leftAxisLabel = forLabel;
		}
		
		if(dataToUse != null){
			chartHeight = dataToUse.size() * 15 + 120;
		}
	}
}