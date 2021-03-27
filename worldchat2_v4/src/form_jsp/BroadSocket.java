package form_jsp;

import java.io.IOException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.websocket.OnClose;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.server.ServerEndpoint;

//WebSocket ȣ��Ʈ ����	
@ServerEndpoint("/broadsocket")
public class BroadSocket {
// ���� �� Ŭ���̾�Ʈ WebSocket session ���� ����Ʈ	
	private static List<Session> sessionUsers = Collections.synchronizedList(new ArrayList<>());
// �޽������� ���� ���� ����ϱ� ���� ���Խ� ǥ��	
	private static Pattern pattern = Pattern.compile("^\\{\\{.*?\\}\\}");

// WebSocket���� �������� �����ϸ� ��û�Ǵ� �Լ�		
	@OnOpen
	public void handleOpen(Session userSession) {
// Ŭ���̾�Ʈ�� �����ϸ� WebSocket������ ����Ʈ�� �����Ѵ�.	
		sessionUsers.add(userSession);
// �ֿܼ� ���� �α׸� ����Ѵ�.	
		System.out.println("client is now connected...");
	}

// WebSocket���� �޽����� ���� ��û�Ǵ� �Լ�	
	@OnMessage
	public void handleMessage(String message, Session userSession) throws IOException {
// �޽��� ������ �ֿܼ� ����Ѵ�.	
		System.out.println(message);
// �ʱ� ���� ��	
		String name = "Notice";
// �޽����� ���� ���� �����Ѵ�.	
		Matcher matcher = pattern.matcher(message);
// �޽��� ��: {{������}}�޽���	
		if (matcher.find()) {
			name = matcher.group();
		}
// Ŭ������ ���� ������ ���ȭ	
		final String msg = message.replaceAll(pattern.pattern(), "");
		final String username = name.replaceFirst("^\\{\\{", "").replaceFirst("\\}\\}$", "");
// session���� ����Ʈ���� Session�� ����Ѵ�.	
		sessionUsers.forEach(session -> {
			// ����Ʈ�� �ִ� ���ǰ� �޽����� ���� ������ ������ �޽��� �۽��� �ʿ����.
			if (session == userSession) {
				return;
			}
			try {
				// ����Ʈ�� �ִ� ��� ����(�޽��� ���� ���� ����)�� �޽����� ������. (����: ������ => �޽���)
				session.getBasicRemote().sendText(username + " : " + msg);
			} catch (IOException e) {
				// ������ �߻��ϸ� �ֿܼ� ǥ���Ѵ�.
				e.printStackTrace();
			}
		});
	}

// WebSocket�� �������� ������ ����� ��û�Ǵ� �Լ�	
	@OnClose
	public void handleClose(Session userSession) {
// session ����Ʈ�� ���� ���� ������ �����Ѵ�.	
		sessionUsers.remove(userSession);
// �ֿܼ� ���� ���� �α׸� ����Ѵ�.	
		System.out.println("client is now disconnected...");
	}
}
