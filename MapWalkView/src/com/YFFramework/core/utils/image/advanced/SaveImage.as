/*

用于将图片保存在本地 
用法:
var  target:Sprite=imageArr[imageArr.length-1]
	var saveImage:SaveImage= new SaveImage

saveImage.save(target.width,target.height,target,"png","woca")




*/

/**
 * 用于本地air程序
 */



package com.YFFramework.core.utils.image.advanced  {
	
	
	
	import com.YFFramework.core.utils.image.advanced.encoder.BMPEncoder;
	import com.YFFramework.core.utils.image.advanced.encoder.Encoder;
	import com.YFFramework.core.utils.image.advanced.encoder.JPGEncoder;
	import com.YFFramework.core.utils.image.advanced.encoder.PNGEncoder;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.net.FileReference;
	import flash.utils.ByteArray;
	
	public class SaveImage {
		
		public static const JPG:String = "jpg";
		public static const PNG:String = "png";
		public static const BMP:String = "bmp";
		
		private var file:FileReference;
		private var bmpData:BitmapData;
		private var encoder:Encoder;
		
		
		private var imageW:Number
		private var imageH:Number;
		private var displayObject:DisplayObject
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
		public function SaveImage() {
			// constructor code
			
			
			
			init()
		}
			private function init():void {
				
					file= new FileReference();
				}
				
				public function save(_w:Number,_h:Number,_object:DisplayObject,_type:String="jpg",myName:String="默认图片",_quality:int=80):void {
					
			imageW=_w
			imageH=_h
			displayObject=_object
			quality=_quality
			defaultName = myName
			var index:int = myName.indexOf(".");
			if (index != -1) {
				var str:String = myName.substr(index);
				if (str !== "."+_type)  defaultName = defaultName.substr(0, index) + "." + _type;
				
				}
				
			else defaultName = defaultName + "." + _type;
			
				
				
			
			switch(_type) {
				case SaveImage.BMP:
				encoder = new BMPEncoder();
				break;
				case SaveImage.PNG:
				encoder = new PNGEncoder();
				break;
				default:
				encoder = new JPGEncoder(_quality);
				break
				
				}
		
				
				bmpData= new BitmapData(imageW,imageH,true,0x000000)			
				
				bmpData.draw(displayObject);
					
				//	encoder= new JPGEncoder(quality);
				
					var bytes:ByteArray=encoder.encode(bmpData);
					
					file.save(bytes,defaultName);
					
					
					}
				


	}
	
}
