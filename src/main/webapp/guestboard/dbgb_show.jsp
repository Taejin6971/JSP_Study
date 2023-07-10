<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- DB의 값을 읽어와서 출력하는 페이지 : ResultSet 객체를 사용-->
<%@ page import = "java.sql.*, java.util.*" %>

<!-- DB Connection -->
<%@ include file = "../DB_Connection/db_conn_oracle.jsp" %>

<%
	// DB를 접속해서 값을 읽어옴, Select 쿼리 (변수값 없이 DB에서 읽어오는 쿼리)
	String sql = null;
	Statement stmt = null;
	
	ResultSet rs = null;	// DB에서 읽어온 레코드셋을 저장하는 객체
	
	// SQL 쿼리
	sql = "select * from guestboard order by inputdate desc";
	
	// statement 객체 활성화
	stmt = conn.createStatement();
	
	// rs는 select 한 결과 레코드셋을 담고 있다.
	rs = stmt.executeQuery(sql);		// sql 쿼리가 Select 문인 경우 : stmt.executeQuery(sql), rs
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
		<%
		// rs에 저장된 레코드 셋을 루플를 돌린다.
				// re.next() : 커서의 위치를 다음 레코드로 이동을 시킨다. rs.next가 존재하면 true, 존재하지않으면 false
					// 호출시 커서의 위치가 이동됨
					// re.getString("컬럼명");
		if (rs.next()) { // DB의 레코드가 존재할때 작동
			// out.println("DB의 값이 존재 합니다.");
			do {
		%>
		<table width="600px" border="1px">
			<tr><td colspan="2" align="center"><%=rs.getString("subject")%></td></tr>
			<tr><td>글쓴이 : <%=rs.getString("name")%></td><td>Email : <%=rs.getString("email")%></td></tr>
			<tr><td colspan="2" align="center"><%=rs.getString("inputdate")%></td></tr>
			<tr><td colspan="2" align="center"><%=rs.getString("content")%></td></tr>
		</table>
		<br><br>
		<%
			} while (rs.next());
		} else {
			out.println("DB의 레코드 값이 존재하지 않습니다.");
		}
		%>
	</div>
</body>
</html>