<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import="java.sql.*" %>
    
<%
	Connection conn = null;		// Connection 객체 변수 초기화
	String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
	String url = "jdbc:sqlserver://localhost:1433;DatabaseName=myDB;encrypt=false";
		
	try {
		Class.forName(driver);		// 해당경로에 OracleDriver 클래스가 존재하는지 확인
		conn = DriverManager.getConnection(url, "sa", "1234");
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