<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.net.*" %>
<% %>
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

// 이미지파일 업로드 한거 저장하는 코드
Part part = request.getPart("goodsImg");
String originalName = part.getSubmittedFileName();

int dotIdx = originalName.lastIndexOf(".");
String exe = originalName.substring(dotIdx); // .png

UUID uuid = UUID.randomUUID();
String filename = uuid.toString().replace("-", "");
filename = filename + exe;

%>
<!--  Session 설정값 : 입력시 로그인 emp의 emp_id 값이 필요 -->
<%
	HashMap<String,Object> loginMember = (HashMap<String,Object>) (session.getAttribute("loginEmp"));
	String empId = (String)loginMember.get("empId");
	System.out.println((String)loginMember.get("empId"));
%>

<!-- Model Layer -->
<%

	Class.forName("org.mariadb.jdbc.Driver");
	ResultSet rs1 = null;
	Connection conn = null;
	PreparedStatement stmt1 = null; 
	conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", "root", "java1234");
	String sql1 = "INSERT INTO goods(category , emp_id, goods_title, filename ,goods_content, goods_price, goods_amount ) VALUES(?,?,?,?,?,?,?)";
	stmt1 = conn.prepareStatement(sql1);
	stmt1.setString(1, category);
	stmt1.setString(2,(String)loginMember.get("empId"));
	stmt1.setString(3, goodsTitle);
	stmt1.setString(4, filename);
	stmt1.setString(5, goodsContent);
	stmt1.setString(6, goodsPrice);
	stmt1.setString(7, goodsAmount);
	
	int row = stmt1.executeUpdate();
		if(row == 1){ //insert 성공하면 -> 파일업로드
			//part -> is -> os -> 빈파일
			// 1)
			InputStream is = part.getInputStream();
			// 3)+2 )
			String filePath = request.getServletContext().getRealPath("upload");
			File f = new File(filePath, filename); //빈파일
			OutputStream os = Files.newOutputStream(f.toPath()); // os + file
			is.transferTo(os);
			
			os.close();
			is.close();
		}
	
	response.sendRedirect("/shop/emp/goodsList.jsp");

		

%>
<!-- Controller Layer -->
<%
	
%>