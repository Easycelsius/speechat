<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<!--  <link rel="stylesheet" href="https://unpkg.com/purecss@2.0.5/build/pure-min.css" integrity="sha384-LTIDeidl25h2dPxrB2Ekgc9c7sEC3CWGM6HeFmuDNUjX76Ert4Z4IY714dhZHPLd" crossorigin="anonymous">
	<meta name="viewport" content="width=device-width, initial-scale=1"> -->
	
	<!--<meta charset="UTF-8">
  	<meta name="viewport" content="width=device-width, initial-scale=1.0">
  	<meta http-equiv="X-UA-Compatible" content="ie=edge">
  	<link rel="stylesheet" href="https://unpkg.com/papercss@1.8.2/dist/paper.min.css">-->
  	
  	<!-- Google Fonts https://milligram.io/-->
	<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,300italic,700,700italic">
	
	<!-- CSS Reset -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/normalize/8.0.1/normalize.css">
	
	<!-- Milligram CSS -->
	<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/milligram/1.4.1/milligram.css">
  	
	<title>Speechat</title>
	<style>
	/* Custom color */
		.button-black {
		  background-color: black;
		  border-color: black;
		}
		.button-black.button-clear,
		.button-black.button-outline {
		  background-color: transparent;
		  color: black;
		}
		.button-black.button-clear {
		  border-color: transparent;
		}
		
		#first_wrap{
			width: 70%;
			margin: 0 auto;
		}
		
		#messageTextArea{
			height: 250px;
		}
		
		#play{
			display:none;
		}
		
	</style>
	<script src="https://ajax.googleapis.com/ajax/libs/jquery/1.12.4/jquery.min.js"></script>
