/**
 * 
 * 			var sprite2d:Sprite2D=new Sprite2D();
			var myData:BitmapData=new BitmapData(256,256,false,0xFF0000);
			var sprite2dTexture:Sprite2DTexture=new Sprite2DTexture(myData);
			sprite2d.setTextureData(sprite2dTexture);
			scence.addChildAt(sprite2d,0);
			sprite2d.width=3000
			sprite2d.height=3000   ////背景地图....

 * 
 */
package com.YFFramework.core.yf2d.display.sprite2D
{
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import com.YFFramework.core.yf2d.display.AbsSprite2D;
	import com.YFFramework.core.yf2d.display.DisplayObjectContainer2D;
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	import com.YFFramework.core.yf2d.textures.sprite2D.ITextureSprite2D;

	/**
	 * 
	 * @author yefeng
	 *20122012-11-17上午3:05:12
	 */
	public class Sprite2D extends AbsSprite2D
	{
	
		/**图像源
		 */		
		protected var _atlas:BitmapData;
		public function Sprite2D()
		{
			super(0,0);
		}
		/**像素源
		 */		
		public function setAtlas(atlas:BitmapData):void
		{
			_atlas=atlas;
		}
		
		public function getAtlas():BitmapData
		{
			return _atlas;
		}
		public function disposeAtlas():void
		{
			if(_atlas)_atlas.dispose();
			_atlas=null;
		}
		
		/**内存释放  Texture 并 不会释放  必须要自己手动去释放Texture
		 */ 
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			_atlas=null; 
		}
		
		/** parentPt是  parentContainer坐标系下的坐标，parentContainer为空时表示根容器舞台 
		 *   判断该点是否在 Sprite2D对象身上   假如该点透明也就不在身上
		 */
		public function getIntersect(parentPt:Point,parentContainer:DisplayObjectContainer2D=null):Boolean
		{
			if(_atlas)
			{
				if(parentContainer==null) parentContainer=scence;
				///将parentX  parentY转化为本地坐标
				var mat:Matrix=getTransformationMatrixToSpace(parentContainer);
				var newPt:Point=mat.transformPoint(parentPt);
				///判断该点是否透明
				var value:Number=_atlas.getPixel32(newPt.x,newPt.y)>> 24 & 0xFF;
				if(value>0) return true;
			}
			return false;
		}
		
		
		/** 检测该点的透明区域  透明 ==0返回true 非透明 返回false
		 * @param localPt
		 */
		override public function handleCheckAlpha(localPt:Point):Boolean
		{
			if(_alpha&&_atlas&&_checkAlpha)
			{
				
				var realY:int=_texture.rect.y+_texture.rect.height*0.5+localPt.y;
				var realX:int=_texture.rect.x+pivotX+_texture.rect.width*0.5+localPt.x*_textureScaleX;
				///和大图进行比较
				var alpha:Number=_atlas.getPixel32(realX,realY)>> 24 & 0xFF;
				if(alpha<=0)return true;
			}
			return false;
		}
		
	}
}