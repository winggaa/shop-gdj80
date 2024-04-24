<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" 	%>
<%@ page import = "java.sql.*"  	%>
<%@ page import="java.io.*" 		%>
<%@ page import="java.nio.file.*"   %>
<%@ page import="java.net.*" 		%>
<%@ page import= "shop.dao.*" %>
<%

String csMail = request.getParameter("csMail");
String csName = request.getParameter("csName");
String csPw = request.getParameter("csPw");
String gender = request.getParameter("gender");
String birth = request.getParameter("birth");

//System.out.println(gender);


Connection conn = DBHelper.getConnection();
 
conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
String sql1 = "INSERT INTO `shop`.`customer` (`mail`, `pw`, `name`, `birth`, `gender`) VALUES (?,password(?),?,?,?);";
PreparedStatement stmt1 = conn.prepareStatement(sql1);
stmt1.setString(1,csMail);
stmt1.setString(2,csPw);
stmt1.setString(3,csName);
stmt1.setString(4,birth);
stmt1.setString(5,gender);
ResultSet rs1 = stmt1.executeQuery();

 response.sendRedirect("/shop/customer/loginForm.jsp");


%>
