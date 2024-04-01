<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = java.sql.* %>
<%@ page import = java.net.* %>

<%
	
 	session.invalidate();
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
%>

