<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
 <!--  페이징 처리 부분 추가된 freeboard_list03.jsp -->   
    

<!-- 클래스 import, DB Connection 객체 -->
<%@ page import="java.sql.*,java.util.*" %> 
<%@ include file="conn_oracle.jsp" %>

<HTML>
<HEAD><TITLE>게시판</TITLE>
<link href="freeboard.css" rel="stylesheet" type="text/css">
<SCRIPT language="javascript">
 function check(){
  with(document.msgsearch){
   if(sval.value.length == 0){
    alert("검색어를 입력해 주세요!!");
    sval.focus();
    return false;
   }	
   document.msgsearch.submit();
  }
 }
 function rimgchg(p1,p2) {
  if (p2==1) 
   document.images[p1].src= "image/open.gif";
  else
   document.images[p1].src= "image/arrow.gif";
  }

 function imgchg(p1,p2) {
  if (p2==1) 
   document.images[p1].src= "image/open.gif";
  else
   document.images[p1].src= "image/close.gif";
 }
</SCRIPT>
</HEAD>
<BODY>



<P>
<P align=center><FONT color=#0000ff face=굴림 size=3><STRONG>자유 게시판</STRONG></FONT></P> 
<P>
<CENTER>
 <TABLE border=0 width=600 cellpadding=4 cellspacing=0>
  <tr align="center"> 
   <td colspan="5" height="1" bgcolor="#1F4F8F"></td>
  </tr>
  <tr align="center" bgcolor="#87E8FF"> 
   <td width="42" bgcolor="#DFEDFF"><font size="2">번호</font></td>
   <td width="340" bgcolor="#DFEDFF"><font size="2">제목</font></td>
   <td width="84" bgcolor="#DFEDFF"><font size="2">등록자</font></td>
   <td width="78" bgcolor="#DFEDFF"><font size="2">날짜</font></td>
   <td width="49" bgcolor="#DFEDFF"><font size="2">조회</font></td>
  </tr>
  <tr align="center"> 
   <td colspan="5" bgcolor="#1F4F8F" height="1"></td>
  </tr>

