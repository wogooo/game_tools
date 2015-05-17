package com.YFFramework.core.ui.yf2d.data
{
	import flash.geom.Rectangle;
	
	import yf2d.textures.face.ITextureBase;
	

	/**@author yefeng
	 *20122012-11-17下午7:09:12
	 */
	public class BitmapFrameData implements ITextureBase
	{
		/**  x  y  坐标偏移量 
		 */ 
		public var x:Number; ///  
		public var y:Number;
		/**停 留的帧数  默认值 为1    表示停留一帧
		 */
		public var  delay:Number;
		
		/** 包含的信息是  uv 信息 以及  宽高大小
		 */		
		
		protected var _uvData:Vector.<Number>;
		protected var _uvDataScaleY:Vector.<Number>;
		
		protected var _textureRect:Rectangle;
		public function BitmapFrameData()
		{
		}
		
		/**设置UV数据
		 */		
		public function setUVData(vect:Vector.<Number>):void
		{
			_uvData=vect;
			_uvDataScaleY=vect.concat(); ////  0 ,2  位置交换  //  y坐标翻转   交换 x 坐标
			_uvDataScaleY[0]=_uvDataScaleY[0]+_uvDataScaleY[2];
			_uvDataScaleY[2]=-_uvDataScaleY[2];
		}
		
		/**@param scaleX 进行镜像翻转需要
		 * scaleX 只能为  1  或者-1      u v 信息
		 */		 
		public function getUVData(scaleX:Number=1):Vector.<Number>
		{
			if(scaleX==1)return _uvData;
			else if(scaleX==-1)return _uvDataScaleY;
			return null;
		}
		/**设置  贴图区域大小  用来进行宽高定位
		 * atlasX atlasY是在源图上的位置
		 */		
		public function setTextureRect(atlasX:Number,atlasY:Number,width:int,height:int):void
		{
			_textureRect=new Rectangle(atlasX,atlasY,width,height);
		}
		public function get rect():Rectangle
		{
			return _textureRect;
		}
		public function clone():ITextureBase
		{
			var texture:BitmapFrameData=new BitmapFrameData();
			texture._textureRect=this._textureRect.clone();
			texture._uvData=this._uvData.concat();
			texture._uvDataScaleY=_uvDataScaleY.concat();
			texture.x=x;
			texture.y=y;
			texture.delay=delay;
			return texture as ITextureBase;	
		}		
		public function dispose():void
		{
			
			_textureRect=null;
			_uvData=null;
			_uvDataScaleY=null;
		}
		
	
	}
}