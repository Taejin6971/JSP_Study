<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

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
		//SQL 쿼리를 보낼 객체 변수 선언 
		String sql = null; 
		Statement stmt = null; 
		ResultSet rs = null ; 
		
		sql = "select * from freeboard order by id desc" ; 
		
		stmt = conn.createStatement(); 
		rs = stmt.executeQuery(sql); 
		
		if (rs.next()){		//레코드가 존재하면 커서를 처음 레코드로 이동함.
			do {
	%>

  <tr>
  	<td><%= rs.getString("id") %> </td>
  	<td><a href="freeboard_read.jsp?id=<%= rs.getString("id") %>"> <%= rs.getString("subject") %> </a> </td>
  	<td><%= rs.getString("name") %> </td>
  	<td><%= rs.getString("inputdate").substring(0,8) %> </td>
  	<td><%= rs.getString("readcount") %> </td>
  </tr>
  
  <%
			}while(rs.next());
		} else {
			out.println("DB에 값이 존재하지 않습니다"); 
		}
  
  %>
  
  
<!-- JSP 코드 블락  : DB의 레코드를 가져와서 루프 : 끝  -->



 </TABLE>

<FORM method="post" name="msgsearch" action="freeboard_search.jsp">
<TABLE border=0 width=600 cellpadding=0 cellspacing=0>
 <TR>
  <TD align=right width="241"> 
   <SELECT name=stype >
    <OPTION value=1 >이름
    <OPTION value=2 >제목
    <OPTION value=3 >내용
    <OPTION value=4 >이름+제목
    <OPTION value=5 >이름+내용
    <OPTION value=6 >제목+내용
    <OPTION value=7 >이름+제목+내용
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