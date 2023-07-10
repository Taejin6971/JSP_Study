<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!-- DB의 값을 읽어와서 출력하는 페이지 : ResultSet 객체를 사용-->
<%@ page import = "java.sql.*, java.util.*" %>

<!-- DB Connection -->
<%@ include file = "../DB_Connection/db_conn_oracle.jsp" %>

<%
	// ResultSet rs 의 값을 저장하는 ArrayList 선언
	// ArrayList 는 컬렉션 : 동일한 자료형을 저장하고 무한정 늘어난다.
	ArrayList name = new ArrayList();
	ArrayList email = new ArrayList();
	ArrayList inputdate = new ArrayList();
	ArrayList subject = new ArrayList();
	ArrayList content = new ArrayList();
%>

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
	
	// rs의 각 필드의 값을 ArrayList에 저장
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
					// rs의 각 필드의 값을 ArrayList에 저장
					name.add(rs.getString("name"));
					email.add(rs.getString("email"));
					inputdate.add(rs.getString("inputdate"));
					subject.add(rs.getString("subject"));
					content.add(rs.getString("content"));
				} while (rs.next());
			} else {
				out.println("DB에 값이 존재하지 않습니다.");
			}
			
			// for 문을 사용해서 Array List에 저장된 내용을 출력
			for (int i = 0; i < name.size(); i++) {
			%>
			<tr>
			<td><%=name.get(i)%></td>
			<td><%=email.get(i)%></td>
			<td><%=inputdate.get(i)%></td>
			<td><%=subject.get(i)%></td>
			<td><%=content.get(i)%></td>
			</tr>
			<%
			}
			%>
		</table>
		<br><br>
	</div>
</body>
</html>