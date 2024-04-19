<%@page import="shop.dao.GoodsDAO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import = "java.util.*" %>
<%@ page import = "java.sql.*" %>
<%@ page import="java.io.*" %>
<%@ page import="java.nio.file.*" %>
<%@ page import="java.net.*" %>
<% %>
<% 
	//로그인 인증분기 
	request.setCharacterEncoding("UTF-8");
	if(session.getAttribute("loginEmp") == null) {
		response.sendRedirect("/shop/emp/empLoginForm.jsp");
		return;
	}
%>

<%
	
	
	String category = request.getParameter("category");
	String goodsTitle   = request.getParameter("goodsTitle");
	String goodsPrice = request.getParameter("goodsPrice");
	String goodsAmount = request.getParameter ("goodsAmount");
	String goodsContent = request.getParameter  ("goodsContent");
	
	
	
	// 이미지파일 업로드 한거 저장하는 코드
	Part part = request.getPart("goodsImg");
	String originalName = part.getSubmittedFileName();
	
	
	// 확장자를 찾지못하면 -1 를 반환함
	String exe = null;
	int dotIdx = originalName.lastIndexOf(".");
	
	
	if(dotIdx != -1){
	exe = originalName.substring(dotIdx); // .png
	} 
	
	
	
	UUID uuid = UUID.randomUUID();
	String filename = uuid.toString().replace("-", "");
	filename = filename + exe;
	System.out.println(filename);
	// Session 설정값 : 입력시 로그인 emp의 emp_id 값이 필요해서 세션값에 들어있는 emp id값 불러옴. 
	HashMap<String,Object> loginMember = (HashMap<String,Object>) (session.getAttribute("loginEmp"));
	String empId = (String)loginMember.get("empId");
%>

<!-- Model Layer -->
<%	
		int row = 0;
		if(dotIdx == -1){
			filename = "default.jpg";
			System.out.println(filename);
		}

		if( category.equals("") || goodsTitle.equals("") || goodsPrice.equals("") 
		|| goodsAmount.equals("") || goodsContent.equals("")){
		
		response.sendRedirect("/shop/emp/addGoodsForm.jsp");
		}		
		
		else{
		row = GoodsDAO.addGoods(category, empId, goodsTitle, filename, goodsContent,(int) Integer.parseInt(goodsPrice),(int) Integer.parseInt(goodsAmount));
		}
		System.out.println(row);
		// 굿즈정보가 db에 들어가면 실행할 코드
		if(row == 1){ //insert 성공하면 -> 파일업로드
			//part -> is -> os -> 빈파일
			// 1)
			InputStream is = part.getInputStream();
			// 3)+2 )
			String filePath = request.getServletContext().getRealPath("upload");
			System.out.println(filePath);
			File f = new File(filePath, filename); //빈파일
			OutputStream os = Files.newOutputStream(f.toPath()); // os + file
			is.transferTo(os);
			
			os.close();
			is.close();
			response.sendRedirect("/shop/emp/goodsList.jsp");
			return;
			// 굿즈정보가 db에 들어가지 않았을경우
		}	
		
		

%>