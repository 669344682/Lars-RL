/***************************************************
****************************************************
****** Copyright (c) 2014-2018 FirstOne Media ******
****************************************************
****** Commercial use or Copyright removal is ******
****** strictly prohibited without permission ******
****************************************************
***************************************************/

isPlaying = false;
var isPaused = false;
var isLive = false;
var isLoading = false;
isPlayerShowing = false;
var mp3Uri = "";
var nowTitle = "";
var audioObject = false;
var duration = 0;
var durationTxt = '0:00';
var curDuration = 0;
var curDurationTxt = '0:00';
var LIVE_META = "";
var CAN_CHANGE_POS = false;
var Lyrics = {};
var lastChartUpdate = 0;
var currentSongID = 0;
var currentPlaylist = '';
var currentPlaylistPos = 0;
var lastImage = "";


var LngIntv = false;
var PLAYER = new Audio();
PLAYER.volume = 0.8;
PLAYER.onplay = function(e) {
	console.log(PLAYER);
	
	//hotfix: if user fast-skips a stream, sometimes interval will not be killed.
	if (LngIntv) {
		clearInterval(LngIntv);
	}
	
	if (!isLive) {
		LngIntv = setInterval(function() {
			var dur = PLAYER.duration;
			if (isNumber(dur) && dur > 0) {
				clearInterval(LngIntv);
				musicStartCB(dur);
			}
		}, 50);
	}
};
PLAYER.onerror = function(e) {
	myApp.alert('Diese Datei kann nicht wiedergegeben werden. Möglicherweise ist die Datei nicht verfügbar oder das Dateiformat wird nicht unterstützt.', 'Music');
}

function musicStartCB(length) { // start callback from lua
	console.log('@musicStartCB: length:'+length);
	isLoading = false;
	isPlaying = true;
	isPaused = false;
	duration = length;
	CAN_CHANGE_POS = true;
	durationTxt = ('0' + parseInt(duration / 60, 10)).slice(-2)+':'+('0' + parseInt(duration % 60)).slice(-2);
}

function musicPlayerClick(what) {
	if (isLoading) { return false; }
	isLoading = true;
	
	if (what == 'playpause') {
		console.log('@musicPlayerClick: playpause: 0');
		if (isPlaying == false) {
			console.log('@musicPlayerClick: playpause: isPlaying==false');
			var fix = 'pause';
			if (isLive) { fix='stop'; }
			$('#musicPlayerPlayPause').css('background', 'url(images/ui/'+fix+'Btn.png) no-repeat');
			$('#musicPlayerPlayPause').css('background-size', '30px 30px');
			$('#musicPlayNowBtn').css('background', 'url(images/ui/'+fix+'Btn.png) no-repeat');
			$('#musicPlayNowBtn').css('background-size', '20px 20px');
			
			if (isPaused == true && isLive == false) {
				
				console.log('@musicPlayerClick: playpause: isPlaying==false --> play');
				
				isPlaying = true;
				isPaused = false;
				//mta.triggerEvent("musicPlayPause", "play");
				PLAYER.play();
				$('#musicVolumeSlide').val(CUR_VOLUME);
				$('#musicVolumeSlide').attr('value', CUR_VOLUME);
				setTimeout(function() { isLoading = false; }, 250);
				
			} else {
				
				console.log('@musicPlayerClick: playpause: isPlaying==false --> start');
				
				isPlaying = true;
				isPaused = false;
				//mta.triggerEvent("musicStartPlay", mp3Uri, CUR_VOLUME);
				PLAYER.src = mp3Uri;
				PLAYER.play();
				setTimeout(function() { isLoading = false; }, 250);
				
			}
			
		} else {
			console.log('@musicPlayerClick: playpause: isPlaying==true');
			$('#musicPlayerPlayPause').css('background', 'url(images/ui/playBtn.png) no-repeat');
			$('#musicPlayerPlayPause').css('background-size', '30px 30px');
			$('#musicPlayNowBtn').css('background', 'url(images/ui/playBtn.png) no-repeat');
			$('#musicPlayNowBtn').css('background-size', '20px 20px');
			
			isPlaying = false;
			isPaused = true;
			//mta.triggerEvent("musicPlayPause", "pause");
			PLAYER.pause();
			setTimeout(function() { isLoading = false; }, 250);
		}
		
		
	}
}

