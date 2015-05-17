/*

用于将图片保存在本地 
用法:
var image:SaveImage= new SaveImage(200,200,目标，品质，名字);
image.addEventListener(Event.COMPLETE,onComplete);
image.save();














 







*/

/**
 * 用于本地air程序
 */



package com.YFFramework.core.utils.image.advanced  {
	
	
	
	//import flash.events.Event;
	import com.YFFramework.air.FileUtil;
	import com.YFFramework.core.utils.image.advanced.encoder.BMPEncoder;
	import com.YFFramework.core.utils.image.advanced.encoder.Encoder;
	import com.YFFramework.core.utils.image.advanced.encoder.JPGEncoder;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class SaveImages extends EventDispatcher {
		
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
		public static const BMP:String = "bmp";
		
		/**
		 * 执行svae方法的进度   index的方法是不断变化的 需要在enterame事件里进行查看
		 */
	public  var index:int=0;
		
		
		
		private var bmpData:BitmapData;
		private var encoder:Encoder;
		
		
		private var imageW:Number
		private var imageH:Number;
	///	private var displayObject:DisplayObject
		private var defaultName:String;
		private var quality:int;
/**
 * 
 * @param	_w  宽
 * @param	_h   高
 * @param	_object  要生成图片的显示对象
 * @param	_type="jpg"  类型  值为  jpg png  bmp三种
 * @param	_quality  质量
 * @param	myName  文件名
 */ 
		public function SaveImages() {
			// constructor code
			
			
			
			init()
		}
			private function init():void {
				
				
				}
				
				
				
				/**
				 * 
				 * @param	dir  保存目录
				 * @param	fileName  生成的文件 的名字  比如 a   这个名字 只是单纯名字 当然也可以带上路径  但是只能相对路径  类似这样的   a/b/大侠风范  不要有后缀名
				 * @param	objcts  要生成 图片的显示对象
				 * @param	_type="jpg"
				 * @param	_quality
				 */
				
				
				public function save(dir:File,objcts:Array,fileNames:Vector.<String>,_type:String="jpg",_quality:int=80):void 
				{
					
			
						quality=_quality
						///	defaultName = prefix;
					
					
					
						switch(_type)
						{
							case SaveImages.BMP:
							encoder = new BMPEncoder();
							break;
							case SaveImages.PNG:
							encoder = new PNGEncoder();
							break;
							default:
							encoder = new JPGEncoder(_quality);
							break
							
						}  
				
						var len:int = objcts.length;
						var i:int = 0;
						
						var display:DisplayObject;
							var bytes:ByteArray;
							
							var fileName:String;
						while (i != len) {
							display = objcts[i];
							fileName = fileNames[i] + "." + _type;
						
						bmpData= new BitmapData(display.width,display.height,true,0x000000)			
						
						bmpData.draw(display);
						bytes=encoder.encode(bmpData);
							
						FileUtil.createFileByByteArray(dir,fileName,bytes);
						++i;
						++index;
					}
					
					
					this.dispatchEvent(new Event(Event.COMPLETE, true));


				}
				


	}
	
}
