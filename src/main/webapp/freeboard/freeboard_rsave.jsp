<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ page import = "java.sql.*, java.util.*, java.text.*" %>    
<% request.setCharacterEncoding("UTF-8");  %>
<%@ include file = "conn_oracle.jsp" %>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>

<%

	//Form 에서 넘겨주는 변수를 받어서 새로운 변수에 담기 
	String na = request.getParameter("name"); 
	String em = request.getParameter("email");
	String sub = request.getParameter("subject");
	String cont = request.getParameter("content");
	String pw = request.getParameter("password");
	//답변글을 처리하기 위한 변수 3개 : mid, rnum, step 
	int mid = Integer.parseInt(request.getParameter("mid")); 
		//DB : masterid : 동일 글의 그룹핑 
				// 처음글, 답변글일때 
	int rnum= Integer.parseInt(request.getParameter("rnum")); 
		//DB : replaynum
			//처음글 : 0   , 답변글 : 1,  답변글의답변 : 2, 답변글의 답변글의 답변 : 3
	int step= Integer.parseInt(request.getParameter("step"));
		//DB : step  : 글의 깊이를 처리하는 컬럼 
			// 답변글에대한 순번 : 0,1,2
	
	//날짜를 한국 포멧에 맞도록 변환해서 저장함. 
	java.util.Date yymmdd = new java.util.Date();
	SimpleDateFormat myformat = new SimpleDateFormat("yy-MM-d h:m a"); 
	String ymd = myformat.format(yymmdd); 
	
	
	int id = 0 ;    // DB의 ID 컬럼의 최대 값을 가져와서 +1 해서 저장함. 
	
	
	//폼에서 넘어온 변수가 잘 들어오는지 출력 
	
	/* 
	out.println (na + "<p/>"); 
	out.println (em + "<p/>");
	out.println (sub + "<p/>");
	out.println (cont + "<p/>");
	out.println (pw + "<p/>");
	out.println (mid + "<p/>");
	out.println (rnum + "<p/>");
	out.println (step + "<p/>");
	out.println (yymmdd + "<p/>");
	out.println (ymd + "<p/>");
	if (true) return; 
	*/

	//DB에 저장할 쿼리 
	String sql = null; 
	Statement stmt = null; 
	PreparedStatement pstmt = null; 
	ResultSet rs = null;
	
	//글을 넣기 위해서 DB의 ID의 Max 값을 가져온후 + 1 으로 처리 

	sql ="select max(id) from freeboard"; 
	stmt = conn.createStatement(); 
	rs = stmt.executeQuery(sql); 
	
	if ( !(rs.next())){			//테이블에 저장된 레코드가 없다. (처음글 작성)
		id = 1 ; 
	} else {	//레코드가 존재할때 (최대값을 가지고 옴)
		id = rs.getInt(1) + 1 ; 
	}
	
	//out.println (id); 
	
	//답변 글이므로 step 값을 + 1
	//step : 글의 깊이를 처리하는 컬럼 
		//처음글 : 0 , 답변글 : 1, 답변의 답변 : 2 
	step +=1 ; 		//step = step + 1; 
	
	if ( step == 1 ) {
		sql = "select max(replaynum) from freeboard where masterid = " + mid ; 
		rs = stmt.executeQuery(sql); 
		
		if (!(rs.next())){
			rnum = 1; 
		}else {
			rnum = rs.getInt(1)+1 ; 
		}
	}
	
	//모든 변수가 처리된 내용을 DB에 저장 함 
	
	//Statement 객체로 처리 
	sql = "insert into freeboard (id, name, password, email,subject, ";
	sql += "content, inputdate, masterid, readcount, replaynum, step) ";
	sql += "values (" + id + ", '" + na + "','" + pw + "','" + em  ;
	sql += "', '" + sub + "','" + cont + "','"+ ymd + "'," + mid ; 
	sql += ",0," + rnum + ","+ step + ")";
	
	 // out.println (sql); 
	
	//
	int result = 0 ;   // 0 : insert 실패 , 1 : insert 성공  
	result = stmt.executeUpdate(sql); 
	
	/* 
	if ( result >= 1){
		out.println ("DB 에 Insert 가 잘 되었습니다. ");
	} else {
		out.println ("DB 에 Insert 가 실패 되었습니다 "); 
	}
	*/ 
	
	
	//PreparedStatement 처리 

	//DB에 잘 저장후 freeboard_list03.jsp 페이지로 이동 , go 변수에 페이지 번호를 넣어서이동 
	response.sendRedirect("freeboard_list03.jsp?go="+ request.getParameter("page")); 


%>

</body>
</html>