</head>
<body>
	<audio>
            <!-- 첫번째를 지원하면 두번째를 지원 -->
            <!-- 정답시 효과음 -->
            <source src="bomb.mp3" type="audio/mp3">
            Your browser does not support the audio element.
    </audio>
    
    <button id = "play">Play</button>
	
	
	<div id="first_wrap">
		<h1>S p e e c h a t</h1>
		<div>
		<label for = "messageTextArea">Messenger</label>
		<textarea id="messageTextArea" readonly></textarea>
		</div>
	
		<div class="">
			<label for = "lang_seleect">Target Language Choice</label>
	 		<select id = "lang_select">
	  			<option value = "en">English</option>
		  		<option value = "kr">Korean</option>
		  		<option value = "jp">Japanese</option>
		  		<option value = "cn">Chinese</option>
		  		<option value = "vi">Vietnamese</option>
		  		<option value = "id">Indonesian</option>
		  		<option value = "ar">Arabian</option>
		  		<option value = "bn">Bengali</option>
		  		<option value = "de">German</option>
		  		<option value = "es">Spanish</option>
		  		<option value = "fr">French</option>
		  		<option value = "hi">Hindi</option>
		  		<option value = "it">Italian</option>
		  		<option value = "ms">Malaysian</option>
		  		<option value = "nl">Dutch</option>
		  		<option value = "pt">Portuguese</option>
		  		<option value = "ru">Russian</option>
		  		<option value = "th">Thai</option>
		  		<option value = "tr">Turkish</option>
	  		</select>	
	    </div>
	  
	  	<div>
	  	  <label for = "form">Information</label>
		  <form id = "form">	
		    <!-- 유저 명을 입력하는 텍스트 박스(기본 값은 anonymous(익명)) -->	
		    <input autofocus id="user" type="text" placeholder="Name" onchange="make_id()">	
		    <!-- 송신 메시지를 작성하는 텍스트 박스 -->	
		    <input id="textMessage" type="text" placeholder="Message">	
		    <!-- 메세지를 송신하는 버튼 -->	
		    <input onclick="sendMessage()" value="Send" type="button" id="sendBox">	
		    <!-- 기존 메세지 삭제 -->
		    <input onclick="clear_text()" value="Clear" type="button">	
		    <!-- WebSocket 접속 종료하는 버튼 -->	
		    <input id="connector" onclick="disconnect()" value="Disconnect" type="button">
		  </form>
		</div>
	  <!-- 콘솔 메시지의 역할을 하는 로그 텍스트 에리어.(수신 메시지도 표시한다.) -->	
	</div>
	
  
	<script type="text/javascript">	
	// window.onload 와 동일함 --> jQuery에서 사용하는 방법
	// $(function())
	// window.onload = () => {
		
		let lang_select = document.querySelector("#lang_select");
		
	    // 「WebSocketEx」는 프로젝트 명	
	    // 「broadsocket」는 호스트 명	
	    // WebSocket 오브젝트 생성 (자동으로 접속 시작한다. - onopen 함수 호출)	

	    var webSocket = new WebSocket("ws://localhost:8084/worldchat/broadsocket");
	    // 콘솔 텍스트 에리어 오브젝트	
	    
	    // WebSocket 서버와 접속이 되면 호출되는 함수	
	    webSocket.onopen = function(message) {	
	      // 콘솔 텍스트에 메시지를 출력한다.	
	      if(localStorage.getItem("messageTextArea")!=null&&localStorage.getItem("messageTextArea")!=""){
	    	messageTextArea.value = localStorage.getItem("messageTextArea");
	      } 
	      
	      (messageTextArea.value == "Server connect\n")? "": messageTextArea.value += "Server connect\n";  
	      
	      if(localStorage.getItem("id")!=null&&localStorage.getItem("id")!=""){
	    	user.value=localStorage.getItem("id");
	    	make_id();
	      }
	    };
	    
	    // WebSocket 서버와 접속이 끊기면 호출되는 함수	
	    webSocket.onclose = function(message) {	
	      // 콘솔 텍스트에 메시지를 출력한다.	
	      messageTextArea.value += "Server Disconnect\n";	
	    };	
	    
	    // WebSocket 서버와 통신 중에 에러가 발생하면 요청되는 함수	
	    webSocket.onerror = function(message) {	
	      // 콘솔 텍스트에 메시지를 출력한다.	
	      messageTextArea.value += "error\n";	
	    };	
	    
	    let user = document.querySelector("#user");
	    let message = document.getElementById("textMessage");	

	 	// Send 버튼을 누르면 호출되는 함수	
	    function sendMessage() {	
	      
		  if(textMessage.value==""||textMessage.value==null||user.value==""||user.value==null){
			  return;
		  }

	      transContent(message.value).then(final_msg => {
	    	// 콘솔 텍스트에 메시지를 출력한다.	
	    	  messageTextArea.value += user.value + "(me) : " + final_msg + "\n";
	    	// WebSocket 서버에 메시지를 전송(형식 「{{유저명}}메시지」)	
		      webSocket.send("{{" + user.value + "}}" + final_msg);	
	      })
	      
	      // 스크롤바 이동
	      move_scroll();
	      
	      // 송신 메시지를 작성한 텍스트 박스를 초기화한다.	
	      message.value = "";	
	    }
	 	
	 	
	  	/// WebSocket 서버로 부터 메시지가 오면 호출되는 함수	
	    webSocket.onmessage = function(message) {	
	      // 콘솔 텍스트에 메시지를 출력한다.	
	      messageTextArea.value += message.data + "\n";
	      move_scroll()
	      recive_message_sound();
	    };	
	    
	    // 받았던 텍스트 메시지 깔끔하게 정리
	    function clear_text(){
	    	messageTextArea.value = "";
	    }
	    
	    function make_id(){
	    	if(user.value.length>=1){
	    		webSocket.send(user.value+" participated");
	    		user.setAttribute("disabled","disabled");
	    		user.style.background="whitesmoke";
	    		user.style.fontWeight="bold";
	    	}
	    }
	    
	    function connect(){
	    	window.location.reload();
	    }
	    
	    let connector = document.querySelector("#connector");
	    // Disconnect 버튼을 누르면 호출되는 함수	
	    function disconnect() {	
	    // WebSocket 접속 해제
	   	  if(user.value!=""){
	      	webSocket.send(user.value+" went out");
	   	  }
	      webSocket.close();
	      
	      connector.setAttribute("value","Connect");
	      connector.setAttribute("onclick","connect()");
	      connector.setAttribute("type","button");
	    }
	    
	    // 브라우저 창을 종료하는 경우 
	    window.addEventListener("beforeunload", function (event) {
	    	disconnect();
	    	localStorage.setItem("messageTextArea", messageTextArea.value);
	    	localStorage.setItem("id", user.value);
	    });
	    
	    function move_scroll(){
	    	messageTextArea.scrollTop = messageTextArea.scrollHeight;
	    }

		let kakao_langCode = 'kr';
		
		// 인증키 객체
		let authentication_obj = new func_authentication();
		
		// 언어 감지
		function detectLang(str) {
		    return new Promise(function(resolve, reject) {
		        $.ajax({
		            type: "GET",
		            url: "https://dapi.kakao.com/v3/translation/language/detect?query="+str,
		            dataType: 'json',
		            headers: {"Authorization": "KakaoAK " + authentication_obj.getAuthentication()},
		            data: {},
		            success: function (data){
		                var res = null;
		                var confidence = data.language_info.map(function(v){return v.confidence});
		                var index = confidence.indexOf(Math.max.apply(null, confidence));
		                resolve(data.language_info[0].code);
		            },
		            error: function (xhr,ajaxOptions,throwError){
		                reject(throwError);
		            }
		        });
		    });
		}
		
		// 언어 번역		
		function translate(str) {
		    return new Promise(function(resolve, reject) {
		        $.ajax({
		            type: "GET",
		            url: "https://dapi.kakao.com/v2/translation/translate?src_lang="+kakao_langCode+"&target_lang="+lang_select.value+"&query="+str,
		            dataType: 'json',
		            headers: {"Authorization": "KakaoAK " + authentication_obj.getAuthentication()},
		            data: '{}',
		            success: function (data){
		                resolve(data.translated_text[0][0]);
		            },
		            error: function (xhr,ajaxOptions,throwError){
		                reject(throwError);
		            }
		        });
		    });
		}
		
		//var langCode = detectLang(str);
		//var res = translate(str);
		
		// 감지와 번역 기능 수행
		// async
		async function transContent(string) {
	        var str = string.trim();
	        if(str){
	            try {
	                kakao_langCode = await detectLang(str);
	                    if(lang_select.value != kakao_langCode){
	                    	var res = await translate(str);
		                    console.log(res);
		                    return res;
	                    } else {
	                    	return str;
	                    }      
	            } catch(e) {
	                console.log(e);
	            }
	        }
	        await delay(100);
		}
		
		textMessage = document.querySelector("#textMessage");
		textMessage.onkeydown = (event)=>{
            if(event.keyCode == 13){
            	sendMessage();
                return;
            }
		}
		
		// 인증키 얻기
		function func_authentication(){
			let authentication;
			//XMLHttpRequest 객체의 생성
			let req = new XMLHttpRequest();
			// 비동기 방식으로 Request를 오픈한다
			req.open('GET', 'kakaoApi.jsp', true);
			// Request를 전송한다
			req.send(); 
			
			// XMLHttpRequest.readyState 프로퍼티가 변경(이벤트 발생)될 때마다 콜백함수(이벤트 핸들러)를 호출한다.
			req.onreadystatechange = function (e) {
			  // 이 함수는 Response가 클라이언트에 도달하면 호출된다.
			
			  // readyStates는 XMLHttpRequest의 상태(state)를 반환
			  // readyState: 4 => DONE(서버 응답 완료)
			  if (req.readyState === XMLHttpRequest.DONE) {
			    // status는 response 상태 코드를 반환 : 200 => 정상 응답
			    if(req.status == 200) {
			    	authentication = req.responseText.trim();
			    } else {
			      	console.log("Authentication Error!");
			    }
			  }
			};
			
			this.getAuthentication = function () { return authentication; };
		}
		
		// 효과음
		let audio = document.querySelector("audio");
		// sound
        //// 함수명(콜백하는 형태 onclick함수 내에 다른 함수를 실행)
        recive_message_sound = play.onclick = () => {
            audio.play();
        }
		
	</script>
</body>
</html>