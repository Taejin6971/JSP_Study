<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>
    
<%
	Connection conn = null;		// Connection 객체 변수 초기화
	String driver = "com.mysql.jdbc.Driver";
	String url = "jdbc:mysql://localhost:3306/mydb";
		
	try {
		Class.forName(driver);		// 해당경로에 OracleDriver 클래스가 존재하는지 확인
		conn = DriverManager.getConnection(url, "root", "1234");
	} catch (Exception e) {
	}
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>