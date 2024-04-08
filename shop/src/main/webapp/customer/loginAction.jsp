<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" 	%>
<%@ page import = "java.sql.*"  	%>
<%@ page import="java.io.*" 		%>
<%@ page import="java.nio.file.*"   %>
<%@ page import="java.net.*" 		%>
<%
	//로그인 인증 분기 : 세션변수 -> loginEmp
 	if(session.getAttribute("loginCs")!=null){ //로그인이 이미 되어있다면
 		response.sendRedirect("/shop/customer/customerGoodsList.jsp");
 		return;
 		}
%>

<!-- 로그인 세션 만드는 코드 -->
<%
String csId = request.getParameter("csId");
String csPw = request.getParameter("csPw");

System.out.println(csId);
System.out.println(csPw);

Class.forName("org.mariadb.jdbc.Driver");
ResultSet rs1 = null;
Connection conn = null;
PreparedStatement stmt1 = null; 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
String sql1 = "select * from customer where mail = ? and pw = password(?)";

stmt1 = conn.prepareStatement(sql1);
stmt1.setString(1 , csId);
stmt1.setString(2 , csPw);
System.out.println(stmt1);
rs1 = stmt1.executeQuery();

if(rs1.next()){
	System.out.println("로그인 성공");
	//하나의 세션변수안에 여러개의 값을 저장하기 위해서 hashmp타입을 사용
	HashMap<String,Object> loginCs = new HashMap<String, Object>();
	loginCs.put("csId", rs1.getString("mail"));
	loginCs.put("csName", rs1.getString("name"));
	loginCs.put("csGender", rs1.getString("gender"));
	loginCs.put("birth", rs1.getString("birth"));
	
	
	session.setAttribute("loginCs", loginCs);
	response.sendRedirect("/shop/customer/customerGoodList.jsp");
} else {		// 로그인실패
	System.out.println("로그인실패");
	String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");		
	response.sendRedirect("/shop/customer/loginForm.jsp?errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감
  }


	rs1.close();
	stmt1.close();
	conn.close();


%>