function musicStartNew(uri, title, subtitle, image, live, album, songID, playlistFrom, playlistPos) {
	console.log('@musicStartNew: 1');
	if (currentSongID == songID && songID.length > 0) {
		return musicTabClick('player');
	}
	$(".listPlayingAnimIcon").remove();
	
	if (playlistFrom == 'musicContentScrollInner' || playlistFrom == 'chartsContentScrollInner' || playlistFrom == 'likesContentScrollInner') {
		$("#"+playlistFrom+" > li[data-playlistpos='"+playlistPos+"'] .item-inner .playIconAnim").html('<i class="fa fa-play-circle-o faa-pulse animated listPlayingAnimIcon" style="float:right;font-size:22px;color:#ff2d55;positiosn:absolute;text-shadow: 1px 1px 1px #000;"></i>');
	}
	
	CAN_CHANGE_POS = false;
	LIVE_META = "";
	mp3Uri = uri;
	duration = 0;
	durationTxt = '0:00';
	curDuration = 0;
	curDurationTxt = '0:00';
	isLive = false;
	title = urldecode(title);
	subtitle = urldecode(subtitle);
	if (album) {
		subtitle = subtitle+" - "+urldecode(album);
	}
	nowTitle = title;
	currentPlaylist = playlistFrom;
	currentPlaylistPos = playlistPos;
	
	if (live == true) {
		isLive = true;
		subtitle = title;
		title = 'Keine Sendungsinformationen';
	}
	
	currentSongID = 0;
	if (songID != false && isNumber(songID)) {
		currentSongID = songID;
		$('#playerLikeBtn').attr("onclick", "unLikeSong("+songID+");");
	} else {
		$('#playerLikeBtn').attr("onclick", "myApp.alert('Diesen Inhalt kannst Du nicht zu deinen Likes hinzufügen.', 'Musik');");
	}
	
	var likes = $.parseJSON(SETTINGS['likedSongs']);
	if (likes[songID]) {
		$('#playerLikeIcon').attr('class', 'fa fa-heart faa-burst animated-hover');
	} else {
		$('#playerLikeIcon').attr('class', 'fa fa-heart-o faa-pulse animated-hover');
	}
	
	$('#musicPlayerTitle').html(title);
	$('#musicPlayerTitle').attr('class', '');
	$('#musicPlayNowTitle').html(title);
	$('#musicPlayNowTitle').html('<span style="color:#ff2d55;">'+subtitle+'</span> '+title);
	$('#musicPlayNowTitle').attr('class', '');
	$('#musicPlayerInterpret').html(subtitle);
	
	$("#musicPlayerCover").css("background", "url(images/ui/cover.png) no-repeat center center");
	if (image != false && image != '' && live == false) {
		//if (decodeURIComponent(image).indexOf('data:image') >= 0) {
			lastImage = decodeURIComponent(image);
			$("#musicPlayerCover").css("background", "url("+decodeURIComponent(image)+") no-repeat center center");
		/*} else {
			imageProxy(image, '#musicPlayerCover');
		}*/
	}
	if (image != false && image != "" && live == true) {
		lastImage = image;
		$("#musicPlayerCover").css("background", "url("+image+") no-repeat center center");
	}
	
	if (isPlaying || isPaused) {
		console.log('@musicStartNew: isPlaying || isPaused ; Stopping old audio');
		//mta.triggerEvent("musicPlayPause", "stop");
		PLAYER.pause();
		isPlaying = false;
		isPaused = false;
		isLoading = false;
	}
	musicTabClick('player');
	musicPlayerClick('playpause');
	
	$("#musicPlayerCover").html('');
	if (isNumber(songID)) {
		var lyric = Lyrics[songID];
		if (lyric["isLiveLyric"] == true) {
			var put = '<span style="position:relative;display: block; overflow: hidden; height:100%; background: rgba(0, 0, 0, .3);transform: translate(0,0);-moz-transform: translate(0,0);transform: translate(0px, 0px);" class="lyrics"><center><br><br><br>';
			$.each(lyric['lyric'], function(time, text) {
				put = put + '<span class="liveLyric" style="display:block;width:85%;" time="'+time+'"><center>'+text+'</center></span><br><br>';
			});
			$("#musicPlayerCover").html(put+'<br><br><br></center></span>');
			
		} else if (lyric["isLiveLyric"] == false) {
			//$("#musicPlayerCover").html(lyric["lyric"]);
		}
	}
	
	firstGuideHelp("Klicke auf das linke pinke Symbol unten, um das Lied auf einem anderen Gerät abzuspielen. Mit dem Herz kannst Du Songs zu deiner Playlist hinzufügen.");
}

