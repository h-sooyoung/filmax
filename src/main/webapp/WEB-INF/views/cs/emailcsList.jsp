<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<script src="/resources/js/jquery-3.6.1.min.js"></script>

<script>
	$(function(){
		$("#answerNum").change(function(){
			var hrefLink = "/cs/emailcsList?answerNum="+$("#answerNum").val();
			location.href=hrefLink;
		});
		$("#orderNum").change(function(){
			var hrefLink = "/cs/emailcsList?answerNum="+${currAnswer}+"&orderNum="+$("#orderNum").val();
			location.href=hrefLink;
		});
		//날짜 검색 유효성 검사
		$("#dateSearch").submit(function(){
			if($("#startDate").val() == "") {
				alert("날짜를 선택해주세요");
				$("#startDate").focus();
				return false;
			}
			if($("#endDate").val() == "") {
				alert("날짜를 선택해주세요");
				$("#endDate").focus();
				return false;
			}	
		});
		//검색 유효성 검사
		$("#searchForm").submit(function(){
			if($("#cValue").val() == "") {
				alert("검색할 단어를 입력해주세요");
				$("#cValue").focus();
				return false;
			}	
		});
	});
</script>

<h1>이메일 문의</h1>
<%--
	이메일 문의 리스트
	정렬 항목 최신순 작성순 / 답변 한 거 안 한 거 select / 타입 select
	
	테이블 열
	글번호 타입 제목 
	
	검색 타입 / 제목, 내용, 문의자명, 휴대폰번호, 이메일 /

--%>
<%-- 답변 여부 select --%>
<select id="answerNum">
	<option>답변여부 선택</option>
	<option value="0">미답변</option>
	<option value="1">답변완료</option>
	<option value="2">전체</option>
</select>

<%-- 정렬 순서 select --%>
<select id="orderNum">
	<option>정렬 선택</option>
	<option value="0">최신순</option>
	<option value="1">작성순</option>
</select>

<%-- 답변 미완료 수 --%>
전체 미완료 답변: <b>${countNotAnswered} 건</b>
<%-- 날짜 검색 --%>
<form id="dateSearch" action="/cs/emailcsDateSearch" method="get">
	<input type="date" id="startDate" name="startDate"/> ~
	<input type="date" id="endDate" name="endDate"/>
	<input type="hidden" name="dateSearch" value="1"/>
	<input type="submit" value="검색"/>
</form>
<%-- 리스트 --%>
<table class="table">
	<tr>
		<th>#</th><th>유형</th><th>제목</th><th>문의자명</th><th>등록일</th><th>답변여부</th>
	</tr>
	<c:forEach var="emailcsDTO" items="${emailList}">
		<tr>
			<td>
				${emailcsDTO.emailcs_seq}
			</td>
			<td>
				${emailcsDTO.etypeName}
			</td>
			<td>
				<a href="/cs/emailcsRead?num=${emailcsDTO.emailcs_seq}">
					${emailcsDTO.title}
				</a>
			</td>
			<td>
				${emailcsDTO.name}
			</td>
			<td>
				<fmt:formatDate value="${emailcsDTO.reg}" type="date"/>
			</td>
			<td>
				<c:choose>
					<c:when test="${emailcsDTO.isanswered == 0}">
						<font color="red">미완료</font>
					</c:when>
					<c:otherwise>
						완료
					</c:otherwise>
				</c:choose>
				
			</td>
		</tr>
	</c:forEach>
</table>
<%-- 페이지 이동 --%>
<center>
	<c:if test="${currPage > 1}">
		<a href="/cs/emailcsList?pageNum=${currPage-1}">[이전]</a>
	</c:if>
	<c:forEach begin="1" end="${pageCount}" step="1" var="pageIndex">
		<a href="/cs/emailcsList?pageNum=${pageIndex}">${pageIndex}</a>
	</c:forEach>
	<c:if test="${currPage < pageCount}">
		<a href="/cs/emailcsList?pageNum=${currPage+1}">[다음]</a>
	</c:if>
</center>
<%-- 검색창 --%>
<form id="searchForm" method="get" action="/cs/emailcsSearch">
	<select id="cName" name="cName">
		<option value="content">내용</option>
		<option value="title">제목</option>
		<option value="name">문의자명</option>
		<option value="phone">휴대폰번호</option>
		<option value="email">이메일</option>
	</select>
	<input type="text" id="cValue" name="cValue"/>
	<input type="submit" value="검색"/>
</form>
