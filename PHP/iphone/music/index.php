<?php
/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

if (isset($_GET['defRadios'])) {
	setcookie('defRadios', $_GET['defRadios'], (time()+((60*60)*24)));
	header("Location: index.php?apiAuth=".$_GET['apiAuth']."&apiUser=".$_GET['apiUser']);
	exit();
}
?>
<!DOCTYPE HTML>
<html>

	<head>
		<meta charset	="utf-8" />
		<meta http-equiv="Content-Type"	content="text/html; charset=utf-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, minimum-scale=1, user-scalable=no, minimal-ui">
		
		<link rel="stylesheet" href="css/framework7.ios.css?<?=@date("Y-m-d_H:i:s", @filemtime('css/framework7.ios.css'))?>" />
		<link rel="stylesheet" href="css/iphone.css?<?=@date("Y-m-d_H:i:s", @filemtime('css/iphone.css'))?>" />
		<link rel="stylesheet" href="css/font-awesome.css?<?=@date("Y-m-d_H:i:s", @filemtime('css/font-awesome.css'))?>" />
		<link rel="stylesheet" href="css/font-awesome-animation.min.css?<?=@date("Y-m-d_H:i:s", @filemtime('css/font-awesome-animation.min.css'))?>" />
		
		<script src="js/jquery-3.0.0.min.js?<?=@date("Y-m-d_H:i:s", @filemtime('js/jquery-3.0.0.min.js'))?>" type="text/javascript"></script>
		<script src="js/framework7.min.js?<?=@date("Y-m-d_H:i:s", @filemtime('js/framework7.min.js'))?>" type="text/javascript"></script>
		<script src="js/music.js?<?=@date("Y-m-d_H:i:s", @filemtime('js/music.js'))?>" type="text/javascript"></script>
		<style>.hidescroll { overflow-y: auto !important; }</style>
	</head>
	<body>
		<div id="homeScreen" style="background-color:transparent !important;">
			
			
			
			<!-- APPS -->
			<div class="app" id="musicApp" style="display:block;background: transparent !important;">
				<div class="appContent">
					
					<div class="musicInner">
						<div class="musicInnerPlay" style="display:none;">
							
							<style id="durationColorFix"></style>
							
							<span id="musicPlayerCover" style="position:absolute;width:233px;height:206px;top:33px;left:24px;border-radius:5px;background:url(images/ui/cover.png) no-repeat center center;background-size:100% auto !important;">
								Hier kommt der Lyric Text rein!
							
							</span>
							
							<span id="musicPlayerDurCur" style="position:absolute;width:40px;height:15px;top:260px;left:24px;color:grey;font-size:13px;">0:00</span>
							
							<span id="musicDurSlideCont" class="list-block range-slider-small" style="position:absolute;width:230px;top:242px;left:24px;">
								<input id="musicDurSlide" style="width:100%;" type="range" min="0" max="0" value="0" step="1"/>
							</span>
							
							<span id="musicPlayerDur" style="position:absolute;width:40px;height:15px;top:260px;left:216px;color:grey;font-size:13px;text-align:right;">0:00</span>
							
							<span id="musicPlayerTitle" class="" style="position:absolute;width:233px;height:20px;top:280px;left:24px;color:black;font-size:16px;font-weight:bold;text-align:center;">TITEL</span>
							
							<span id="musicPlayerInterpret" style="position:absolute;width:233px;height:20px;top:300px;left:24px;color:#ff2d55;font-size:14px;text-align:center;">ARTIST</span>
							
							<span id="musicPlayerRewindBack" style="position:absolute;width:30px;height:30px;top:328px;left:53px;" onclick="musicBackForwd('backwards');"></span>
							
							<span id="musicPlayerPlayPause" style="position:absolute;width:30px;height:30px;top:328px;left:128px;background-size:30px 30px !important;background:url(images/ui/playBtn.png) no-repeat;" onclick="musicPlayerClick('playpause');"></span>
							
							<span id="musicPlayerRewindForwards" style="position:absolute;width:30px;height:30px;top:328px;left:198px;" onclick="musicBackForwd('forwards');"></span>
							
							<span class="list-block range-slider" style="position:absolute;width:64%;top:366px;left:45px;">
								<input id="musicVolumeSlide" type="range" min="0" max="100" value="75" step="1"/>
							</span>
							
							
							<script>
							actionSheetButtons = [
								[{
									text: 'Bitte wähle das Ausgabegerät',
									label: true
								},
								{
									text: 'iPhone',
									onClick: function() {
										myApp.alert('iPhone', 'TODO');
									}
								},
								{
									text: 'Ghettoblaster',
									onClick: function() {
										myApp.alert('Ghettoblaster', 'TODO');
									}
								},
								{
									text: 'Musikbox',
									onClick: function() {
										myApp.alert('Musikbox', 'TODO');
									}
								},
								],
								[{
									text: 'Abbrechen',
									bold: true
								}]
							];
							</script>
							
							<a href="#" onclick="myApp.actions(actionSheetButtons);" style="position:absolute;width:25px;height:25px;top:405px;left:91px;color:#ff2d55;" class="">
								<i class="fa fa-podcast faa-pulse animated-hover" style="font-size:18px;margin-left:5px;margin-top:4px;"></i>
							</a>
							
							<a id="playerLikeBtn" href="#" onclick="" style="position:absolute;width:25px;height:25px;top:405px;left:165px;color:#ff2d55;" class="">
								<i id="playerLikeIcon" class="fa fa-heart-o faa-pulse animated-hover" style="font-size:18px;margin-left:5px;margin-top:4px;"></i>
							</a>
						</span>
							
						</div>
						
						
						
						<div class="musicInnerRadio hidescroll" style="display:none;">
							<span style="position:absolute;width:100%;top:12px;color:black;font-size:18px;font-weight:bold;text-align:center;">Radio</span>
							
							<span style="position:absolute;width:100%;top:12px;text-align:right;"><a href="#" title="Tooltip title" onclick="musicTabClick('addRadio');">Bearbeiten</a></span>
							
							
							<span style="position:absolute;width:100%;top:50px;color:black;height:355px;padding-left:8px;" class="musicContentScroll hidescroll" id="radioContentScroll">
								<!--
								<span class="mRadioBtn" style="background:url(images/radio/einslive.png) no-repeat center center; background-size:100% auto !important;" onclick="musicStartNew('http://1live.akacast.akamaistream.net/7/706/119434/v1/gnl.akacast.akamaistream.net/1live', '1Live', 'Subtitle...', 'images/radio/einslive.png', true);"></span>
								-->
							</span>
							
							<span style="position:absolute;width:100%;top:50px;color:black;height:355px;display:none;" id="radioChannelAdd" class="musicContentScroll hidescroll">
								<div class="content-block-title">Radiosender hinzufügen</div>
								<div class="list-block">
									<ul>
										<li>
											<div class="item-content">
												<div class="item-media"><i class="icon icon-form-name"></i></div>
												<div class="item-inner">
													<div class="item-title label" style="color:black;">Name</div>
													<div class="item-input">
														<input type="text" id="radioAddName" placeholder="Sendername" onclick="firstGuideHelp('Tippe den korrekten Namen des Radiosenders ein, das System fügt dann ein passendes Senderlogo hinzu.');"/>
													</div>
												</div>
											</div>
										</li>
										<li>
											<div class="item-content">
												<div class="item-media"><i class="icon icon-form-name"></i></div>
												<div class="item-inner">
													<div class="item-title label" style="color:black;">Stream-URL</div>
													<div class="item-input">
														<input type="text" id="radioAddURL" placeholder="https://example.com/stream.mp3"/>
													</div>
												</div>
											</div>
										</li>
									</ul>
									<br>
									<center><a href="#" onclick="addRadioChannel();" class="button button-big active" style="width:80%;">Hinzufügen</a></center>
								</div>
								
								
								<div class="content-block-title">Radiosender entfernen</div>
								<div class="list-block">
									<ul id="radioDelList">
										<!--<li>
											<div class="item-content">
												<div class="item-media"><i class="icon icon-form-name"></i></div>
												<div class="item-inner">
													<span style="float:left;width:60%;">Sendername</span>
													<span style="width:40%;">
														<div class="swipeout-actions-right swipeout-actions-opened"><a href="#" onclick="" class="swipeout-delete" style="transform: translate3d(-109px, 0px, 0px);">Löschen</a></div>
													</span>
												</div>
											</div>
										</li>-->
									</ul>
								</div>
							</span>
						</div>
						
						<div class="musicInnerSearch">
							<form onsubmit="searchMusic();return false;">
								<input id="musicSearchText" style="position:absolute;width:175px;top:15px;left:38px;border:0px;background-color:transparent;" type="text" placeholder="Britney Spears - Oops!... I Did It Again" onclick="firstGuideHelp('Tippe hier den Interpreten und Titel ein bsp. „Coldplay Clocks“, wenn Du nur Interpret oder Titel eingibst, wird dein gesuchtes Lied möglicherweise nicht gefunden.');" />
								<input type="submit" style="display:none;" />
							</form>
							
							<span style="position:absolute;width:45px;height:20px;top:12px;left:230px;" onclick="searchMusic();return false;"></span>
							
							<span class="list-block musicContentScroll hidescroll" style="position:absolute;width:100%;top:50px;color:black;height:355px;">
								<ul id="musicContentScrollInner">
									
									
								</ul>
							</span>
						</div>
						
						<div class="musicInnerCharts" style="display:none;">
							<span style="position:absolute;width:100%;top:12px;color:black;font-size:18px;font-weight:bold;text-align:center;">TOP 100 Single-Charts</span>
							
							<span class="list-block musicContentScroll hidescroll" style="position:absolute;width:100%;top:50px;color:black;height:355px;">
								<ul id="chartsContentScrollInner"></ul>
							</span>
						</div>
						
						<div class="musicInnerLikes" style="display:none;">
							<span style="position:absolute;width:100%;top:12px;color:black;font-size:18px;font-weight:bold;text-align:center;">Likes</span>
							
							<span class="list-block search-here searchbar-found musicContentScroll hidescroll" style="position:absolute;width:100%;top:50px;color:black;height:355px;">
								<ul id="likesContentScrollInner"></ul>
							</span>
						</div>
						
						
						<div class="musicMp3Inner" style="display:none;">
							<span style="position:absolute;width:100%;top:12px;color:black;font-size:18px;font-weight:bold;text-align:center;">MP3</span>
							
							<span style="position:absolute;width:100%;top:50px;color:black;height:355px;" id="musicMp3Scroll" class="musicContentScroll hidescroll">
								<div class="content-block-title">Stream-URL</div>
								<div class="content-block">
									<div class="content-block-inner">
										<p class="">Füge im folgenden Feld einen Link einer Streaming-Seite<sup>1</sup> oder zu einer Audiodatei<sup>2</sup> ein.</p>
									</div>
								</div>
								<div class="list-block">
									<ul>
										<li>
											<div class="item-content">
												<div class="item-inner">
													<div class="item-input">
														<input type="text" id="musicMp3URL" placeholder="https://example.com/music.mp3"/>
													</div>
												</div>
											</div>
										</li>
									</ul>
									<br>
									<center><a href="#" onclick="playCustomMp3();" class="button button-big active" style="width:80%;">Abspielen</a></center>
									<br>
									<small><sup>1</sup> Unterstützte Seiten: Dailymotion, Soundcloud, Vevo, Vimeo, YouTube</small><br>
									<small><sup>2</sup> Unterstützte Formate: .mp3, .ogg und .opus</small>
								</div>
							</span>
						</div>
						
						
						
					</div>
					
					<div class="musicWhatsNowPlaying" style="display:none;" onclick="musicTabClick('player');">
						<span class="" style="position:absolute;text-align:center;top:7px;height:20px;width:230px;" id="musicPlayNowTitle"></span>
						
						<span class="musicWhatsNowPlayingBtn" id="musicPlayNowBtn" style="position:absolute;text-align:center;left:241px;top:9px;height:20px;width:20px; background-size:20px 20px !important;background:url(images/ui/playBtn.png) no-repeat;" onclick="musicPlayerClick('playpause');"></span>
					</div>
					
					<div id="musicTabs">
						<span id="tabRadio" style="position:absolute;width:40px;height:40px;top:1px;left:20px;color:#949494;font-size:11px;" onclick="musicTabClick('radio');">
							<i class="fa fa-headphones" style="font-size:24px;margin-left:8px;margin-top:3px;"></i>
							<center>Radio</center>
						</span>
						
						<span id="tabMP3" style="position:absolute;width:40px;height:40px;top:1px;left:70px;color:#949494;font-size:11px;" onclick="musicTabClick('mp3');">
							<i class="fa fa-file-audio-o" style="font-size:24px;margin-left:8px;margin-top:3px;"></i>
							<center>MP3</center>
						</span>
						
						<span id="tabCharts" style="position:absolute;width:40px;height:40px;top:1px;left:120px;color:#949494;font-size:11px;" onclick="musicTabClick('charts');">
							<i class="fa fa-line-chart" style="font-size:24px;margin-left:8px;margin-top:3px;"></i>
							<center>Charts</center>
						</span>
						
						<span id="tabLiked" style="position:absolute;width:40px;height:40px;top:1px;left:170px;color:#949494;font-size:11px;" onclick="musicTabClick('liked');">
							<i class="fa fa-heart-o" style="font-size:24px;margin-left:8px;margin-top:3px;"></i>
							<center>Liked</center>
						</span>
						
						<span id="tabSearch" style="position:absolute;width:40px;height:40px;top:1px;left:220px;color:#949494;font-size:11px;" onclick="musicTabClick('search');" class="mTabActive">
							<i class="fa fa-search" style="font-size:24px;margin-left:8px;margin-top:3px;"></i>
							<center>Suche</center>
						</span>
					</div>
				</div>
			</div>
			
			
		</div>
		
		
		<iframe id="communicationFrame" src="about:blank" style="width:0px;height:0px;display:none;"></iframe>
		