var mSliderFreezed = false;
function musicPlayerUpdate() {
	if (CUR_APP == 'music') {
		if ((isPlaying || isPaused) && !isPlayerShowing) {
			$('.musicInner').css('height', '406px');
			$('.musicWhatsNowPlaying').css('display', '');
			$('.musicContentScroll').css('height', '355px');
		} else {
			$('.musicInner').css('height', '441px');
			$('.musicWhatsNowPlaying').css('display', 'none');
			$('.musicContentScroll').css('height', '390px');
		}
	}
	if (isPlaying == true) {
		//curDuration = curDuration+1;
		curDuration = PLAYER.currentTime;
		curDurationTxt = ('0' + parseInt(curDuration / 60, 10)).slice(-2)+':'+('0' + parseInt(curDuration % 60)).slice(-2);
		if (!isLive) {
			if (curDuration >= 1 && duration >= 3 && curDuration >= duration && isLoading == false) {
				curDuration = 0;
				curDurationTxt = '0:00';
				isPlaying = false;
				isPaused = false;
				
				$('#musicPlayerPlayPause').css('background', 'url(images/ui/playBtn.png) no-repeat');
				$('#musicPlayerPlayPause').css('background-size', '30px 30px');
				$('#musicPlayNowBtn').css('background', 'url(images/ui/playBtn.png) no-repeat');
				$('#musicPlayNowBtn').css('background-size', '20px 20px');
				
				$('.lyrics').animate({
					scrollTop: 0
				}, 250);
				
				musicBackForwd("forwards", true);
			}
		}
		
		$('#musicPlayerDur').html(durationTxt);
		$('#musicPlayerDurCur').html(curDurationTxt);
		if (!mSliderFreezed && !isLive) {
			$('#musicDurSlide').attr('value', curDuration);
			$('#musicDurSlide').val(curDuration);
			$('#musicDurSlide').attr('max', duration);
		} else if (isLive) {
			$('#musicDurSlide').attr('value', '1');
			$('#musicDurSlide').val('1');
			$('#musicDurSlide').attr('max', '1');
		}
		
		if (isLive) {
			
			if ((Math.floor(curDuration)%5)==0) {
				AJAXcall('./id3.php', {u:mp3Uri}, function(t) { console.log('id3', t); if (t.length > 0) { LIVE_META = t; } });
			}
			
			var fix = "Keine Sendungsinformationen";
			if (LIVE_META.length > 1) {
				fix = LIVE_META;
			}
			$('#musicPlayerTitle').html(fix);
			$('#musicPlayNowTitle').html('<span style="color:#ff2d55;">'+nowTitle+'</span> '+fix);
		}
	}
	
	if (CAN_CHANGE_POS) {
		$('#durationColorFix').html('');
	} else {
		$('#durationColorFix').html('.range-slider-small input[type="range"]::-webkit-slider-thumb { background:#D3D3D3; } .range-slider-small input[type="range"]::-webkit-slider-thumb:after { background:#D3D3D3; }');
	}
	
	
	var lng = $('#musicPlayNowTitle').html().length;
	if (lng >= 30) {
		$('#musicPlayNowTitle').attr('class', 'marquee');
	} else {
		$('#musicPlayNowTitle').attr('class', '');
	}
	
	lng = $('#musicPlayerTitle').html().length;
	if (lng >= 30) {
		$('#musicPlayerTitle').attr('class', 'marquee');
	} else {
		$('#musicPlayerTitle').attr('class', '');
	}
	
	lng = $('#musicPlayerInterpret').html().length;
	if (lng >= 35) {
		$('#musicPlayerInterpret').attr('class', 'marquee');
	} else {
		$('#musicPlayerInterpret').attr('class', '');
	}
}
$(document).ready(function() {
	$("#musicDurSlide").mousedown(function() {
		mSliderFreezed = true;
	});
	$("#musicDurSlide").mouseup(function() {
		mSliderFreezed = false;
		if (!isLive && CAN_CHANGE_POS == true) {
			curDuration = Number($('#musicDurSlide').val());
			//mta.triggerEvent("musicChangePos", curDuration);
			PLAYER.currentTime = curDuration;
		}
	});
});
setInterval(musicPlayerUpdate, 1000);

var lastLiveLyric = false;
function lyricUpdate() {
	if (isPlaying == true) {
		
		
		// ugly workaround - CEF doesn't seems to support mouse or click events via JS
		currentVolumeX = $('#musicVolumeSlide').val();
		if (currentVolumeX != CUR_VOLUME) {
			CUR_VOLUME = currentVolumeX;
			$('#musicVolumeSlide').val(CUR_VOLUME);
			$('#musicVolumeSlide').attr('value',CUR_VOLUME);
			//mta.triggerEvent("musicChangeVolume", CUR_VOLUME);
			PLAYER.volume = (CUR_VOLUME/100);
		}
		
		
		$(".liveLyric").each(function() {
			$(this).attr('style', 'display:block;width:75%;');
		});
		var msNow = (curDuration * 1000)+500; //komiscdherweise allle lyrics leicht verzögert - in mta gings aber?!
		var last = false;
		$(".liveLyric").each(function() {
			var time = $(this).attr('time');
			if (msNow >= time) {
				last = this;
			}
		});
		if (last != false) {
			
			if (lastLiveLyric != last) {
				var to = $(last).offset().top - $('.lyrics').offset().top + $('.lyrics').scrollTop() - ($('.lyrics').height()/2) + 30;
				if (to > 0) {
					$('.lyrics').animate({
						scrollTop: to
					}, 250);
				}
				lastLiveLyric = last;
			}
			$(last).attr('style', 'display:block;width:85%;background-color:white;color:black;font-weight:bold;');
			
		}
	}
}
setInterval(lyricUpdate, 75);

