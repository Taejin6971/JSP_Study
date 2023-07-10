<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>MSSQL Connection</title>
</head>
<body>
	<%
		// 변수 초기화 
		Connection conn = null ; 
		String driver = "com.microsoft.sqlserver.jdbc.SQLServerDriver";
		String url = "jdbc:sqlserver://localhost:1433;DatabaseName=myDB;encrypt=false";
		//jdk11 을 지원하는 mssql 드라이버 버전(10.2이상)부터 기본적으로 암호화를 사용하도록 변경됨.
		
		Boolean connect = false ; 
		
		try {
			Class.forName(driver); 
			conn = DriverManager.getConnection(url, "sa","1234");

		}catch (Exception e) {
			e.printStackTrace(); 
		}

	%>

</body>
</html>