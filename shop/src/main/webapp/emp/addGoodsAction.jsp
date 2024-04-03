<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<% 
	request.setCharacterEncoding("UTF-8");
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
String category = request.getParameter 		("category");
String goodsTitle   = request.getParameter 	("goodsTitle");
String goodsPrice =request.getParameter		("goodsPrice");
String goodsAmount = request.getParameter   ("goodsAmount");
String goodsContent = request.getParameter  ("goodsContent");
/*
System.out.println (category);     
System.out.println (goodsTitle);     
System.out.println (goodsPrice);      
System.out.println (goodsAmount);    
System.out.println (goodsContent);
*/
%>
<!--  Session 설정값 : 입력시 로그인 emp의 emp_id 값이 필요 -->
<%
	HashMap<String,Object> loginMember = (HashMap<String,Object>) (session.getAttribute("loginEmp"));
	
	System.out.println((String)loginMember.get("empId"));
%>

<!-- Model Layer -->
<%

Class.forName("org.mariadb.jdbc.Driver");
ResultSet rs1 = null;
Connection conn = null;
PreparedStatement stmt1 = null; 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
String sql1 = "INSERT INTO goods(category , emp_id, goods_title, goods_content, goods_price, goods_amount ) VALUES(?,?,?,?,?,?)";
stmt1 = conn.prepareStatement(sql1);
stmt1.setString(1, category);
stmt1.setString(2,(String)loginMember.get("empId"));
stmt1.setString(3, goodsTitle);
stmt1.setString(4, goodsContent);
stmt1.setString(5, goodsPrice);
stmt1.setString(6, goodsAmount);
rs1 = stmt1.executeQuery();

response.sendRedirect("/shop/emp/goodsList.jsp");

		

%>
<!-- Controller Layer -->
<%
	
%>