var chartsRunning = false;
function musicTabClick(what) {
	$('.musicInnerPlay').css('display', 'none');
	$('.musicInnerRadio').css('display', 'none');
	$('.musicInnerSearch').css('display', 'none');
	$('.musicInnerCharts').css('display', 'none');
	$('.musicInnerLikes').css('display', 'none');
	$('.musicMp3Inner').css('display', 'none');
	$('#radioChannelAdd').css('display', 'none');
	$('#radioContentScroll').css('display', 'none');
	
	$('#tabRadio').attr('class', '');
	$('#tabCharts').attr('class', '');
	$('#tabLiked').attr('class', '');
	$('#tabSearch').attr('class', '');
	$('#tabMP3').attr('class', '');
	
	isPlayerShowing = false;
	if (what == 'radio') {
		$('#tabRadio').attr('class', 'mTabActive');
		$('.musicInnerRadio').css('display', '');
		$('#radioContentScroll').css('display', '');
		
		var put = '';
		var pos = 1;
		$.each($.parseJSON(SETTINGS['radiostations']), function(i, arr) {			
			var fix = "musicStartNew('"+arr.url+"', '"+arr.name+"', '', 'radioimage.php?radio="+encodeURIComponent(arr.name)+"', true, '', '', 'radioContentScroll', "+pos+");";
			put = put + '<li data-playlistpos="'+pos+'" class="mRadioBtn" style="background:#ff2d55;background:url(radioimage.php?radio='+encodeURIComponent(arr.name)+') no-repeat center center; background-size:100% auto !important;" onclick="'+fix+'"><span style="position:absolute;text-align:center;top:50%;transform: translateY(-50%); ">'+arr.name+'</span></li>';
			pos = pos + 1;
		});
		$.each(DEFAULT_RADIOS, function(i, arr) {
			var fix = "musicStartNew('"+arr.url+"', '"+arr.name+"', '', 'images/radio/"+arr.image+"', true, '', '', 'radioContentScroll', "+pos+");";
			put = put + '<li data-playlistpos="'+pos+'" class="mRadioBtn" style="background:url(images/radio/'+arr.image+') no-repeat center center; background-size:100% auto !important;" onclick="'+fix+'"></li>';
			pos = pos + 1;
		});
		$('#radioContentScroll').html(put+'<br><br>');
		
		firstGuideHelp("Radiosender welche Du hier hinzufügst, sind auch in Fahrzeugen verfügbar.");
		
		
		
	} else if (what == 'search') {
		$('#tabSearch').attr('class', 'mTabActive');
		$('.musicInnerSearch').css('display', '');
		
	} else if (what == 'player') {
		$('.musicInnerPlay').css('display', '');
		isPlayerShowing = true;
		console.log('@musicTabClick: show player');
		
		
	} else if (what == 'charts') {
		$('#tabCharts').attr('class', 'mTabActive');
		$('.musicInnerCharts').css('display', '');
		
		var r = Math.floor(Date.now() / 1000) - lastChartUpdate;
		if (r >= ((60*60)*1) && !chartsRunning) {
			AJAXcall('../../api/163.php', {charts:1}, chartsCallback);
			$('#chartsContentScrollInner').html('<br><center><span style="display:block;max-width:80%;">Bitte habe einen Augenblick geduld während die Charts geladen werden.</span><br><span class="preloader ks-preloader-big"></span></center>');
			lastChartUpdate = Math.floor(Date.now() / 1000);
			chartsRunning = true;
		}
		
	} else if (what == 'liked') {
		firstGuideHelp('In dieser Playlist werden die Lieder gespeichert, welche du im Player mit einem Klick auf das Herz likst. Maximal können 250 Lieder gespeichert werden.');
		$('#tabLiked').attr('class', 'mTabActive');
		$('.musicInnerLikes').css('display', '');
		updateLikes();
		
	} else if (what == 'addRadio') {
		$('#tabRadio').attr('class', 'mTabActive');
		$('.musicInnerRadio').css('display', '');
		$('#radioChannelAdd').css('display', '');
		
		var put = '';
		$.each($.parseJSON(SETTINGS['radiostations']), function(i, arr) {
			put = put + '<li>\
				<div class="item-content">\
					<div class="item-inner">\
						<span style="float:left;width:60%;">'+arr.name+'</span>\
						<span style="width:40%;">\
							<div class="swipeout-actions-right swipeout-actions-opened"><a href="#" onclick="delRadioChannel('+i+');" class="swipeout-delete" style="transform: translate3d(-109px, 0px, 0px);">Löschen</a></div>\
						</span>\
					</div>\
				</div>\
			</li>';
		});
		$('#radioDelList').html(put);
		
		
		
		
	} else if (what == 'mp3') {
		$('#tabMP3').attr('class', 'mTabActive');
		$('.musicMp3Inner').css('display', '');
		
	}
	musicPlayerUpdate();
}






