package manager
{
	import com.YFFramework.air.FileUtil;
	
	import flash.filesystem.File;
	import flash.net.dns.SRVRecord;
	
	import yf2d.utils.Color;
	
	///解析 cocostudio 2.X 版本  json 数据
	public class FileManager
	{
		
		/** cocostudio  json  数据类型
		 */		
		
		//list
		
		public static const Type_Image:String = "ImageViewObjectData";
		
		public static const Type_Sprite:String = "SpriteObjectData";

		
		
		public static const Type_Button :String= "ButtonObjectData";
		
		public static const Type_Label:String = "TextObjectData";  // 多行文本
		
		public static const Type_Panel:String = "PanelObjectData";
		
		public static const Type_ProgressBar:String = "LoadingBarObjectData";
		
		public static const Type_TextFiled :String= "TextFieldObjectData";  //单行文本
		
		public static const Type_ScrollView :String= "ScrollViewObjectData"; ///滚动
		
		public static const Type_List:String = "ListViewObjectData";

		
		
		
		
		
		
		
		public static const Tab:String  = "	";
		
		public static const Space:String  = " ";
		
		public static const NextLine:String  = "\r";

		

		public function FileManager()
		{
		}
		
		//获取正确的类名  首字母大写
		public static function getRealFilename(fileName:String):String
		{
			var str:String = fileName;
			str = str.substr(1);
			var first:String = fileName.charAt(0);
			first = first.toLocaleUpperCase();
			str = first + str ;
			return str
		}

		
		//创建 js  ui文件 jsonData cocostudio json  fileName  文件名  dir  存储目录
		public static function CreateJS(jsonData:Object,fileName:String,dir:File):void
		{
			var fileName :String = getRealFilename(fileName);
			
			var  totalStr  :String ="// create by yefeng UIEditor "+ NextLine;
			totalStr +="(function()" + NextLine + "{" + NextLine;  //总的字符串
			

			
			var content :Object= jsonData.Content.Content.ObjectData;
			var children:Array = content.Children;
			var len :int =children.length;
			
			var rootSize:Object = content.Size

			totalStr += Tab + "var "+fileName+" = Game."+fileName+" = function()"+NextLine;
			totalStr += Tab + "{"+NextLine;
			totalStr += Tab +Tab + "Game.AbsUIEditorView.call(this);"+NextLine;
			totalStr += Tab +Tab + "this.init()"+NextLine;
			totalStr += Tab +"}"+NextLine;
			totalStr += Tab +"YF2d.extends("+fileName+",Game.AbsUIEditorView);"+NextLine;
				
			totalStr += Tab +fileName+".prototype.init = function()"+NextLine;
			totalStr += Tab + "{"+NextLine;
			totalStr += Tab +Tab +"this.setSize("+rootSize.X+","+rootSize.Y+");"+NextLine;
			
			var rootParentStr:String = "this";
			//遍历所有子节点
			for (var i:int = 0;i!=len;++i	)  ///处理子对象 ， 子多谢都是处于根容器下 这个时候  rooSize.y = 根容器size 的Y
			{
				var objectData :Object = children[i];
				
				totalStr = handleObject(objectData,rootParentStr,totalStr,rootSize.Y,"addChild");
				
			}
			
			totalStr += Tab + "}"+NextLine;
			
			
			//基类已经实现了该功能
//			totalStr += Tab +fileName+".prototype.getChildByName = function(name)"+NextLine;
//			totalStr += Tab + "{"+NextLine;
//			totalStr += Tab + Tab +'return this["__"+name] ;'+NextLine;
//			totalStr += Tab + "}"+NextLine;
			
			totalStr += NextLine+NextLine;
			totalStr += "})();";
			
			//生存文件
			FileUtil.createFile(dir,fileName+".js",totalStr);
			
		}
		
		
		//objectData是要解析的对象  objectDataParent 是  其父容器 对应的字符串名    totalStr是 解析的总的字符串
		public static function handleObject(objectData:Object,objectDataParent:String,totalStr:String,rootH:int,parentAddStr:String):String
		{
			
			var addPropObj:Object = handleObjectDataProp(objectData,totalStr,rootH,objectDataParent,parentAddStr);
			var tagName :String = addPropObj.tagName
			var addChildStr :String = addPropObj.addChildStr
			totalStr = addPropObj.totalStr;
			if(objectData.Children) //如果有子对象   处理子对象 ， 子多谢都是处于非根容器下 这个时候  rooSize.y =0
			{
				var len:int = objectData.Children.length;
				for (var i:int = 0;i!=len;++i	)
				{
					var childObjectData :Object= objectData.Children[i];
					totalStr =handleObject(childObjectData,tagName,totalStr,objectData.Size.Y,addChildStr); //处理子对象 ， 
					
				}

			}
			return totalStr;
		}

		//处理 objectData 所有的属性   返回 该对象的 具体代码
		public static function handleObjectDataProp(objectData:Object,totalStr:String,rootH:int,objectDataParent:String,parentAddStr:String):Object
		{
			
//			var uiDirStr:String ="Game.URLTool.getUIModuleDir()";
			
			
			var tagName:String  = "this.__"+objectData.Name  //objectData.Tag;
			
			var addChildStr:String ="addChild"; //addItem			
			var labelColor:String;
			switch(objectData.ctype)
			{
				case Type_Image:
				case Type_Sprite:
					totalStr += Tab +Tab + tagName+" = new YFFramework.YFImage();"+NextLine;
					addChildStr = "addChild";
					//只读取正常状态的图片
					var imagePath:String = objectData.FileData.Path;
					totalStr += Tab +Tab + tagName+'.init(Game.URLTool.getUIModuleDir()+"'+imagePath+'");'+NextLine;
					break;

				case Type_Button:
					totalStr += Tab +Tab + tagName+" = new YFFramework.YFButton();"+NextLine;
					addChildStr = "addChild";
					//只读取正常状态的图片
					var btnPath:String = objectData.NormalFileData.Path;
					totalStr += Tab +Tab + tagName+'.setSkin(Game.URLTool.getUIModuleDir()+"'+btnPath+'");'+NextLine;
					break;
				case Type_Label:
					totalStr += Tab +Tab + tagName+" = new YF2d.TextView();"+NextLine;
					addChildStr = "addChild";
					// FontSize  CColor()
					labelColor = "#FFFFFF";
					if( objectData.CColor.R==null)  objectData.CColor.R= 255
					if( objectData.CColor.G==null)  objectData.CColor.G= 255
					if( objectData.CColor.B==null)  objectData.CColor.B= 255
						
					labelColor ="#"+ Color.rgb(objectData.CColor.R,objectData.CColor.G,objectData.CColor.B).toString(16);
					
					labelColor = '"'+labelColor+'"';
					
					totalStr += Tab +Tab + tagName+".setStrokeStyle("+'"#000000"'+");"+NextLine;
					totalStr += Tab + Tab +tagName+".setTextStyle("+labelColor+");"+NextLine;
					totalStr += Tab + Tab +tagName+".setTextSize("+objectData.FontSize+");"+NextLine;
					totalStr += Tab + Tab +tagName+".setText('"+objectData.LabelText+"');"+NextLine;
					break;
				case Type_Panel:
					totalStr += Tab +Tab + tagName+" = new YFFramework.AbsBorderView();"+NextLine;
					addChildStr = "addChild";
					
					break;
				case Type_ProgressBar:
					addChildStr = "addChild";
					var progressInfo:int = 100;
					if(objectData.ProgressInfo!=null) progressInfo = objectData.ProgressInfo;
					totalStr += Tab +Tab + tagName+" = new YFFramework.YFProgressBar();"+NextLine;  //ProgressInfo
					var url:String = objectData.ImageFileData.Path;
					totalStr += Tab + Tab +tagName+".setSkin(Game.URLTool.getUIModuleDir()+'"+url+"',Game.URLTool.getUIModuleDir()+'"+url+"');"+NextLine;
					totalStr += Tab + Tab +tagName+".setPercent("+progressInfo+");"+NextLine;
					break;
				case Type_TextFiled:
					totalStr += Tab +Tab + tagName+" = new YF2d.TextField();"+NextLine;
					addChildStr = "addChild";
					// FontSize  CColor()
					labelColor = "#FFFFFF";
					var myColor:Object ={}
					if( objectData.CColor.R==null)  objectData.CColor.R= 255
					if( objectData.CColor.G==null)  objectData.CColor.G= 255
					if( objectData.CColor.B==null)  objectData.CColor.B= 255
					
					labelColor ="#"+ Color.rgb(objectData.CColor.R,objectData.CColor.G,objectData.CColor.B).toString(16);

					labelColor = '"'+labelColor+'"';
					
					totalStr += Tab +Tab + tagName+".setStrokeStyle("+'"#000000"'+");"+NextLine;
					totalStr += Tab + Tab +tagName+".setTextStyle("+labelColor+");"+NextLine;
					totalStr += Tab + Tab +tagName+".setTextSize("+objectData.FontSize+");"+NextLine;
					totalStr += Tab +Tab + tagName+".setText('"+objectData.LabelText+"');"+NextLine;

					break;
				case Type_List:
					totalStr += Tab +Tab + tagName+" = new YFFramework.YFList("+objectData.Size.X+","+objectData.Size.Y+");"+NextLine;
					addChildStr ="addItem"
					break;
				case Type_ScrollView:
					totalStr += Tab +Tab + tagName+" = new YFFramework.YFScroller("+objectData.Size.X+","+objectData.Size.Y+");"+NextLine;
					addChildStr ="addItem"
					break;
				default:
					totalStr += Tab +Tab + tagName+" = new YFFramework.AbsBorderView();"+NextLine;
					addChildStr = "addChild";
					break;
			}
			
			var anchorPointX:Number = 0 ;
			var anchorPointY:Number = 0; 
			if (objectData.AnchorPoint.ScaleX) anchorPointX =objectData.AnchorPoint.ScaleX;
			if (objectData.AnchorPoint.ScaleY) anchorPointY =objectData.AnchorPoint.ScaleY;

			var VisibleForFrame:Boolean = true; 
			var TouchEnable :Boolean = false||objectData.TouchEnable;
			var alpha:int = 255;
			if (objectData.VisibleForFrame!=null) VisibleForFrame = objectData.VisibleForFrame ;///是否可见
			if (objectData.Alpha!=null) alpha = objectData.Alpha ;///是否可见
			var myAlpha :Number = Math.floor(alpha*100 / 255)/100;
			
			totalStr += Tab + Tab +tagName+".setSize("+objectData.Size.X+","+objectData.Size.Y+");"+NextLine;
			totalStr += Tab +Tab + tagName+".setXY("+Math.round(objectData.Position.X-objectData.Size.X*anchorPointX)+","+Math.round(rootH -objectData.Position.Y-objectData.Size.Y*(1-anchorPointY))+");"+NextLine;
			
			if(objectData.Scale.ScaleX!=1||objectData.Scale.ScaleY!=1) totalStr += Tab +Tab + tagName+".setScale("+objectData.Scale.ScaleX+","+objectData.Scale.ScaleY+");"+NextLine;
			if(myAlpha!=1) totalStr += Tab + Tab +tagName+".setAlpha("+myAlpha+");"+NextLine;
			if(VisibleForFrame!=true)totalStr += Tab + Tab +tagName+".setVisible("+VisibleForFrame+");"+NextLine;
			if(TouchEnable==false)totalStr += Tab +Tab + tagName+".setMouseEnabled("+TouchEnable+");"+NextLine;
			
			//动态添加tag属性
			totalStr += Tab + Tab +tagName+".name = '"+objectData.Name +"';"+NextLine;
			
			totalStr += Tab +Tab +objectDataParent+"."+ parentAddStr+"("+tagName+");"+NextLine;
			return {tagName:tagName,addChildStr:addChildStr,totalStr:totalStr};
		}
		
		//根据类型获取对应的函数名
//		public static function getClassByType(type:String,sizeObj:Object)
//		{
//			var str :String = "";
//
//			switch(type)
//			{
//				case Type_List:
//					str = " = new YFFramework.YFList("+sizeObj.X+","+sizeObj.Y+")"+NextLine;
//					break;
//				case Type_Button:
//					
//					break;
//				case Type_Label:
//					
//					break;
//				case Type_Panel:
//					
//					break;
//				case Type_ProgressBar:
//					
//					break;
//				case Type_TextView:
//					
//					break;
//				case Type_ScrollView:
//					
//					break;
//				default:
//					
//					break;
//			}
//		}
		

		
		
		
		
	}
}