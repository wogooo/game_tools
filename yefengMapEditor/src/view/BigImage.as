package view
{
	
	import com.YFFramework.core.net.loader.image_swf.UILoader;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import mx.events.FlexEvent;
	
	import spark.components.Group;
	import spark.components.Image;
	
	public class BigImage extends Group
	{
		public var imageLoadedCall:Function;//		private var _image:Image;
		private var _image1:Image;
		private var _image2:Image;
		private var _image3:Image;
		private var _image4:Image;
		private var _image5:Image;
		private var _image6:Image;
		private var _image7:Image;
		private var _image8:Image;
		private var _image9:Image;
		
		
		private var bitmapData:BitmapData;
		
		public var myWidth:int=0;
		public var myHeight:int=0;
		private var _isSet:Boolean=false;
		
		public function BigImage()
		{
			super();
			_image1=new Image();
			_image2=new Image();
			_image3=new Image();
			_image4=new Image();
			addElement(_image1);
			addElement(_image2);
			addElement(_image3);
			addElement(_image4);
			
			
		}
		private function onImageReady3(content:Bitmap,data:Object):void
		{
			bitmapData=content.bitmapData;
			graphics.beginBitmapFill(bitmapData,null,false);
			graphics.drawRect(0,0,bitmapData.rect.width,bitmapData.rect.height);
			graphics.endFill();
			myWidth=bitmapData.width;
			myHeight=bitmapData.height;
			width=myWidth;
			height=myHeight;
			if(imageLoadedCall!=null)imageLoadedCall();
		}
		
		
		
		private function onImageReady4(content:Bitmap,data:Object):void
		{
			bitmapData=content.bitmapData;
			myWidth=bitmapData.width;
			myHeight=bitmapData.height;
			var leftW:int=bitmapData.width/2;
			var rightW:int=bitmapData.width-leftW;
			var topH:int=bitmapData.height/2;
			var bottomH:int=bitmapData.height-topH;
			
			var mat1:Matrix=new Matrix();
			mat1.tx=0;
			mat1.ty=0;
			mat1.translate(0,0);
			
			var mat2:Matrix=new Matrix();
			mat2.tx=-leftW;
			mat2.ty=0;
			
			var mat3:Matrix=new Matrix();
			mat3.tx=0;
			mat3.ty=-topH;
			
			var mat4:Matrix=new Matrix();
			mat4.tx=-leftW;
			mat4.ty=-topH;
			
			
			_image1.graphics.beginBitmapFill(bitmapData,mat1,false);
			_image1.graphics.drawRect(0,0,leftW,topH);
			_image1.graphics.endFill();
			
			
			_image2.graphics.beginBitmapFill(bitmapData,mat2,false);
			_image2.graphics.drawRect(0,0,rightW,topH);
			_image2.graphics.endFill();

			
			_image3.graphics.beginBitmapFill(bitmapData,mat3,false);
			_image3.graphics.drawRect(0,0,leftW,bottomH);
			_image3.graphics.endFill();

			
			_image4.graphics.beginBitmapFill(bitmapData,mat4,false);
			_image4.graphics.drawRect(0,0,rightW,bottomH);
			_image4.graphics.endFill();

			_image1.x=0
			_image1.y=0
			
			_image2.x=leftW;
			_image2.y=0
			
			
			_image3.x=0
			_image3.y=topH;
			
			_image4.x=leftW;
			_image4.y=topH;
			
			
			_image1.width=leftW
			_image1.height=topH
				
			_image2.width=rightW
			_image2.height=topH
				
			_image3.width=leftW
			_image3.height=bottomH
				
			_image4.width=rightW
			_image4.height=bottomH
				
			_isSet=true;
//			bitmapData.dispose();
				
			if(imageLoadedCall!=null)imageLoadedCall();
		}

		
		
		
		

			
		private function onImageReady(content:Bitmap,data:Object):void
		{
			bitmapData=content.bitmapData;
			myWidth=bitmapData.width;
			myHeight=bitmapData.height;
			var leftW:int=bitmapData.width/2;
			var rightW:int=bitmapData.width-leftW;
			var topH:int=bitmapData.height/2;
			var bottomH:int=bitmapData.height-topH;
			
			var bitmapData1:BitmapData=new BitmapData(leftW,topH,false,0xFFFFFF);
			var bitmapData2:BitmapData=new BitmapData(rightW,topH,false,0xFFFFFF);
			var bitmapData3:BitmapData=new BitmapData(leftW,bottomH,false,0xFFFFFF);
			var bitmapData4:BitmapData=new BitmapData(rightW,bottomH,false,0xFFFFFF);
			
			var mat1:Matrix=new Matrix();
			mat1.tx=0;
			mat1.ty=0;
			mat1.translate(0,0);
			
			var mat2:Matrix=new Matrix();
			mat2.tx=-leftW;
			mat2.ty=0;
			
			var mat3:Matrix=new Matrix();
			mat3.tx=0;
			mat3.ty=-topH;
			
			var mat4:Matrix=new Matrix();
			mat4.tx=-leftW;
			mat4.ty=-topH;
			
			var pt:Point=new Point();
			var rect1:Rectangle=new Rectangle(0,0,bitmapData1.width,bitmapData1.height);
			var rect2:Rectangle=new Rectangle(bitmapData1.width,0,bitmapData2.width,bitmapData2.height);
			var rect3:Rectangle=new Rectangle(0,bitmapData1.height,bitmapData3.width,bitmapData3.height);
			var rect4:Rectangle=new Rectangle(bitmapData1.width,bitmapData1.height,bitmapData4.width,bitmapData4.height);
			
			bitmapData1.copyPixels(bitmapData,rect1,pt);
			_image1.source=bitmapData1;

			bitmapData2.copyPixels(bitmapData,rect2,pt)
			_image2.source=bitmapData2;

			bitmapData3.copyPixels(bitmapData,rect3,pt)
			_image3.source=bitmapData3;

			bitmapData4.copyPixels(bitmapData,rect4,pt)
			_image4.source=bitmapData4;
			
			bitmapData.dispose();
			
			_image1.x=0
			_image1.y=0
			
			_image2.x=bitmapData1.width;
			_image2.y=0

			
			_image3.x=0
			_image3.y=bitmapData1.height;

			_image4.x=bitmapData1.width;
			_image4.y=bitmapData1.height;

			
		//	if(imageLoadedCall!=null)imageLoadedCall();
		}
		public function set source(obj:String):void
		{
			_isSet=false;
			_image1.graphics.clear();
			_image2.graphics.clear();
			_image3.graphics.clear();
			_image4.graphics.clear();
			
			var loader:UILoader=new UILoader();
			loader.loadCompleteCallback=onImageReady4;//onImageReady;//onImageReady;
			loader.initData(obj);
		}
		
		
	
			
		public function isSet():Boolean
		{
			return _isSet;
		}

		
		
		
		
		
		
		
		
		
	}
}