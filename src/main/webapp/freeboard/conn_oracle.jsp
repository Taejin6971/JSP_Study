<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*" %>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Oracle DB Connection</title>
</head>
<body>

	<%
		//변수 초기화     //JSP 블락내에서 주석 
		Connection conn = null;      
		String driver = "oracle.jdbc.driver.OracleDriver";
		String url = "jdbc:oracle:thin:@localhost:1521:XE"; 
			
		try {
			Class.forName(driver); 	//오라클 드라이버를 로드함 
			conn = DriverManager.getConnection (url, "C##HR2", "1234"); 

		}catch (Exception e) {
			e.printStackTrace(); 
		}

	%>

</body>
</html>