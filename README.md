# 스피챗(Speechat)
Automatic translation chat program with KAKAO API

본 프로젝트는 웹 소켓과 카카오 API를 활용한 자동번역 채팅프로그램 제작에 관한 프로젝트입니다. 
언어 장벽을 극복한 대화를 할 수 있는 프로그램을 구현하였습니다.

![pj32](https://user-images.githubusercontent.com/77523551/112705913-2e92ea80-8ee4-11eb-98eb-e5940101cb6c.png)

---------------------------------------

# 소개

| 프로젝트명 | Speechat                                                     |
| ---------- | ------------------------------------------------------------ |
| 개발기간   | 2020.03.24 ~ 2020.03.26                                      |
| 인원       | 1                                                            |
| 사용 기술  | 상세내용                                                      |
| 백엔드     | Apache Tomcat, JSP                                           |
| 프론트엔드 | HTML, CSS, JavaScript, jQuery, Ajax, , Web Socket, KAKAO API (번역) |
| 형상관리   | Local                                                        |
| 툴         | Eclipse, Visual Studio Code                                  |
| 운영체제   | Windows 10                                                   |

# 시현영상

https://user-images.githubusercontent.com/77523551/112704520-436c7f80-8ede-11eb-914c-bd7f593caf5f.mp4

# 사용법

※ 해당 파일에는 카카오 API 인증키가 없습니다. 사용시 Web Content 내 kakaoApi.jsp에 인증키를 입력 후 사용해주세요.  
※ index3 파일은 받는 문자에 대해 번역을 수행합니다.  
※ index 파일은 보내는 문자에 대해서 번역을 수행합니다.  
※ 상황에 따라 index 파일을 교체해가며 사용하면 됩니다.  

1. ID 입력(한번 정해진 ID는 브라우저 변경이 없는 한 유지)
2. 번역 대상 언어 설정
3. 메시지 입력 후 보내기
4. 텍스트창에서 메시지 확인
