package com.YFFramework.core.ui.yf2d.view
{
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	
	import yf2d.display.sprite2D.Sprite2D;
	import yf2d.textures.sprite2D.SimpleTexture2D;
	import yf2d.textures.sprite2D.Sprite2DTexture;

	/** 九切片    stage3d类
	 * 2012-11-22 下午1:45:50
	 *@author yefeng
	 */
	public class Scale9Sprite extends Abs2dView
	{
		private var leftTop : Sprite2D;
		private var leftCenter : Sprite2D;
		private var leftBottom : Sprite2D;
		private var centerUp : Sprite2D;
		private var center : Sprite2D;
		private var centerBottom : Sprite2D;
		private var rightTop : Sprite2D;
		private var rightCenter : Sprite2D;
		private var rightBottom : Sprite2D;
		
		/**数据源
		 */		
		private var _flashTexture:Texture;
		
		private var _width : Number;
		private var _height : Number;
		
		private var minWidth : Number;
		private var minHeight : Number;
		public function Scale9Sprite()
		{
			super();
		}
		
		/**第一次初始化所有的bitmapData
		 */ 
		public function intFromSource(lt:SimpleTexture2D,lc:SimpleTexture2D,lb:SimpleTexture2D,
									  ct:SimpleTexture2D,cc:SimpleTexture2D,cb:SimpleTexture2D,
									  rt:SimpleTexture2D,rc:SimpleTexture2D,rb:SimpleTexture2D,
									  texture:Texture,width:int,height:int):void
									  
		{
			_flashTexture=texture;
			leftTop = getSprite2D(lt);
			this.addChild(leftTop);
			leftCenter = getSprite2D(lc);
			this.addChild(leftCenter);
			leftBottom = getSprite2D(lb);
			this.addChild(leftBottom);
			centerUp = getSprite2D(ct);
			this.addChild(centerUp);
			center = getSprite2D(cc);
			this.addChild(center);
			centerBottom = getSprite2D(cb);
			this.addChild(centerBottom);
			rightTop = getSprite2D(rt);
			this.addChild(rightTop);
			rightCenter = getSprite2D(rc);
			this.addChild(rightCenter);
			rightBottom = getSprite2D(rb);
			this.addChild(rightBottom);
			initMinWH();
			this.width=width;
			this.height=height;			
		}
		
		private function getSprite2D(texture2d:SimpleTexture2D):void
		{
			var sp:Sprite2D=new Sprite2D();
			sp.setTextureData(texture2d);
			sp.setFlashTexture(_flashTexture);
		}
		protected function initMinWH():void
		{
			minWidth = leftCenter.width + rightCenter.width;
			minHeight = centerUp.height + centerBottom.height;
		}
		
		override public function set width(w : Number) : void
		{
			if(w < minWidth)
				w = minWidth;
			_width = w;
			refurbishSize();
		}
		/**设置九宫格中间部分的宽度
		 */		
		public function setContentWidth(contentWidth:Number):void
		{
			width=contentWidth+leftCenter.width+rightCenter.width;
		}
		
		/**  中间部分的 宽度
		 */
		public function getContentWidth():Number
		{
			return  center.width;
		}
		
		
		override public function set height(h : Number) : void 
		{
			if(h < minHeight) 
				h = minHeight;
			_height = h;
			refurbishSize();
		}
		
		/**设置九宫格中间部分的高度
		 */		
		public function setContentHeight(contentHeight:Number):void
		{
			height=contentHeight+centerUp.height+centerBottom.height;
		}
		/**中间部分的高度
		 */
		public function getContentHeight():Number
		{
			return center.height;
		}
		
		private function refurbishSize() : void
		{
			leftCenter.height =( _height - leftTop.height - leftBottom.height);
			leftBottom.y = _height - leftBottom.height;
			centerUp.width = (_width - leftCenter.width - rightCenter.width);
			center.width =(_width - leftCenter.width - rightCenter.width);
			center.height = ( _height - leftTop.height - leftBottom.height);
			centerBottom.width = center.width;
			centerBottom.y = leftBottom.y;
			rightTop.x = _width - rightCenter.width;
			rightCenter.x = rightTop.x;
			rightCenter.height = center.height;
			rightBottom.x = rightTop.x;
			rightBottom.y = leftBottom.y;
		}
		
		
	}
}