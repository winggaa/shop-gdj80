<%@page import="shop.dao.Customer"%>
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
// loginForm에서 id와 pw 받아옴
String csId = request.getParameter("csId");
String csPw = request.getParameter("csPw");
//System.out.println(csId);
//System.out.println(csPw);

	HashMap<String,Object> loginCs = Customer.csLogin(csId, csPw);
	HashMap<String,Object> m = new HashMap<String,Object>();
	System.out.println(loginCs);
	if(loginCs == null){
	
		System.out.println("로그인실패");
		String errMsg =  URLEncoder.encode("아이디와 비밀번호가 잘못되었습니다","utf-8");
		response.sendRedirect("/shop/customer/loginForm.jsp?errMsg="+errMsg); // 자동으로 로그인페이지로 넘어감	
	}	else{
			session.setAttribute("loginCs", loginCs);
			m = (HashMap<String, Object>)(session.getAttribute("loginCs"));
			System.out.println((String) (m.get("csId"))); //
			System.out.println((String) (m.get("csName"))); // 
			System.out.println((String) (m.get("csGender"))); //
			System.out.println((String) (m.get("birth"))); //
			response.sendRedirect("/shop/customer/customerGoodsList.jsp");
		}


	

%>
