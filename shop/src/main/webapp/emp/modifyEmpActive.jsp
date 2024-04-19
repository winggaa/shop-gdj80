<%@page import="shop.dao.EmpDAO"%>
<%@page import="shop.dao.DBHelper"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.sql.*" %>
<%
	// 인증분기	 : 세션변수 이름 - loginEmp
	if(session.getAttribute("loginEmp") == null) {
	response.sendRedirect("/shop/emp/empLoginForm.jsp");
	return;
}

	// empList 에서 직원의 active 상태와 empId 를 받아옴
	String active = request.getParameter("active");
	String empId = request.getParameter("empId");
	
	// active 값이 on 일경우 off로
	// on일경우 off 로 바꿈.
	if(active.equals("ON")){
		active = "OFF";
	} else if(active.equals("OFF")){
		active = "ON";
	}
	// db값 바꾸는 메소드 받아온 id 검색후 active값 변경.
	EmpDAO.modifyEmpOnOff(active, empId);
	response.sendRedirect("/shop/emp/empList.jsp");

%>
