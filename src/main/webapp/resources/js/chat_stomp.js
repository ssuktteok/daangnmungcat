var usernamePage = document.querySelector('#username-page');
var chatPage = document.querySelector('#chat-page');
var usernameForm = document.querySelector('#usernameForm');
var messageForm = document.querySelector('#messageForm');
var messageInput = document.querySelector('#message');
var messageArea = document.querySelector('#messageArea');
var connectingElement = document.querySelector('.connecting');

var stompClient = null;

function connect() {
    var socket = new SockJS('/ws');
    stompClient = Stomp.over(socket);

    stompClient.connect({}, onConnected, onError);
}


function onConnected() {
    stompClient.subscribe('/topic/chat/' + chatId, onMessageReceived);
	readChat();
	
    console.log('연결됨');
    connectingElement.classList.add('hidden');
}

function connect_for_new() {
	var socket = new SockJS('/ws');
	stompClient = Stomp.over(socket);
	
	stompClient.connect({}, onConnected_for_new(), onError);
}


function onConnected_for_new() {
	console.log('연결됨');
	connectingElement.classList.add('hidden');
}

function subscribe_for_new() {
	stompClient.subscribe('/topic/chat/' + chatId, onMessageReceived);
	readChat();
}


function onError(error) {
    connectingElement.textContent = 'Could not connect to WebSocket server. Please refresh this page to try again!';
    connectingElement.style.color = 'red';
}


function sendMessage(event) {
	event.preventDefault();
	
    var messageContent = messageInput.value.trim();
    
    if(messageContent) {
	    var chatMessage = {
            chat: {id: chatId},
            member: {id: memberId, nickname: memberNickname},
            content: messageInput.value,
        };
	    
	    sendChatMessage(chatMessage);
    
    }
}

function sendImage() {
	var customFile = $('#customFile').val();
	
    var chatMessage = {
            chat: {id: chatId},
            member: {id: memberId, nickname: memberNickname},
    };
	
	if (customFile != "") {
    	var form = $('#messageForm')[0];
    	var form_data = new FormData(form);
	    
		$.ajax({
			type: 'post',
			enctype: 'multipart/form-data',
			url: contextPath + '/chat/' + chatId + '/upload',
			data: form_data,
			processData: false,
			contentType: false,
			cache: false,
			timeout: 600000,
			success: function(data) {
				chatMessage.image = data;
				sendChatMessage(chatMessage);
			},
			error: function(error) {
				alert("사진을 전송하는 데 실패했습니다.");
				console.log(error);
			}
		});
	}
}

function sendChatMessage(chatMessage) {
	if(stompClient) {
        stompClient.send('/app/chat/' + chatId + '.sendMessage', {}, JSON.stringify(chatMessage));
        messageInput.value = '';
    }
}

function readChat() {
	if(stompClient) {
		stompClient.send('/app/chat/' + chatId + '.read', {}, memberId);
	}
}

function onMessageReceived(payload) {
	var msg = JSON.parse(payload.body);
	
	if(msg.chat === undefined) {
		if(msg.id != memberId) {
			$('.read_yn').attr('read_yn', 'y');
			$('.read_yn').text('읽음 ');    	
		}
		return;
	}
	
    var li_str = "";
    
    if (msg.member.id == memberId) {
		// 나
		li_str += "<li class='chat-message me' msg_id='" + msg.id + "' sender='" + msg.member.id + "'>";
		li_str += "<div class='chat-message me bubble'><p>";
		if(msg.content != null) {
			li_str += msg.content;
		} else {
			li_str += "<img src='" + contextPath + "/resources/upload/chat/" + chatId + "/" + msg.image + "'>";
		}
		li_str += "</p><span class='read_yn' read_yn='" + msg.readYn + "'>";
		li_str += (msg.readYn == 'y' ? "읽음" : "읽지 않음") + "</span>";
		li_str += "<span class='regdate' regdate='" + msg.regdate + "'>" + dayjs(msg.regdate).format("YYYY년 M월 D일 h:mm") + "</span></div></li>";
	} else {
		// 너
		li_str += "<li class='chat-message you' msg_id='" + msg.id + "' sender='" + msg.member.id +"'>";
		li_str += "<div class='chat-message you profile_img'>";
		li_str += "<a href='" + contextPath + "/member/profile?id=" + msg.member.id + "'>";
		li_str += "<img alt='개인프로필' src='" + contextPath + "/resources/" + msg.member.profilePic + "'>";
		li_str += "</a></div>";
		li_str += "<div class='chat-message you bubble'><span class='nickname'>" + msg.member.nickname + "</span>";
		if(msg.content != null) {
			li_str += msg.content;
		} else {
			li_str += "<img src='" + contextPath + "/resources/upload/chat/" + chatId + "/" + msg.image + "'>";
		}
		li_str += "</p>";
		li_str += "<span class='regdate' regdate='" + msg.regdate + "'>" + dayjs(msg.regdate).format("YYYY년 M월 D일 h:mm") + "</span></div></li>";
	}
    
    $("#messageArea").append(li_str);
    messageArea.scrollTop = messageArea.scrollHeight;
    
    readChat();
}