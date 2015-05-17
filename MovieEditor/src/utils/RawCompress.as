
/**
 *
 * 用法
 *
 var quality:int=80;
 压缩:
 var data:ByteArray=CompressUtil.Instance.compress(content,quality);
 
 ///解压
 CompressUtil.Instance.unCompress(data);
 
 function onCompressEvent(e:CompressEvent):void
 {
 //得到解压后的透明通道图片数据
 var bmpData:BitmapData=e.data as BitmapData; 
 }
 
 *  
 */


package utils
{
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	import manager.BitmapDataEx;
	
	import utils.ImageAlphaUtil;
	import utils.JPGEncoder;
	
	
	
	/**
	 *  @author yefeng
	 *   @time:2012-3-16上午09:23:08
	 */
	public class RawCompress extends EventDispatcher
	{
		
		private static var _instance:RawCompress;
		public function RawCompress()
		{
			
		}
		public static function  get Instance():RawCompress
		{
			if(!_instance) _instance=new RawCompress();
			return _instance; 
		}
		/** 压缩之后生成的是ByteArray对象
		 */		
		public function compress(alphaBitmapData:BitmapData,rbgQuality:int=50,raQulity:int=80):ByteArray
		{
			var time:Number=getTimer();
			var vect:Vector.<BitmapData>=ImageAlphaUtil.spliteAlphaData(alphaBitmapData);
			var rbgBitmapData:BitmapData=vect[0];
			var raBitmapData:BitmapData=vect[1];
			var encoder:JPGEncoder=new JPGEncoder(rbgQuality);
			var rbgData:ByteArray=encoder.encode(rbgBitmapData);
			
			var raEncoder:JPGEncoder=new JPGEncoder(raQulity);
			var raData:ByteArray=raEncoder.encode(raBitmapData);
	//		trace("耗时时间::",getTimer()-time);
			var data:ByteArray=new ByteArray();
			data.writeInt(rbgData.length);  
			data.writeBytes(rbgData);
			data.writeInt(raData.length);
			data.writeBytes(raData);
			data.compress();    ///压缩之后生成的是ByteArray对象
			return data;
		}
		
		
		/**解压之后得到的是BitmapData对象   这个地方可以优化   先读取   data 然后统一加载   data的position最好为0
		 */		
		public function unCompress(data:ByteArray):Vector.<ByteArray>
		{  
			data.uncompress();
	//		var time:Number=getTimer();
	//		data.position=0;
			var rbgLen:int=data.readInt();
			var rbgData:ByteArray=new ByteArray();
			data.readBytes(rbgData,0,rbgLen);
			var raLen:int=data.readInt();
			var raData:ByteArray=new ByteArray();
			data.readBytes(raData,0,raLen);
	//		trace("耗时",getTimer()-time)
			///loading 开始
			return Vector.<ByteArray>([rbgData,raData]);
		}
		
		
		public function compressEx(alphaBitmapData:BitmapDataEx,rbgQuality:int=50,raQulity:int=50,bgColor:uint=0x000000):ByteArray
		{
//			var time:Number=getTimer();
			var vect:Vector.<BitmapData>=ImageAlphaUtil.spliteAlphaData(alphaBitmapData.bitmapData,bgColor);
			var rbgBitmapData:BitmapData=vect[0];
			var raBitmapData:BitmapData=vect[1];
			var encoder:JPGEncoder=new JPGEncoder(rbgQuality);
			var rbgData:ByteArray=encoder.encode(rbgBitmapData);
			
			var raEncoder:JPGEncoder=new JPGEncoder(raQulity);
			var raData:ByteArray=raEncoder.encode(raBitmapData);
	//		trace("耗时时间::",getTimer()-time);
			
			var data:ByteArray=new ByteArray();
			data.writeInt(alphaBitmapData.x);  ///先读取x y 
			data.writeInt(alphaBitmapData.y);
			data.writeInt(alphaBitmapData.delay);///停留帧数
			data.writeInt(alphaBitmapData.frameIndex); //帧数位置
			
			data.writeInt(rbgData.length);  
			data.writeBytes(rbgData);
			data.writeInt(raData.length);
			data.writeBytes(raData);
		//	data.compress();    ///压缩之后生成的是ByteArray对象
			return data;
		}
		
		public function unCompressEx(data:ByteArray):Object
		{  
		//	data.uncompress();
	//		var time:Number=getTimer();
			var x:int=data.readInt();
			var y:int=data.readInt();
			var delay:int=data.readInt();
			var frameIndex:int=data.readInt();
			
			var rbgLen:int=data.readInt();
			var rbgData:ByteArray=new ByteArray();
			data.readBytes(rbgData,0,rbgLen);
			var raLen:int=data.readInt();
			var raData:ByteArray=new ByteArray();
			data.readBytes(raData,0,raLen);
	//		trace("耗时",getTimer()-time)
		//	return {x:x,y:y,delay:delay,rbg:rbgData,ra:raData};
			
			return {x:x,y:y,delay:delay,frameIndex:frameIndex,data:Vector.<ByteArray>([rbgData,raData])};
		}
		
	}
}