<!-- JSP 코드 블락  : DB의 레코드를 가져와서 루프 : 시작 -->
	<%
	
 	/* DB에서 값을 가져와서 Vector 켈렉션에 저장후 페이징 처리 */
 	
 	//Vector 변수 선언 
 	Vector name = new Vector(); 	//name 컬럼의 모든값을 저장하는 vector 
 	Vector inputdate = new Vector(); 
 	Vector email = new Vector();
 	Vector subject = new Vector();
 	Vector readcount = new Vector();
 	Vector step = new Vector();
 	Vector keyid = new Vector();		//DB의 id컬럼의 값을 저장하는 vector
	
	
	// 페이징을 처리할 변수 선언  <<<시작>>> 
	
	int where = 1; 			//현재 위치한 페이징 변수 
	
	//  where = Integer.parseInt(request.getParameter("where"));  
		
	int totalgroup = 0 ; 		//출력할 페이징의 총 그룹수  
	int maxpages = 10; 			//하단의 페이지 출력 부분에서 출력할 최대 페이지 갯수 
	int startpage = 1; 
	int endpage = startpage + maxpages -1 ; 
	int wheregroup = 1; 		//현재 위치한 페이징 그룹 
	
	//go  : get 방식으로 해당 페이지 번호로 이동 하도록 설정하는 변수 
		//freeboard_list03.jsp?go=3 
	//gogroup  : get 방식으로 해당 페이지 그룹으로 이동 하도록 
		//freeboard_list03.jsp?go=3&gogroup=2    
	
	//go 변수 를 넘겨 받아서 wheregroup, startpage, endpage 정보를 알아낼 수 있다. 
		//코드 블락
	if (request.getParameter("go") != null ){   // freeboard_list03.jsp?go=3
		where = Integer.parseInt(request.getParameter("go"));  // go 변수의 값을 where변수에 할당
		wheregroup = (where - 1) / maxpages + 1 ;  //현재 내가 속한 그룹을 알수 있다.
		startpage = (wheregroup - 1) * maxpages +1 ; 
		endpage = startpage + maxpages -1 ; 
	
		
	//gogroup 변수를 넘겨 받아서 startpage, endpage, where 의 정보를 알아낼 수 있다. 
		//코드 블락 
	}else if (request.getParameter("gogroup") != null){  //freeboard_list03.jsp?gogroup= 
		wheregroup = Integer.parseInt(request.getParameter("gogroup"));  //현재내가 위치한 그룹
		startpage = (wheregroup - 1) * maxpages +1 ; 
		where = startpage; 
		endpage = startpage + maxpages -1;  
	}
	
	int nextgroup = wheregroup +1 ; 
	int priorgroup = wheregroup -1 ; 
	
	int nextpage = where + 1 ;    // where : 현재 내가 위치한 페이지
	int priorpage = where -1 ; 
	int startrow = 0; 			//하나의 page에서 레코드 시작 번호 
	int endrow = 0; 			//하나의 page에서 레코드 마지막 번호 
	int maxrow = 20; 			//한페이지 내에 출력할 행의 갯수 (row, 행,레코드 갯수)
	int totalrows = 0; 			// DB에서 select 한 총 레코드 갯수 
	int totalpages = 0 ; 		// 총 페이지 갯수 
	
	// <<<페이징 처리할 변수 선언 끝>>>
	
	
	int id = 0 ; 	// DB의  id 컬럼의 값을 가져오는 변수 
	String em = null ; 	//DB에서 mail 주소를 가져와서 처리하는 변수 
		
		//SQL 쿼리를 보낼 객체 변수 선언 
		String sql = null; 
		Statement stmt = null; 
		ResultSet rs = null ; 
		
		//리스트 페이지에서 답변글 처리의 출력을 하기 위한 쿼리 
		sql = "select * from freeboard order by " ; 
		sql += "masterid desc, replaynum , step, id"; 
		
		
		stmt = conn.createStatement(); 
		rs = stmt.executeQuery(sql); 
		
		//rs의 값을 Vector에 저장 : 페이징 처리하기 위함. 
		
		if (!(rs.next())){	// rs의 값이 존재하지 않을때 
			out.println ("게시판에 올라온 글이 없습니다"); 
		}else {		// rs의 값이 존재 할때( 게시판의 글이 존재할때 )
			do {
			
			//정수 형으로 변환 필요: id , readcount, step 컬럼은 DB에서 값을 가져와서 정수형으로 변환 
			keyid.addElement(new Integer(rs.getString("id"))); 	
			name.addElement(rs.getString("name")); 
			email.addElement(rs.getString("email")); 
			String idate = rs.getString("inputdate").substring(0,8); 
			inputdate.addElement(idate); 
			subject.addElement(rs.getString("subject")); 
			readcount.addElement(new Integer(rs.getString("readcount"))); 
			step.addElement(new Integer(rs.getString("step"))); 
				
			} while  (rs.next()); 	
		}
		
		totalrows = name.size(); 		//DB에서 가져온 총 레코드 갯수 
		totalpages = (totalrows-1) / maxrow + 1; 	// 전체 페이지 갯수 출력 
		startrow = (where - 1) * maxrow ; 		//해당 페이지에서 Vector의 방번호 : 시작
		endrow = startrow + maxrow - 1 ; 		//해당 페이지에서 Vector의 방번호 : 마지막
		
		totalgroup = (totalpages -1) / maxpages + 1 ; 
			// 전체 페이지 그룹, 하단에 출력할 페이지 갯수(5개)의 그룹핑   
		
		
		//endrow 가 totalrows보다 크면 totalrows -1로 처리해야함.
		if ( endrow >= totalrows) {
			endrow = totalrows -1 ; 
		}
		if (endpage > totalpages){
			endpage = totalpages; 
		}
		
		
		
		// 페이징 변수 출력 
		/*
		out.println ( "<p/> 총 레코드 갯수 (totalrows : ) : " + totalrows + "<p/>" ); 
		out.println ( "<p/> 전체 페이지 수 (totalpage : ) : " + totalpages + "<p/>" ); 
		out.println ( "<p/> 시작 row 갯수 (startrow : ) : " + startrow + "<p/>" ); 
		out.println ( "<p/> 마지막 row 갯수 (endrow : ) : " + endrow + "<p/>" ); 
		*/
		  	// 프로그램 멈춤 
		
		

		
		//if (true) return;
		
		
	//행당 페이지를 처리하면서 해당 페이지에 대한 내용을 출력 (rs의 값을 vector에 저장했으므로 for )
	for ( int j = startrow ; j <= endrow ; j++){
	
	
	%>

  <tr>
  	<td> <%= keyid.elementAt(j) %> </td>
  	<td><a href="freeboard_read.jsp?id=<%= keyid.elementAt(j) %>&page=<%= where %>"> 
  			<%= subject.elementAt(j) %>  </a> </td>
  	<td> <%= name.elementAt(j) %></td>
  	<td> <%= inputdate.elementAt(j) %></td>
  	<td> <%= readcount.elementAt(j) %></td>
  </tr>
  
  <%
	}
  
  %>
  
  
