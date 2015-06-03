package com.YFFramework.core.yf2d.display.sprite2D
{
	/**    game scene  map 
	 * @author yefeng
	 *2012-11-20下午10:44:40
	 */
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.AbsSprite2D;
	import com.YFFramework.core.yf2d.display.AbsTileView2D;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.material.Program3DManager;
	import com.YFFramework.core.yf2d.material.Sprite2DMaterial;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.face.ITextureBase;
	import com.YFFramework.core.yf2d.textures.sprite2D.MapTexture;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.textures.Texture;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/** parent 
	 */	
	public class Map2D extends AbsSprite2D// AbsTileView2D// //
	{
		
		/** 该地图块是否在场景上当前屏幕范围内显示 return bool
		 */
		public var sceneContainsIt:Function;
		/** atfBytes
		 */		
		public var atfBytes:ByteArray;
		
//		protected var _atlas:BitmapData;

		/**是否重复创建
		 */		
		protected var _reCreate:Boolean;
		
//		private static var _createTime:Number=0;
//		private static const CreatTimeConst:int=100;
		public function Map2D(width:Number, height:Number,sceneContainsIt:Function)
		{
			super(width, height);
			super.setUVOffset(Vector.<Number>([0,0,1,1]));
			this.sceneContainsIt=sceneContainsIt;
			_reCreate=false;
			addEvents();
//			programId=Program3DManager.ATFNoALphaProgram;
		}
		/**侦听 context3d重复创建事件
		 */		
		private function addEvents():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onRecreate);
			
		}
		/**移除context3d重复创建事件
		 */		
		private function removeEvents():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onRecreate);
		}
		/**context3d 重复创建
		 */		
		private function onRecreate(e:YF2dEvent):void
		{
			_reCreate=true;
			reCreateTexture();
		}
		
		/**重新创建材质   texture释放后的重新创建  
		 */
		public function reCreateTexture():void
		{
			if(_reCreate)
			{
				if(atfBytes)
				{
					if(sceneContainsIt!=null)
					{
						if(sceneContainsIt(this))  ///地图在可见 范围内 重新创建
						{
							setFlashTexture(TextureHelper.Instance.getTextureFromATFAlphaMap(atfBytes,_texture.rect.width,_texture.rect.height));
							_reCreate=false;
						}
					}
				}
			}
		}
		
		
		public function disposeATFBytes():void
		{
			atfBytes.clear();
			atfBytes=null
		}

		override public function setUVOffset(uvoffset:Vector.<Number>):void
		{
			
		}
		
		private function callBack(texture:Texture,param:Object):void
		{
			setFlashTexture(texture);
		}
		override public function createFlashTexture():void
		{
			if(_flashTexture==null)	
			{
				if(atfBytes)
				{
					setFlashTexture(TextureHelper.Instance.getTextureFromATFAlphaMap(atfBytes,_texture.rect.width,_texture.rect.height));
				}
				_reCreate=false;
			}
//			else 
//			{	
			
//			}
		}
		
		
		
		/**@param texture2D  texture2D  must  be  MapTexture
		 * @param scaleX
		 */		
		override public function setTextureData(texture2D:ITextureBase,scaleX:Number=1,scaleY:Number=1):void
		{
			_texture=texture2D;
			updateSize();////更新材质大小 
		}
		/**    change the  size 
		 * @param width
		 * @param height
		 */		
		public function udateTexureSize(width:int,height:int):void
		{
			MapTexture(_texture).updateSize(width,height);  
			updateSize();////更新材质大小 
		}
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			disposeFlashTexture();
			if(atfBytes)disposeATFBytes();
//			if(_atlas)disposeAtlas();
			removeEvents();
			_reCreate=false;
		}
		
		/** 释放到对象池
		 */		
		public function disposeToPool():void
		{
			disposeFlashTexture();
			if(atfBytes)disposeATFBytes();
			removeEvents();
//			setFlashTexture(null);
			_reCreate=false;
			_texture=null;
			setXYScaleXY(0,0,1,1);
			sceneContainsIt=null;
		}
		/**对象池中获取数据重新初始化
		 */		
		public function initFromPool(sceneContainsIt:Function):void
		{
			this.sceneContainsIt=sceneContainsIt;
			addEvents();
		}
		
		override public function get width():Number
		{
			return __renderW;
		}
		override public function get height():Number
		{
			return __renderH;
		}


		
	}
}