var searchRunning = false;
function searchMusic(str, startOf) {
	if (searchRunning) { return false; }
	
	if (!startOf) { startOf = 0; }
	
	if (!str) {
		str = $('#musicSearchText').val();
	}
		
	if (str.length >= 3) {
		$('#musicSearchText').val('');
		if (startOf == 0) {
			$('#musicContentScrollInner').html('<br><center><span style="display:block;max-width:80%;">Bitte habe einen Augenblick geduld, die Suche kann bis zu 10 Sekunden in anspruch nehmen.</span><br><span class="preloader ks-preloader-big"></span></center>');
		}
		
		AJAXcall('../../api/163.php', {s:str,limit:10,offset:startOf}, function(res) {
			searchMusicCallback({
				s		: str,
				offset	: startOf,
				limit	: 10,
				result	: res
			});
		});
		searchRunning = true;
	}
}

var canLoadMore = false;
var scrollStr = "";
var scrollOffset = 0;
var scrollLimit = 0;
var nextSong = false;
function searchLoadMore(cb) {
	nextSong = false;
	if (!searchRunning && canLoadMore) {
		
		if (cb) {
			nextSong = true;
		}
		
		searchMusic(scrollStr, (scrollOffset+scrollLimit));
		
		$('#musicContentScrollInner').append('<li class="loadMoreResults">\
			<div class="item-content">\
				<div class="item-inner">\
					<span><span style="color:#ff2d55;"><center><i class="fa fa-spinner faa-spin animated"></i> Lade weitere Ergebnisse...</center></span>\
				</div>\
			</div>\
		</li>');
	}
}
jQuery(function($) {
	$('.musicContentScroll').on('scroll', function() {
		if($(this).scrollTop() + $(this).innerHeight() >= $(this)[0].scrollHeight) {
			searchLoadMore(false);
		}
	});
});

function searchMusicCallback(json) {
	//json = $.parseJSON(atob(json));
	var put = '';
	var pos = 1;
	
	if (json['offset'] > 0) {
		pos = parseInt($("#musicContentScrollInner > li[data-playlistpos]").last().attr('data-playlistpos'))+1;
	}
	
	var results		= json['result'];
	var resCount	= Object.keys(results).length;
	
	if (resCount > 0) {
		$.each(results, function(i, arr) {
			Lyrics[(arr['id'])] = arr['lyric'];
			var fix = "musicStartNew('"+arr['url']+"', '"+urlencode(arr['title'])+"', '"+urlencode(arr['artist'])+"', '"+urlencode(arr['image'])+"', false, '"+urlencode(arr['album'])+"', "+arr['id']+", 'musicContentScrollInner', "+pos+");";
			put = put+'<li data-playlistpos="'+pos+'" onclick="'+fix+'">\
				<div class="item-content">\
					<div class="item-media">\
						<img src="'+arr['image']+'" class="" width="44">\
					</div>\
					<div class="item-inner">\
						<span><span style="color:#ff2d55;">'+arr['artist']+'</span> '+arr['title']+'</span>\
						<span class="playIconAnim"></span>\
					</div>\
				</div>\
			</li>';
			pos = pos + 1;
		});
		
		scrollStr = json['s'];
		scrollOffset = json['offset'];
		scrollLimit = json['limit'];
		
		if (resCount >= scrollLimit) {
			canLoadMore = true;
			firstGuideHelp("Scrolle bis zum ende, um weitere Ergebnisse zu laden.");
		} else {
			canLoadMore = false;
		}
		
		if (json['offset'] > 0) {
			$('#musicContentScrollInner .loadMoreResults').remove();
			$('#musicContentScrollInner').append(put);
		} else {
			$('#musicContentScrollInner').html(put);
		}
		
		
		if (nextSong == true) {
			myApp.hidePreloader();
			musicBackForwd('forwards', false);
			nextSong = false;
		}
	}
	
	searchRunning = false;
}

