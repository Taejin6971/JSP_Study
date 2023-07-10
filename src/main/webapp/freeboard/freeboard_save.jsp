<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!--  필요한 라이브러리 Import -->
<%@ page import = "java.sql.*,java.util.*,java.text.*" %>
<!-- DB include -->
<%@ include file ="conn_oracle.jsp" %>
<!-- form 에서 넘어오는 값의 한글 처리  -->
<% request.setCharacterEncoding("UTF-8"); %>

<!-- form에서 넘어오는 데이터는 모두 String 으로 넘온다. 
	Integer.perseInt() 
	Double.perseDouble()
 -->
 
 <!-- form에서 넘어오는 변수의 값을 받아서 새로운 변수에 할당  -->
 <%
 	/*  */
 	 String na = request.getParameter("name"); 
	 String em = request.getParameter("email"); 
	 String sub = request.getParameter("subject"); 
	 String cont = request.getParameter("content"); 
	 String pw = request.getParameter("password"); 
	 
	 int id = 1; 	//id에 처음 값을 할당 할때 기본값으로 1을 할당. 
	 				//다음부터는 테이블의 id 컬럼에서 Max 값을 가져와서 +1해서 처리 
 
 	//날짜 처리 
 	java.util.Date yymmdd = new java.util.Date(); 
	//out.println(yymmdd); 		//Thu Jan 12 11:16:18 KST 2023
	SimpleDateFormat myformat = new SimpleDateFormat("yy-MM-d h:m a"); 
	String ymd = myformat.format(yymmdd); 
	//out.println(ymd); 		//23-01-12 11:13 오전
	
	//DB에 값을 처리할 변수 선언 : Connection (conn) <== Include 되어 있음. 
	String sql = null; 
	Statement stmt = null; 
	ResultSet rs = null;       //id 컬럼의 최대값을 select 
	
	
	try {
	//DB에서 값을 처리 
	
	
	stmt = conn.createStatement(); 
	sql = "select max(id) from freeboard"; 	//id : Primary Kety 
	
	rs = stmt.executeQuery(sql); 
	
	//rs.next(); 
	
	//out.println(rs.getInt(1) + "<p/>"); 
	
	//if (true) return; 
	
	//테이블의 id 컬럼의 값을 적용 : 최대 값을 가져와서 + 1 
	if (!(rs.next())){	//테이블의 값이 존재하지 않는 경우 
		id =  1; 
	}else {			//테이블의 값이 존재 하는 경우 
		id = rs.getInt(1) + 1 ; 		
	}
	
	//Statment 객체는 변수값 을 처리하는 것이 복잡하다. PareparedStatement 를 사용한다. 
	//폼에서 넘겨받은 값을 DB에 insert 하는 쿼리 (주의 : masterid : id컬럼에 들어오는 값으로 처리해야함)
	sql = "insert into freeboard (id, name, password, email, "; 
	sql += "subject,content, inputdate, masterid,readcount,replaynum,step ) " ;		
	sql += "values ( " + id + " , '" + na + "','"+ pw + "', '" + em +"', '" + sub +"', '" + cont +"', " ;
	sql += "'" + ymd + "', " +  id + "," + "0 , 0 , 0)";
	
	//out.println (sql); 
	//if (true) return ; 			//프로그램을 중지 시킴. 디버깅할때 사용함. 
	
	stmt.executeUpdate(sql);  //DB 저장 완료 , commit 을 자동으로 처리 
	
	}catch (Exception e) {
		out.println("예상치 못한 오류가 발생했습니다. <p/>" ); 
		out.println("고객 센터 : 02-1111-1111 <p/>" ); 
		// e.printStackTrace();
		
	}finally {
		if ( conn != null) conn.close(); 
		if ( stmt != null) stmt.close();
		if ( rs != null) rs.close(); 
	}
	// Try catch 블락으로 프로그램이 종료 되지 않도록 처리후 객체 제거 
 %>
 
 <!--  
 	페이지 이동 : 
 		response.sendRedirect : 클라이언트에서 페이지를 재요청  : URL 주소가 바뀜
 		forward : 서버에서 페이지를 이동 : URL 주소가 바뀌지 않는다. 
 
  -->
 
 <% // response.sendRedirect("freeboard_list.jsp"); %>
 
 
 <jsp:forward page = "freeboard_list.jsp" />



<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

</body>
</html>