package com.YFFramework.core.ui.yf2d.manager 
{
	import com.YFFramework.core.center.manager.update.TimeOut;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	public class ATFMovieAnalysse
	{
		public function ATFMovieAnalysse()
		{
		}
		/**  
		 * @param atfMovieBytes
		 * @param call
		 * call(actionData)
		 */		
		public static function handleATFBytes(atfMovieBytes:ByteArray,call:Function):void
		{
//			var t:Number=getTimer();
			atfMovieBytes.uncompress();////此步 比较耗时 ,游戏中异步错帧处理
			
			
			var actionData:ATFActionData=new ATFActionData();
			var headBytes:ByteArray=new ByteArray();
			var obj:Object=atfMovieBytes.readObject();
			actionData.headerData=obj;
			
//			extractActionData(atfMovieBytes,actionData);
//			return actionData

			var timeOut:TimeOut=new TimeOut(30,complete,{atfMovieBytes:atfMovieBytes,actionData:actionData,call:call});
			timeOut.start();

		}
		private static  function complete(object:Object):void
		{
			var atfMovieBytes:ByteArray=object.atfMovieBytes as ByteArray;
			var actionData:ATFActionData=object.actionData as ATFActionData;
			extractActionData(atfMovieBytes,actionData);  //此处 也比较消耗性能
			var timeOut:TimeOut=new TimeOut(30,object.call,actionData);//再次进行异步处理
			timeOut.start();
		}
		
		
		
		
		
		
		public static  function extractActionData(atfTotalBytes:ByteArray,actionData:ATFActionData):void
		{
			//			var t:Number=getTimer();
			var bitmapDataEx:ATFBitmapFrame;
			var movieData:ATFMovieData;
//			var bmpClass:Class;
//			var className:String="";
			var uvVect:Vector.<Number>;
			var frameRate:int;//帧频率   每一个方向 一个帧率
			var direction :int;
			var frameData:Object;
			
			var action:int;
			var actionLen:int=actionData.headerData["action"].length;
			
			var dataLen:int;//数据长度
			var j:int;
			var size:Object;
			var byteslen:int;
			for(var i:int=0;i!=actionLen;++i)
			{
				action=actionData.headerData["action"][i];
				
				actionData.dataDict[action]=new Dictionary();
				frameRate=actionData.headerData[action]["frameRate"];
				for each (direction in actionData.headerData[action]["direction"])
				{
//					className=pre+action+"_"+direction;
//					bmpClass=domain.getDefinition(className) as Class;
//					bitmapData=new bmpClass() as BitmapData;
					dataLen=actionData.headerData[action][direction]["data"].length;
					size=actionData.headerData[action][direction]["size"];

					movieData=new ATFMovieData();
					movieData.dataArr=new Vector.<ATFBitmapFrame>();
					actionData.dataDict[action][direction]=movieData;
					movieData.atfByte=new ByteArray();
					movieData.width=size.width;
					movieData.height=size.height
//					movieData.bitmapData=bitmapData;
					
					byteslen=atfTotalBytes.readInt();
					atfTotalBytes.readBytes(movieData.atfByte,0,byteslen);
					for(j=0;j!= dataLen;++j)
					{
						frameData=actionData.headerData[action][direction]["data"][j];
						bitmapDataEx=new ATFBitmapFrame();
						bitmapDataEx.x=frameData.x;
						bitmapDataEx.y=frameData.y;
						bitmapDataEx.delay=frameData.delay*frameRate; //把时间也算上去
						///设置宽高
						bitmapDataEx.setTextureRect(frameData.rect.x,frameData.rect.y,frameData.rect.width,frameData.rect.height);
						///设置 uv 
						//						uvVect=Vector.<Number>([frameData.rect.x/bitmapData.width,frameData.rect.y/bitmapData.height,frameData.rect.width/bitmapData.width,frameData.rect.height/bitmapData.height]);
						uvVect=new Vector.<Number>();
						uvVect.push(frameData.rect.x/size.width,frameData.rect.y/size.height,frameData.rect.width/size.width,frameData.rect.height/size.height); //这样性能高点
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
			
			atfTotalBytes.clear();
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