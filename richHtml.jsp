<%@ page language="java" import="java.util.*" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@include file="/context/mytags.jsp"%>
<!DOCTYPE html>
<html>
 <head>
 	<title>富文本</title>
    <t:base type="jquery,easyui,tools,DatePicker"></t:base>
    <script type="text/javascript" charset="utf-8" src="plug-in/ueditor/ueditor.config.js"></script>
	<script type="text/javascript" charset="utf-8" src="plug-in/ueditor/ueditor.all.js"></script>
	<script type="text/javascript" charset="utf-8" src="plug-in/ueditor/lang/zh-cn/zh-cn.js"></script>
	<link  href="plug-in/mobilepreview/plugin.css" media="all" rel="stylesheet">
	
 </head>
 <body style="overflow-y: scroll" scroll="yes" >
	 <t:formvalid formid="formobj" dialog="true" beforeSubmit="beformCommitSetContent" usePlugin="password" layout="div" action="richHtmlController.do?save">
	 		<input id="id" name="id" type="hidden" value="${richHtmlPage.id}">
			<fieldset class="step">
				<div class="form">
			      <label class="Validform_label">标题:</label>
			      <input class="inputxt" id="mainTitle" name="mainTitle" value="${richHtmlPage.mainTitle}" datatype="*">
			      <span class="Validform_checktip"></span>
			      <a style="cursor:pointer;" herf="javascript:void(0);" onclick="previewOnClick();">预览</a>
			    </div>
				<div class="form">
			      <label class="Validform_label">创建时间:</label>
			      <input class="Wdate" onClick="WdatePicker({dateFmt:'yyyy-MM-dd HH:mm:ss'})"  style="width: 150px" id="createTime" name="createTime" 
						     value="<fmt:formatDate value='${richHtmlPage.createTime}' type="date" pattern="yyyy-MM-dd HH:mm:ss"/>" datatype="*">
			      <span class="Validform_checktip"></span>
			    </div>
			    <div class="form">
				      <label class="Validform_label">类型:</label>
				      <select id="seeType" name="seeType">
							<option value="0" <c:if test="${richHtmlPage.seeType eq '0' }">selected="selected"</c:if>>默认</option>
							<option value="1" <c:if test="${richHtmlPage.seeType eq '1' }">selected="selected"</c:if>>小程序</option>
							<option value="2" <c:if test="${richHtmlPage.seeType eq '2' }">selected="selected"</c:if>>web课表</option>
							<option value="3" <c:if test="${richHtmlPage.seeType eq '3' }">selected="selected"</c:if>>活动</option>
							<option value="4" <c:if test="${richHtmlPage.seeType eq '4' }">selected="selected"</c:if>>导师</option>
							<option value="5" <c:if test="${richHtmlPage.seeType eq '5' }">selected="selected"</c:if>>微课文章</option>
							<option value="6" <c:if test="${richHtmlPage.seeType eq '6' }">selected="selected"</c:if>>Boss内参</option>
							<option value="7" <c:if test="${richHtmlPage.seeType eq '7' }">selected="selected"</c:if>>商学院</option>
					 </select>
				</div>
			    <div class="form">
			    	<input  id="rcontent" name="content" type="hidden"  ignore="ignore" datatype="*">
			    	<script id="editor" type="text/plain" style="width:100%;height:600px;"></script>
			    </div>
		    </fieldset>
	</t:formvalid>
	
	
	<div class="preview-box">
		<div class="mask">
		</div>
		<div class="showbox">
				<iframe  class="preview-iframe">
				</iframe>
		</div>
		<div class="actionbar" >
			<select class="device" name="device" id="device">
		 		<option value="320*480">iphone4</option>
		 		<option value="320*568">iphone5</option>
		 		<option value="375*667">iphone 6</option>
				<option value="414*736">iphone 6 plus</option>
		 	</select>
	 	</div>
	 	<div class="qrcode">
	 		<img id="qrcodeimg" src="none" />
	 	</div>
	</div>
	
	
</body>
<script type="text/javascript">
    //实例化编辑器
    //建议使用工厂方法getEditor创建和引用编辑器实例，如果在某个闭包下引用该编辑器，直接调用UE.getEditor('editor')就能拿到相关的实例
    var ue = UE.getEditor('editor');
   	
    
    
    function PreViewPlugin(){
    	function scrollbarwidth()
		{
			// Create the measurement node
			var scrollDiv = document.createElement("div");
			scrollDiv.className = "scrollbar-measure";
			document.body.appendChild(scrollDiv);
			// Get the scrollbar width
			var scrollbarWidth = scrollDiv.offsetWidth - scrollDiv.clientWidth;
			console.warn(scrollbarWidth); // Mac:  15
			// Delete the DIV 
			document.body.removeChild(scrollDiv);
			return scrollbarWidth;
		}
    	this.previewUrl;
		this.init=function(){
			$("#device").change(function(){
				var  scrollWidth=+scrollbarwidth();
				console.log(scrollWidth);
				var devicesize=$(this).val().split("*");
				var width=parseInt(devicesize[0]);
				var height=devicesize[1];
				var widthAll=scrollWidth+width;
				$(".preview-iframe").css("width",widthAll+"px");
				$(".preview-iframe").css("height",height+"px");
			});
			$(".preview-iframe").load(function(){
				$("#device").trigger("change");
			});
			$("#previewBtn").click(function(){
				openPreview();
			});
			$(".mask").click(function(){
				$(".preview-box").hide();
			});
		}
	    this.openPreview=function(){
	    	//alert(this.previewUrl);
	    	var imgpath="http://qr.liantu.com/api.php?text="+encodeURIComponent(this.previewUrl);
	    	$("#qrcodeimg").attr("src",imgpath);
	    	//alert(imgpath);
	    	$(".preview-iframe").attr("src",this.previewUrl);
			$(".preview-box").show();
	    }
	    this.init();
    }
    

    var plugin;
    $(this).ready(function(){  
        var ue = UE.getEditor('editor');  
        ue.ready(function() {//编辑器初始化完成再赋值  
        	  if ('null'=='${richHtmlPage.id}'||''=='${richHtmlPage.id}') {
        		  
			  }else{
				  getRichHtmlContent('${richHtmlPage.id}');
			}
        }); 
		plugin=new PreViewPlugin();
    });
	
 	function previewOnClick(){
 		var currentContent=	ue.getContent();
 		$.post("richHtmlController.do?previewHtml", {
			content:currentContent,
		}, function(data) {
			var obj = eval(data);
			plugin.previewUrl=obj.obj;//"http://www.baidu.com";
			plugin.openPreview();
		}, "json");
 	}
    
    function getRichHtmlContent(richHtmlId) {
    	$.post("richHtmlController.do?getRichHtml", {
			id:richHtmlId,
		}, function(data) {
			var obj = eval(data);
			if (obj.success) {
	        	  UE.getEditor('editor').setContent(obj.obj.content, false);
			} else {
				alert(obj.msg);
			}
		}, "json");
    }
    
    function beformCommitSetContent(){
 		$('#rcontent').val(ue.getContent());
 	}
    
   
    
</script>

 