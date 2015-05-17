package manager
{
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.event.YFEventCenter;
	import com.YFFramework.core.net.loader.file.FileLoader;
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.filesystem.File;

	/** 解析 伟哥的 资源 转化为 png 
	 */	
	public class DuoluoPngManager
	{
		public static const DuoluoPngComplete:String="manager.DuoluoPngComplete";
		private static var _instance:DuoluoPngManager;
		
		private var _loadedlen:int;
		private var _totalLen:int;
		public function DuoluoPngManager()
		{
		}
		
		public static function get Instance():DuoluoPngManager
		{
			if(_instance==null) _instance=new DuoluoPngManager();
			return _instance;
		}
		
		public function handleXML(xml:XML,dir:File):void
		{
			_totalLen=getTotalLen(xml);
			_loadedlen=0;
			var obj:Object={};
			var xmlList:XMLList=xml.clip;
			print(this,"xmllen:",xmlList.length());
			var len:int=xmlList.length();
			var clipXml:XML;
			var frameLen:int;
			var frameXml:XML;
			var actionData:ActionData=new ActionData();
			var action:int;
			var direction:int;
			var bitmapDataEx:Object;
			actionData.headerData["action"]=[];
			var url:String=dir.url+"/";
			var count:int;
			var imageIndex:int;
			
			actionData.headerData["version"]  ="2.01";
			actionData.headerData["blood"] = {x:0,y:0}  
			
			for(var i:int=0;i!=len;++i) ///动作
			{
				clipXml=xmlList[i];
				frameLen=clipXml.frame.length();
				action=clipXml.@clipType;
				direction=clipXml.@clipDirection;
//				count=clipXml.@imageCount
				count=frameLen;
					
				var index:int=actionData.headerData["action"].indexOf(action);
				if(index==-1)actionData.headerData["action"].push(action);
				if(!actionData.headerData[action])actionData.headerData[action]={};
				if(!actionData.headerData[action][direction])
				{
					actionData.headerData[action][direction]={};
					actionData.headerData[action][direction]["len"]=count;
				}
				
				if(!actionData.headerData[action]["direction"])
				{
					actionData.headerData[action]["direction"]=[];///方向
				}
				actionData.headerData[action]["direction"].push(direction);
				actionData.headerData[action]["frameRate"]=1;///方向
//				if(!actionData.headerData[action]["data"])	actionData.headerData[action]["data"]=[];
				
				if(!actionData.dataDict[action])actionData.dataDict[action]={};
				if(!actionData.dataDict[action][direction])	actionData.dataDict[action][direction]=new Vector.<BitmapDataEx>();
				actionData.dataDict[action][direction].length=count;
				print(this,"act",action,direction);
				
				for(var j:int=0;j!=frameLen;++j)
				{
//					++_totalLen;

					frameXml=clipXml.frame[j];
					imageIndex=frameXml.@imageIndex;
					bitmapDataEx={};
					bitmapDataEx.x=Number(frameXml.@x);
					bitmapDataEx.y=Number(frameXml.@y);
					bitmapDataEx.delay=Number(frameXml.@time);
					if(imageIndex!=-1)
					{
						bitmapDataEx.url=url+action+"-"+direction+"-"+getUrl(imageIndex)+".png";
						bitmapDataEx.index=j;//Number(imageIndex);
						var loader:UILoader=new UILoader();
						loader.initData(bitmapDataEx.url,null,{actionData:actionData,bitmapDataEx:bitmapDataEx,direction:direction,action:action});
						loader.loadCompleteCallback=callBack
					}
					else 
					{
						bitmapDataEx.index=j;//为空白帧
						callBack(new Bitmap(new BitmapData(1,1,true,0xFFFFFF)),{actionData:actionData,bitmapDataEx:bitmapDataEx,direction:direction,action:action});
					}
				}
			}
		}
		
		
		/**获取总长度
		 */		
		private function getTotalLen(xml:XML):int
		{
			var xmlList:XMLList=xml.clip;
			var len:int=xmlList.length();
			var frameLen:int;
			var clipXml:XML;
			var myLen:int=0;
			for(var i:int=0;i!=len;++i) ///动作
			{
				clipXml=xmlList[i];
				frameLen=clipXml.frame.length();
				for(var j:int=0;j!=frameLen;++j)
				{
					++myLen;
				}
			}
			return myLen;
		}
		
		private function getUrl(index:int):String
		{
			var dd:int=index+1;
			var str:String=dd.toString();
			var len:int=str.length;
			var add:int=3-len;
			for(var i:int=0;i!=add;++i)
			{
				str="0"+str;
			}
			return str;
		}
		
		private function callBack(content:Bitmap,obj:Object):void
		{
			++_loadedlen;
			var actionData:ActionData=obj.actionData;
			var bitmapDataExObj:Object=obj.bitmapDataEx;
			var action:int=obj.action;
			var direction:int=obj.direction;
			var bitmapDataEx:BitmapDataEx=new BitmapDataEx();
			bitmapDataEx.x=bitmapDataExObj.x-320; ///坐标转化
			bitmapDataEx.y=bitmapDataExObj.y-336;
			bitmapDataEx.delay=bitmapDataExObj.delay;
			bitmapDataEx.bitmapData=content.bitmapData;
			bitmapDataEx.frameIndex=bitmapDataExObj.index;
			actionData.dataDict[action][direction][bitmapDataExObj.index]=bitmapDataEx;
			delete bitmapDataExObj.url;
			delete bitmapDataExObj.index;
			if(_loadedlen==_totalLen)
			{
				YFEventCenter.Instance.dispatchEventWith(DuoluoPngComplete,actionData);
			}
		}
		
		
		/** 将 xml  转化为   坐骑点
		 */		
		public function convertXMLToJsonObject(xml:XML):Object
		{
			var obj:Object={};
			var xmlList:XMLList=xml.clip;
			print(this,"xmllen:",xmlList.length());
			var len:int=xmlList.length();
			var clipXml:XML;
			var frameLen:int;
			var frameXml:XML;
			//			var offsetActionData:OffsetActionData=new OffsetActionData();
			var offsetHeaderData:Object={};
			
			var action:int;
			var direction:int;
			var bitmapDataEx:Object;
//			actionData.headerData["action"]=[];
			var count:int;
			for(var i:int=0;i!=len;++i) ///动作
			{
				clipXml=xmlList[i];
				frameLen=clipXml.frame.length();
				action=clipXml.@clipType;
				direction=clipXml.@clipDirection;
				count=clipXml.@imageCount
//				var index:int=offsetHeaderData["action"].indexOf(action);
//				if(index==-1)offsetHeaderData["action"].push(action);
				if(!offsetHeaderData[action])offsetHeaderData[action]={};
				if(!offsetHeaderData[action][direction])
				{
//					offsetHeaderData[action][direction]={};
//					offsetHeaderData[action][direction]["len"]=count;
//					offsetHeaderData[action][direction]["data"]=[];
					offsetHeaderData[action][direction]=[];

				}
				
//				if(!offsetHeaderData[action]["direction"])
//				{
//					offsetHeaderData[action]["direction"]=[];///方向
//				}
//				offsetHeaderData[action]["direction"].push(direction);
//				offsetHeaderData[action]["frameRate"]=1;///方向
//				if(!headerData[action]["data"])	headerData[action]["data"]=[];
				
//				if(!actionData.dataDict[action])actionData.dataDict[action]={};
//				if(!actionData.dataDict[action][direction])	actionData.dataDict[action][direction]=[];
//				actionData.dataDict[action][direction].length=count;
				print(this,"act",action,direction);
				var imageIndex:int;
				for(var j:int=0;j!=frameLen;++j)
				{
					frameXml=clipXml.frame[j];
					bitmapDataEx={};
					bitmapDataEx.x=Number(frameXml.@x)-320;
					bitmapDataEx.y=Number(frameXml.@y)-336;
					bitmapDataEx.delay=Number(frameXml.@time);
					imageIndex=int(frameXml.@imageIndex);
					print(this,"此处减去了偏移量");
//					offsetHeaderData[action][direction]["data"][imageIndex]=bitmapDataEx;
					offsetHeaderData[action][direction][imageIndex]=bitmapDataEx;
				}
			}
			return offsetHeaderData;
		}
	}
}