function chartsCallback(json) {
	var put = '';
	var pos = 1;
	$.each(json, function(i, arr) {
		Lyrics[(arr['id'])] = arr['lyric'];
		var fix = "musicStartNew('"+arr['url']+"', '"+urlencode(arr['title'])+"', '"+urlencode(arr['artist'])+"', '"+urlencode(arr['image'])+"', false, '"+urlencode(arr['album'])+"', "+arr['id']+", 'chartsContentScrollInner', "+pos+");";
		if (arr['url'] == false || arr['url'] == "false") {
			fix = "myApp.alert('Dieser Song ist (aktuell) leider nicht verfügbar.', 'Charts');";
		}
		put = put+'<li '+((arr['url']==false||arr['url']=='false') ? '' : 'data-playlistpos="'+pos+'"')+' onclick="'+fix+'">\
			<div class="item-content">\
				<div class="item-media">\
					<img src="'+arr['image']+'" class="" width="44">\
				</div>\
				<div class="item-inner">\
					<span><span style="color:#ff2d55;">'+arr['artist']+'</span> '+arr['title']+'</span>\
					<span class="playIconAnim"></span>\
				</div>\
			</div>\
		</li>';
		if (arr['url']!=false && arr['url']!='false') {
			pos = pos + 1;
		}
		
	});
	
	$('#chartsContentScrollInner').html(put);
	chartsRunning = false;
}




/*** LIKES ***/
var likesNeedUpdate = true;
var lastLikeUpdate	= 0;
var likesUpdateRunning = false;

function playlistCallback(json) {
	var put = '';
	var pos = 1;
	
	$.each(json, function(i, arr) {
		Lyrics[(arr['id'])] = arr['lyric'];
		var fix = "musicStartNew('"+arr['url']+"', '"+urlencode(arr['title'])+"', '"+urlencode(arr['artist'])+"', '"+urlencode(arr['image'])+"', false, '"+urlencode(arr['album'])+"', "+arr['id']+", 'likesContentScrollInner', "+pos+");";
		if (arr['url'] == false || arr['url'] == "false") {
			fix = "myApp.alert('Dieser Song ist (aktuell) leider nicht verfügbar.', 'Likes');";
		}
		put = put+'<li data-playlistpos="'+pos+'" onclick="'+fix+'">\
			<div class="item-content">\
				<div class="item-media">\
					<img src="'+arr['image']+'" class="" width="44">\
				</div>\
				<div class="item-inner">\
					<span><span style="color:#ff2d55;">'+arr['artist']+'</span> '+arr['title']+'</span>\
					<span class="playIconAnim"></span>\
				</div>\
			</div>\
		</li>';
		pos = pos + 1;
	});
	
	
	$('#likesContentScrollInner').html(put);
	likesUpdateRunning = false;
}

function updateLikes() {
	if (likesUpdateRunning) { return false; }
	var r = Math.floor(Date.now() / 1000) - lastLikeUpdate;
	if (likesNeedUpdate || r >= ((60*60)*1)) {
		var likes = $.parseJSON(SETTINGS['likedSongs']);
		
		var array = [];
		$.each(likes, function(id, time) {
			array.push(id);
		});
		
		var sortedLikes = Object.keys(likes).sort(function(a,b){return likes[b]-likes[a]})
		
		
		
		
		
		var str = "["+sortedLikes+"]";
		console.log(str)
		AJAXcall('../../api/163.php', {playlist:str}, playlistCallback);
		$('#likesContentScrollInner').html('<br><center><span style="display:block;max-width:80%;">Bitte habe einen Augenblick geduld während deine Playlist geladen wird.</span><br><span class="preloader ks-preloader-big"></span></center>');
		
		likesNeedUpdate = false;
		lastLikeUpdate	= Math.floor(Date.now() / 1000);
		likesUpdateRunning = true;
	}
}
function unLikeSong(id) {
	var likes = $.parseJSON(SETTINGS['likedSongs']);
	if (likes[id]) {
		delete likes[id];
		$('#playerLikeIcon').attr('class', 'fa fa-heart-o faa-pulse animated-hover');
		likesNeedUpdate = true;
		
	} else {
		if (Object.keys(likes).length >= 250) {
			myApp.alert("Deine Playlist ist voll. Du kannst maximal 250 Songs liken, entferne Songs von deiner Playlist um neue hinzuzufügen.", "Likes")
		} else {
			likes[id] = Math.floor(Date.now() / 1000);
			$('#playerLikeIcon').attr('class', 'fa fa-heart faa-burst animated-hover');
			likesNeedUpdate = true;
		}
	}
	
	
	SETTINGS['likedSongs'] = JSON.stringify(likes);
	
	if (likesNeedUpdate) {
		AJAXcall('api.php', {method:'setMusicLikes',likes:JSON.stringify(likes)}, function(){});
	}
}




