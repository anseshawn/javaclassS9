<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="ctp" value="${pageContext.request.contextPath}"/> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 - 이메일 보내기</title>
	<jsp:include page="/WEB-INF/views/include/admin_header.jsp" />
	<jsp:include page="/WEB-INF/views/include/bs4.jsp" />
	<jsp:include page="/WEB-INF/views/include/scripts.jsp" />
	<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
  <script type="text/javascript">
    google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(drawChart);

    function drawChart() {

      var data = google.visualization.arrayToDataTable([
        ['${vo.xtitle}', '${vo.legend1}'],
        <c:forEach var="i" begin="0" end="5" varStatus="st">
	        ['${reasonDetails[i]}', ${reasonCnts[i]}],
        </c:forEach>
      ]);

      var options = {
        title: '${vo.title}'
      };

      var chart = new google.visualization.PieChart(document.getElementById('piechart'));

      chart.draw(data, options);
    }
    
    google.charts.load('current', {'packages':['line']});
    google.charts.setOnLoadCallback(drawChart2);

	  function drawChart2() {
	
	    var joinData = new google.visualization.DataTable();
	    joinData.addColumn('string', '${lineVO.xtitle}');
	    joinData.addColumn('number', '가입 회원(명)');
	
	    joinData.addRows([
	      <c:forEach var="i" begin="0" end="${size-1}" varStatus="st">
	    		['${joinDates[i]}',${joinCnts[i]}], // <c:if test="${!st.last}">,</c:if>
	    	</c:forEach>
	    ]);
	
	    var options = {
	      chart: {
	        title: '${lineVO.title}',
	        subtitle: '${lineVO.subTitle}'
	      },
	      width: 900,
	      height: 500,
	      axes: {
	        x: {
	          0: {side: 'bottom'}
	        }
	      },
	      vAxis: {
	    		viewWindow: {
	    			min: 0 // y축 최솟값을 0으로 설정
	    		}
	    	}
	    };
	    var joinChart = new google.charts.Line(document.getElementById('line_top_x'));
	    joinChart.draw(joinData, google.charts.Line.convertOptions(options));
	  }
  </script>
</head>
<body>
<jsp:include page="/WEB-INF/views/include/admin_aside.jsp" />
<p><br/></p>
<div class="container">
	<div class="text-center"><h2>사이트 통계</h2></div>
	<div class="divider2 mx-auto my-4 text-center" style="width:70%;"></div>
	<div class="row justify-content-center mb-3">
		<div class="col-md-10 col-md-offset-2">
			<div id="line_top_x"></div>
		</div>
	</div>
	<hr/>
	<div class="row justify-content-center mb-3">
		<div class="col-md-10 col-md-offset-2">
			<div id="piechart" style="width: 900px; height: 500px;"></div>
		</div>
	</div>
</div>
<p><br/></p>
</body>
</html>