/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

function updateFranchise() {
	AJAXcall({action:"getFranchise"}, function(){});
}

function receiveFranchiseData(data) {
	var json = atob(data);
	json = $.parseJSON(json);
	
	$('#franchiseName').html(json['name']);
	$('#franchiseKasse').html(json['kasse'].toLocaleString('de-DE')+" $");
	$('#franchiseIncome').html(json['incomeToday'].toLocaleString('de-DE')+" $");
	$('#franchiseCustomers').html(json['customersToday']);
	$('#franchiseSales').html(json['salesToday']);
	$('#franchiseBottom').html('');
	
	var opt1 = {
			"type":"line",
			"data":{
				"labels":[
					
				],
				"datasets":[
					{
						"label":"Kunden",
						"data":[
							
						],
						"fill":false,
						"borderColor":"rgb(255, 0, 0)",
						"lineTension":0.1
					},
					{
						"label":"Verkäufe",
						"data":[
							
						],
						"fill":false,
						"borderColor":"rgb(0, 0, 255)",
						"lineTension":0.1
					},
				]
			},
			"options":{
				
			}
	};
	
	var opt2 = {
			"type":"line",
			"data":{
				"labels":[
					
				],
				"datasets":[
					{
						"label":"Einnahmen",
						"data":[
							
						],
						"fill":false,
						"borderColor":"rgb(75, 192, 192)",
						"lineTension":0.1
					},
				]
			},
			"options":{
				
			}
	};
	

	
	if (json['isCompany'] == true) {
		
		$('#franchiseBottom').append('<div class="list accordion-list"><ul id="franAcco"></ul></div>');
		
		var shops = sortObjKeysAscending(json['shops']);
		$.each(shops, function(i, arr) {
			
			$('#franAcco').append('<li class="accordion-item accordion-item-opened"><a href="#" class="item-link item-content"><div class="item-inner"><div class="item-title">Shop #'+arr['sID']+' ('+arr['location']+')</div></div></a><div class="accordion-item-content" style=""><div class="block"><canvas id="franVisitsSales-'+i+'"></canvas><br><canvas id="franIncomes-'+i+'"></canvas></div></div></li>');
			
			var xopt1 = $.extend(true, {}, opt1);
			var xopt2 = $.extend(true, {}, opt2);
			
			var data = sortObjKeysAscending(json['shops'][i]['franchise']['data']);
			$.each(data, function(tm, dat) {
				var date = new Date(tm*1000);
				
				xopt1["data"]["labels"].push(date.getDate()+"."+(date.getMonth()+1));
				xopt2["data"]["labels"].push(date.getDate()+"."+(date.getMonth()+1));
				
				xopt1["data"]["datasets"][0]["data"].push(dat[0]);
				xopt1["data"]["datasets"][1]["data"].push(dat[1]);
				xopt2["data"]["datasets"][0]["data"].push(dat[2]);
			});			
			
			new Chart(document.getElementById("franVisitsSales-"+i), xopt1);
			new Chart(document.getElementById("franIncomes-"+i), xopt2);
		});
				
		
	} else {
		
		var data = sortObjKeysAscending(json['data']);
		
		var xopt1 = Object.assign({}, opt1);
		var xopt2 = Object.assign({}, opt2);
		
		$.each(data, function(i, arr) {
			var date = new Date(i*1000);
			xopt1["data"]["labels"].push(date.getDate()+"."+(date.getMonth()+1));
			xopt2["data"]["labels"].push(date.getDate()+"."+(date.getMonth()+1));
			
			xopt1["data"]["datasets"][0]["data"].push(arr[0]);
			xopt1["data"]["datasets"][1]["data"].push(arr[1]);
			xopt2["data"]["datasets"][0]["data"].push(arr[2]);
		});
		
		$('#franchiseBottom').html('<canvas id="franVisitsSales"></canvas><br><canvas id="franIncomes"></canvas>');
		
		new Chart(document.getElementById("franVisitsSales"), xopt1);
		new Chart(document.getElementById("franIncomes"), xopt2);
	}
}

function franchisePayInOut(what) {
	var val = $('#franchiseAmount').val();
	if (val > 0) {
		AJAXcall({action:"inOutFranchise",act:what,amount:val}, function(){});
		setTimeout(updateFranchise, 100);
	} else {
		myApp.alert('Gib eine gültige Summe an.', 'Franchise');
	}
}