/** FORWARDS BACKWARDS **/
var lastSkipMs = 0;
function musicBackForwd(what, backToStart) {	
	var r = Date.now() - lastSkipMs;
	if (r < 350) { return false; } //nur alle 350ms skip
	
	
	var checkNoti = false;
	if (currentPlaylist != '' && currentPlaylistPos != 0) {
		
		if (what == "forwards") {
			var max = $("#"+currentPlaylist+" > li").length;
			if (currentPlaylistPos < max || backToStart == true) {
				var fix = currentPlaylistPos;
				if (currentPlaylistPos >= max) { fix = 0; }
				var toPlay = $("#"+currentPlaylist+" > li[data-playlistpos='"+(fix+1)+"']");
				if (toPlay) {
					$(toPlay).click();
					lastSkipMs = Date.now();
					checkNoti = true;
				}
			} else {
				if (canLoadMore && currentPlaylist == "musicContentScrollInner") {
					searchLoadMore(true);
					myApp.showPreloader('Weitere Lieder werden geladen.');
				}
			}
			
		} else if (what == "backwards") {
			if (currentPlaylistPos > 1) {
				var toPlay = $("#"+currentPlaylist+" > li[data-playlistpos='"+(currentPlaylistPos-1)+"']");
				if (toPlay) {
					$(toPlay).click();
					lastSkipMs = Date.now();
					checkNoti = true;
				}
			}
		}
	}
	
	if (checkNoti /*&& (CUR_APP != 'music' || !IPHONE_OPEN)*/) {
		/*myApp.addNotification({
			title: 'Musik',
			message: 'Jetzt läuft: '+nowTitle,
			hold: 4000,
			closeOnClick: true,
			closeIcon:true,
			audio:false,
			image:lastImage,
			media:'<img width="44" height="44" src="'+lastImage+'">',
			onClose:(function() {
				openApp('music');
				musicTabClick('player');
			}),
			eventStr: "openApp('music');musicTabClick('player');"
		});*/
		
		toDataURL(lastImage, function(image) {
			$('#communicationFrame').attr('src', './clientNotification?='+encodeURIComponent('Jetzt läuft: '+nowTitle+'|'+image))
		});
	}
}




/*** RADIO ***/
function addRadioChannel() {
	var _name = $('#radioAddName').val();
	var _url = $('#radioAddURL').val();
	if (_name.length > 0 && _url.length > 10) {
		var stations = $.parseJSON(SETTINGS['radiostations']);
		
		myApp.showPreloader('Überprüfe Stream-URL...');
		AJAXcall('api.php', {method:'testRadioStream',stream:_url}, function(res){
			myApp.hidePreloader();
			if (res['success']) {
				myApp.showPreloader('Stream wird getestet...');
				var audioTest = new Audio(res['url']);
				audioTest.onplaying = function() {
					audioTest.pause();
					audioTest.src = undefined;
					audioTest = undefined;
					myApp.hidePreloader();
					
					stations.unshift({
						name:_name,
						url:res['url'],
						image:""
					});
					
					AJAXcall('api.php', {method:'setRadioChannels',stations:JSON.stringify(stations)}, function(res){
						if (res['success']) {
							SETTINGS['radiostations'] = JSON.stringify(stations);
							musicTabClick('addRadio');
						}
					});
					
					$('#radioAddName').val('');
					$('#radioAddURL').val('')
					myApp.alert("Radiosender hinzugefügt!", 'Radio');
					
				};
				audioTest.onerror = function() {
					audioTest.pause();
					audioTest.src = undefined;
					audioTest = undefined;
					
					$('#radioAddName').val('');
					$('#radioAddURL').val('')
					myApp.alert("Sream konnte nicht abgespielt werden.", 'Radio');
					
					myApp.hidePreloader();
				};
				audioTest.play();
			} else {
				myApp.alert('Die Stream-URL ist nicht gültig ('+res['message']+')', 'Radio');
			}
		});
		
		
		//setSetting('radiostations', JSON.stringify(stations));
		
	} 
}

function delRadioChannel(nr) {
	var stations = $.parseJSON(SETTINGS['radiostations']);
	
	var rest = stations.slice(nr + 1 || stations.length);
	stations.length = nr < 0 ? stations.length + nr : nr;
	stations.push.apply(stations, rest); 
	
	//setSetting('radiostations', JSON.stringify(stations));
	AJAXcall('api.php', {method:'setRadioChannels',stations:JSON.stringify(stations)}, function(res){
		if (res['success']) {
			SETTINGS['radiostations'] = JSON.stringify(stations);
			musicTabClick('addRadio');
		}
	});
	
	myApp.alert("Radiosender entfernt!", 'Radio');
}