<script>
USERNAME = '<?=@$_GET['apiUser']?>';
AUTH = '<?=@$_GET['apiAuth']?>';

IPHONE_OPEN			= true;
SETTINGS					= {};
CUR_VOLUME			= 80;
CUR_APP					= 'music';
DEFAULT_RADIOS		= <?=@$_COOKIE['defRadios']?>;

myApp						= false; // Framework7


var helpShown = new Array();
function firstGuideHelp(text) {
	if (Number(SETTINGS['firstGuide']) == 1) {
		if (!helpShown[text]) {
			myApp.alert(text+"<br><br><small>Du kannst diese Einführungshilfen in den Einstellungen deaktivieren.</small>", 'Einführungshilfe');
			helpShown[text] = true;
		}
	}
}

function resizeBg() {
	var verhaeltnis = 1334 / 750;
	var iHeight		= $('#homeScreen').height();
	$('#homeScreen').width((iHeight/verhaeltnis)+'px');
}

function getMusicSettings() {
	AJAXcall('./api.php', {method:'getMusicSettings'}, function(res) {
		if (res) {
			console.log(res);
			SETTINGS = res['data'];
		}
	});
}

$(document).ready(function() {
	myApp = new Framework7();
	resizeBg();
	
	getMusicSettings();
	
});








