<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title></title>
</head>
<body>

<form method="post" action="addCustomerAction.jsp">
이메일
<input type="email" name="csMail">
<br>
이름
<input type="text" name="csName">
<br>
패스워드
<input type="password" name="csPw">
<br>
 
<input type="radio" value="남" name="gender">남
<input type="radio" value="여" name="gender">여
<br>
생년월일
<input type="date" name="birth">
<button type="submit">제출</button>

</form>
</body>
</html>