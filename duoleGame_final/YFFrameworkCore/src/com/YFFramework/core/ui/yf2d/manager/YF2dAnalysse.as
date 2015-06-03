package com.YFFramework.core.ui.yf2d.manager
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.ui.yf2d.data.BitmapFrameData;
	import com.YFFramework.core.ui.yf2d.data.MovieData;
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	
	import flash.display.BitmapData;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;

	/**@author yefeng
	 *2012-11-17下午11:05:12
	 */
	public class YF2dAnalysse
	{
		

		public static const DefaultValue:int=4;
//		public static var AnalysseIt:int=0;
		private static const pre:String="yf2d_";
		public function YF2dAnalysse()
		{
		}
		
		
		
		/**
		 * 
		 * @param actionData  目前只具有头部信息
		 * @param domain  域
		 */
//		public static  function extractActionData(actionData:YF2dActionData,domain:ApplicationDomain):void
//		{
//			var bitmapDataEx:BitmapFrameData;
//			var movieData:MovieData;
//			var bmpClass:Class;
//			var className:String="";
//			var bitmapData:BitmapData;
//			var uvVect:Vector.<Number>;
//			var frameRate:int;//帧频率   每一个方向 一个帧率
//			var direction :int;
//			var frameData:Object;
//			for each (var action:int in actionData.headerData["action"])
//			{
//				actionData.dataDict[action]=new Dictionary();
//				frameRate=actionData.headerData[action]["frameRate"];
//				for each (direction in actionData.headerData[action]["direction"])
//				{
//					className=pre+action+"_"+direction;
//					bmpClass=domain.getDefinition(className) as Class;
//					bitmapData=new bmpClass() as BitmapData;
//
//					movieData=new MovieData();
//					movieData.dataArr=new Vector.<BitmapFrameData>();
//					actionData.dataDict[action][direction]=movieData;
//					movieData.bitmapData=bitmapData;
//					
//					for each (frameData in actionData.headerData[action][direction]["data"])
//					{
//						bitmapDataEx=new BitmapFrameData();
//						bitmapDataEx.x=frameData.x;
//						bitmapDataEx.y=frameData.y;
//						bitmapDataEx.delay=frameData.delay*frameRate; //把时间也算上去
//						///设置宽高
//						bitmapDataEx.setTextureRect(frameData.rect.x,frameData.rect.y,frameData.rect.width,frameData.rect.height);
//						///设置 uv 
//						uvVect=Vector.<Number>([frameData.rect.x/bitmapData.width,frameData.rect.y/bitmapData.height,frameData.rect.width/bitmapData.width,frameData.rect.height/bitmapData.height]);
//						bitmapDataEx.setUVData(uvVect);
//						movieData.dataArr.push(bitmapDataEx);
//						//矩阵 用于  常规显示shapeClip显示
//						///注意 flash显示对象 在左上角 和yf2d显示对象在中间不一样 所以还需要转化
//						 //放到 需要CPU 显示的时候在进行初始化  调用 bitmapFrameData.initShapeData
////						mat=new Matrix();
////						mat.translate(-frameData.rect.x,-frameData.rect.y);
////						bitmapDataEx.matrix=mat;
////						bitmapDataEx.shapeX=frameData.x-frameData.rect.width*0.5;
////						bitmapDataEx.shapeY=frameData.y-frameData.rect.height*0.5;
//					}
//					delete actionData.headerData[action][direction]["data"];
//				}
//			}
//		}
		
		
		
		public static  function extractActionData(actionData:YF2dActionData,domain:ApplicationDomain):void
		{
//			var t:Number=getTimer();
			var bitmapDataEx:BitmapFrameData;
			var movieData:MovieData;
			var bmpClass:Class;
			var className:String="";
			var bitmapData:BitmapData;
			var uvVect:Vector.<Number>;
			var frameRate:int;//帧频率   每一个方向 一个帧率
			var direction :int;
			var frameData:Object;
			
			var action:int;
			var actionLen:int=actionData.headerData["action"].length;
			
			var dataLen:int;//数据长度
			var j:int;
			for(var i:int=0;i!=actionLen;++i)
			{
				action=actionData.headerData["action"][i];
				
				actionData.dataDict[action]=new Dictionary();
				frameRate=actionData.headerData[action]["frameRate"];
				for each (direction in actionData.headerData[action]["direction"])
				{
					className=pre+action+"_"+direction;
					bmpClass=domain.getDefinition(className) as Class;
					bitmapData=new bmpClass() as BitmapData;
					
					movieData=new MovieData();
					movieData.dataArr=new Vector.<BitmapFrameData>();
					actionData.dataDict[action][direction]=movieData;
					movieData.bitmapData=bitmapData;
					
					dataLen=actionData.headerData[action][direction]["data"].length;
					for(j=0;j!= dataLen;++j)
					{
						frameData=actionData.headerData[action][direction]["data"][j];
						bitmapDataEx=new BitmapFrameData();
						bitmapDataEx.x=frameData.x;
						bitmapDataEx.y=frameData.y;
						bitmapDataEx.delay=frameData.delay*frameRate; //把时间也算上去
						///设置宽高
						bitmapDataEx.setTextureRect(frameData.rect.x,frameData.rect.y,frameData.rect.width,frameData.rect.height);
						///设置 uv 
//						uvVect=Vector.<Number>([frameData.rect.x/bitmapData.width,frameData.rect.y/bitmapData.height,frameData.rect.width/bitmapData.width,frameData.rect.height/bitmapData.height]);
						uvVect=new Vector.<Number>();
						uvVect.push(frameData.rect.x/bitmapData.width,frameData.rect.y/bitmapData.height,frameData.rect.width/bitmapData.width,frameData.rect.height/bitmapData.height); //这样性能高点
						bitmapDataEx.setUVData(uvVect);
						movieData.dataArr.push(bitmapDataEx);
						//矩阵 用于  常规显示shapeClip显示
						///注意 flash显示对象 在左上角 和yf2d显示对象在中间不一样 所以还需要转化
						//放到 需要CPU 显示的时候在进行初始化  调用 bitmapFrameData.initShapeData
						//						mat=new Matrix();
						//						mat.translate(-frameData.rect.x,-frameData.rect.y);
						//						bitmapDataEx.matrix=mat;
						//						bitmapDataEx.shapeX=frameData.x-frameData.rect.width*0.5;
						//						bitmapDataEx.shapeY=frameData.y-frameData.rect.height*0.5;
					}
//					delete actionData.headerData[action][direction]["data"];  //可以不用删除
				}
			}
			
//			print("解析:",getTimer()-t);
//			AnalysseIt=DefaultValue;
		}
		
		public static function analysse(hswfBytes:ByteArray):Object
		{
			hswfBytes.uncompress();
			var headLen:Number=hswfBytes.readInt();
			var swfLen:Number=hswfBytes.readInt();
			var swfBytes:ByteArray=new ByteArray();
			var headBytes:ByteArray=new ByteArray(); 
			hswfBytes.readBytes(headBytes,0,headLen);
			hswfBytes.readBytes(swfBytes,0,swfLen);
			var headData:Object=headBytes.readObject()
			return {headData:headData,swfBytes:swfBytes}
		}
		
	}
}