/*** MP3 ***/
function youtube_parser(url){
	var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
	var match = url.match(regExp);
	return (match&&match[7].length==11)? match[7] : false;
}
function vimeo_parser(url){
	var regExp = /(http|https):\/\/(www\.)?vimeo.com\/(\d+)($|\/)/;
	var match = url.match(regExp);
	return (match&&match[3].length>=3)? match[3] : false;
}
function vevo_parser(url){
	var regExp = /(http|https):\/\/(www\.)?vevo.com\/watch\/(...+)\/(...+)\/(\w+)/;
	var match = url.match(regExp);
	return (match&&match[5].length>=3)? match[5] : false;
}
function dailymotion_parser(url){
	var regExp = /(http|https):\/\/(www\.)?dailymotion.com\/video\/(\w+)/;
	var match = url.match(regExp);
	return (match&&match[3].length>=3)? match[3] : false;
}
function soundcloud_parser(url){
	var regExp = /(http|https):\/\/(www\.)?soundcloud.com\/([^?]*)/;
	var match = url.match(regExp);
	return (match&&match[3].length>=3)? match[3] : false;
}

function playCustomMp3() {
	var url = $('#musicMp3URL').val();
	
	if (url.length >= 10) {
		var ytID = youtube_parser(url);
		var vmID = vimeo_parser(url);
		var veID = vevo_parser(url);
		var dmID = dailymotion_parser(url);
		var scID = soundcloud_parser(url);
		
		if (ytID.length >= 3) {
			myApp.showPreloader('Einen Moment...') 
			AJAXcall("../../api/ytdl.php", {srv:'youtube',id:ytID}, ytMp3Callback);
			
		} else if (vmID.length >= 3) {
			myApp.showPreloader('Einen Moment...') 
			AJAXcall("../../api/ytdl.php", {srv:'vimeo',id:vmID}, ytMp3Callback);
			
		} else if (veID.length >= 3) {
			myApp.showPreloader('Einen Moment...') 
			AJAXcall("../../api/ytdl.php", {srv:'vevo',id:veID}, ytMp3Callback);
			
		} else if (dmID.length >= 3) {
			myApp.showPreloader('Einen Moment...') 
			AJAXcall("../../api/ytdl.php", {srv:'dailymotion',id:dmID}, ytMp3Callback);
			
		} else if (scID.length >= 3) {
			myApp.showPreloader('Einen Moment...') 
			AJAXcall("../../api/ytdl.php", {srv:'soundcloud',id:encodeURI(scID)}, ytMp3Callback);
			
		} else {
			if (/(http|https):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/.test(url)) {
				musicStartNew(url, url, 'Custom', false, false);
			} else {
				myApp.alert('Ungueltiger Link.', 'MP3');
			}
		}
		
	} else {
		myApp.alert('Ungueltiger Link.', 'MP3');
	}
	
	$('#musicMp3URL').val('');
}

function ytMp3Callback(json) {
	
	myApp.hidePreloader();
	if (json['code'] == 'NOTFOUND') {
		myApp.alert('Dieses Video wurde nicht gefunden.', 'Youtube-MP3');
		
	} else if (json['code'] == 'NOLIVE') {
		myApp.alert('Live Videos können nicht abgespielt werden.', 'Youtube-MP3');
		
	} else if (json['code'] == 'TOLONG') {
		myApp.alert('Das Video ist zu lang. Maximal 20 Minuten.', 'Youtube-MP3');
		
	} else if (json['code'] == 'DLERROR') {
		myApp.alert('Beim Konvertieren ist ein Fehler aufgetreten, bitte versuche es erneut.', 'Youtube-MP3');
		
	} else if (json['code'] == 'SUCCESS' || json['code'] == 'EXISTS') {
		musicStartNew(json['dl'], json['title'], json['serviceName'], urlencode(json['image']), false);
		
	} else {
		myApp.alert('Unbekannter Fehler.', 'Youtube-MP3');
	}
}










function toDataURL(src, callback, outputFormat) {
  var img = new Image();
  img.crossOrigin = 'Anonymous';
  img.onload = function() {
	var canvas = document.createElement('CANVAS');
    var ctx = canvas.getContext('2d');
    var dataURL;
	
	var ratio = 1;
	if(this.width > 45) {
		ratio = 45 / this.width;
	} else if(this.height > 45) {
		ratio = 45 / this.height;
	}
	
	// set size proportional to image
	canvas.height = this.height * ratio;
	canvas.width = this.width * ratio;
	

    // step 1 - resize
    ctx.drawImage(this, 0, 0, this.width * ratio, this.height * ratio);
	
    dataURL = canvas.toDataURL(outputFormat);
    callback(dataURL);
  };
  img.src = src;
  if (img.complete || img.complete === undefined) {
    img.src = "data:image/gif;base64,R0lGODlhAQABAIAAAAAAAP///ywAAAAAAQABAAACAUwAOw==";
    img.src = src;
  }
}
