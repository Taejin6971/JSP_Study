<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- DB의 값을 읽어와서 출력하는 페이지 : ResultSet 객체를 사용-->
<%@ page import = "java.sql.*, java.util.*" %>

<!-- DB Connection -->
<%@ include file = "../DB_Connection/db_conn_oracle.jsp" %>

<%
	// DB를 접속해서 값을 읽어옴, Select 쿼리 (변수값 없이 DB에서 읽어오는 쿼리)
	String sql = null;
	PreparedStatement pstmt = null;
	
	ResultSet rs = null;	// DB에서 읽어온 레코드셋을 저장하는 객체
	
	// SQL 쿼리
	sql = "select * from guestboard order by inputdate desc";
	
	// PreparedStatement 객체 활성화
	pstmt = conn.prepareStatement(sql);
	
	// SQL 쿼리에 ? 가 없으므로 값을 넣지않고 바로 실행
			
	// rs는 select 한 결과 레코드셋을 담고 있다.
	rs = pstmt.executeQuery();		// sql 쿼리가 Select 문인 경우 : stmt.executeQuery(sql), rs
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>

	<style>
		div {
			width: 600px;
			margin: 0 auto;
		}
		
		table, tr, td {
			padding: 5px;
			border-collapse: collapse;
		}
	</style>
</head>
<body>
	<h1>DB에서 값을 읽어와서 출력하는 페이지</h1>
	
	<!-- DB의 내용을 출력하는 페이지 -->
	<div>
		<table width="600px" border="1px">
			<tr><th>이름</th><th>Email</th><th>날짜</th><th>제목</th><th>내용</th></tr>
			<%
			if (rs.next()) {
				do {
			%>
			<tr>
			<td><%=rs.getString(1)%></td>
			<td><%=rs.getString(2)%></td>
			<td><%=rs.getString(3)%></td>
			<td><%=rs.getString(4)%></td>
			<td><%=rs.getString(5)%></td>
			</tr>
			<%
				} while (rs.next());
			} else {
				out.println("DB에 값이 존재하지 않습니다.");
			}
			%>
		</table>
		<br><br>
	</div>
</body>
</html>