<!-- JSP 코드 블락  : DB의 레코드를 가져와서 루프 : 끝  -->

 </TABLE>
 
 <!--  페이징 출력 부분 : [처음][이전] 1 2 3 4 5 [다음][마지막] -->
 
 <%

	//  [처음][이전]
	if (wheregroup > 1){ 	//현재 나의 그룹이 1 이상일때 처음
		out.println ("[<a href='freeboard_list03.jsp?gogroup=1'>처음</a>]");
		out.println ("[<a href='freeboard_list03.jsp?gogroup="+priorgroup +"'>이전</a>]");
	}else {			// 현재 나의 페이지 그룹이 1일때는 
		out.println ("[처음]"); 
		out.println ("[이전]"); 
	}

	//페이징 갯수를 출력 : 1 2 3 4 5 
	
	if (name.size() != 0 ) {		//name.size() : 총 레코드의 갯수 가 0이 아니라면  
		for ( int jj = startpage; jj <= endpage ; jj++){
			if (jj == where) {		//jj 가 자신의 페이지 번호라면 링크 없이 출력
				out.println ("["+jj+"]"); 
			}else {		//jj가 현재 자신의 페이지 번호가 아니라면 링크를 걸어서 출력
				out.println ("[<a href=freeboard_list03.jsp?go="+ jj + ">" +jj+ "</a>]");
			}
		}
	}
	
	// [다음][마지막]
	if (wheregroup < totalgroup ) {  //링크를 처리
		out.println ("[<A href=freeboard_list03.jsp?gogroup="+ nextgroup + ">다음</A>]"); 
		out.println ("[<A href=freeboard_list03.jsp?gogroup="+ totalgroup + ">마지막]</A>"); 
	}else {  // 마지막 페이지에 왔을때 링크를 해지 
		out.println ("[다음]"); 
		out.println ("[마지막]"); 
	}
	
	out.println("전체 글수 : " + totalrows); 
	
 %>
 

<FORM method="post" name="msgsearch" action="freeboard_search.jsp">
<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right width="241"> 
   <SELECT name=stype >
    <OPTION value=1 >이름 </OPTION>
    <OPTION value=2 >제목	 </OPTION>
    <OPTION value=3 >내용 </OPTION>
    <OPTION value=4 >이름+제목 </OPTION>
    <OPTION value=5 >이름+내용 </OPTION>
    <OPTION value=6 >제목+내용 </OPTION>
    <OPTION value=7 >이름+제목+내용 </OPTION>
   </SELECT>
  </TD>
  <TD width="127" align="center">
   <INPUT type=text size="17" name="sval" >
  </TD>
  <TD width="115">&nbsp;<a href="#" onClick="check();"><img src="image/serach.gif" border="0" align='absmiddle'></A></TD>
  <TD align=right valign=bottom width="117"><A href="freeboard_write.jsp"><img src="image/write.gif" border="0"></TD>
 </TR>
</TABLE>
</FORM>


</BODY>
</HTML>