/*** AJAX ***/
function AJAXcall(endpoint,_data, returnFunction) {
	if (!returnFunction) {
		returnFunction = function(){};
	}
	$.extend(_data, {apiUser:USERNAME,apiAuth:AUTH});
	console.log(_data)
	var req = $.ajax({
		url: endpoint+"?cacheFucker="+Math.random(),
		type: "POST",
		data : _data,
		xhrFields: { withCredentials: true},
		success: function(data, textStatus, jqXHR) {
			returnFunction(data);
			
			jqXHR.abort();
		},
		error: function (jqXHR, textStatus, errorThrown) {
			returnFunction(false);
			
			jqXHR.abort();
		}
	});
	
	console.log('@AJAXcall');
}










function isNumber(obj) {
	return !isNaN(parseFloat(obj))
}
function urldecode (str) {
  return decodeURIComponent((str + '')
    .replace(/%(?![\da-f]{2})/gi, function () {
      // PHP tolerates poorly formed escape sequences
      return '%25'
    })
    .replace(/\+/g, '%20'));
}
function urlencode (str) {
  str = (str + '');
  return encodeURIComponent(str)
    .replace(/!/g, '%21')
    .replace(/'/g, '%27')
    .replace(/\(/g, '%28')
    .replace(/\)/g, '%29')
    .replace(/\*/g, '%2A')
    .replace(/%20/g, '+');
}

</script>
		
	</body>
</html>