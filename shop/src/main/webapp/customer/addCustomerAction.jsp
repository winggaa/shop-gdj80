<%@page import="org.mariadb.jdbc.export.Prepare"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" 	%>
<%@ page import = "java.sql.*"  	%>
<%@ page import="java.io.*" 		%>
<%@ page import="java.nio.file.*"   %>
<%@ page import="java.net.*" 		%>
<%@ page import= "shop.dao.*" %>
<%@page import="java.net.URLEncoder"%>

<%

String csMail = request.getParameter("csMail");
String csName = request.getParameter("csName");
String csPw = request.getParameter("csPw");
String gender = request.getParameter("gender");
String birth = request.getParameter("birth");
System.out.println(gender == null);
System.out.println(csName == "");
System.out.println(csPw == "");
System.out.println(birth == "");
System.out.println(csMail.equals(""));
// 이메일이 중복이아니면 true 중복이면 false 출력해줌
boolean checkMail = Customer.checkMail(csMail);
//System.out.println(checkMail);


if(checkMail == true && csMail != "" && csName != "" && csPw != "" && gender != null && birth != ""){
	Customer.insertCustomer(csMail, csPw, csName, birth, gender);
	response.sendRedirect("/shop/customer/loginForm.jsp");
} else{
	String errMsg = "중복된이메일입니다 다시입력해주세요" ;
	response.sendRedirect("/shop/customer/addCustomerForm.jsp?err="+URLEncoder.encode(errMsg,"utf-8"));
		
}



 


%>
