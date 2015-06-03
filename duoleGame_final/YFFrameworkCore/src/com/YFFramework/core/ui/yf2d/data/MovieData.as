package com.YFFramework.core.ui.yf2d.data
{
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;

	/** 某个方向的播放数据
	 * @author yefeng
	 *20122012-11-17下午7:02:35
	 */
	public class MovieData
	{
		
		/**序列帧数据源 
		 */		
		public var dataArr:Vector.<BitmapFrameData>;

		/**大贴图源像素
		 */ 
		public var bitmapData:BitmapData;
		/**和该BitmapData相关联的的Texture  Texture不用时 需要及时dispose 需要时在通过bitmapData生成即可 因为Texture有大小限制必须这样 
		 */		
		private var _texture:TextureBase;
		private var _isDispose:Boolean;
		/**是否为重新创建
		 */		
		private var _reCreate:Boolean;
		public function MovieData()
		{
			_isDispose=false;
			_reCreate=false;
			addEvents();
			
		}
		private function addEvents():void               
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onRecreate);
		}
		private function removeEvents():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onRecreate);
		}
		/**重复创建context3d
		 */		
		private function onRecreate(e:YF2dEvent):void
		{
			_reCreate=true;
		}
		public function get isDispose():Boolean
		{
			return _isDispose;
		}
		
		public function getTexture():TextureBase
		{
			if(_texture==null)                                              
			{
				_texture=TextureHelper.Instance.getTexture(bitmapData);     
//				_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);
				_reCreate=false;                       
			}  
			else 
			{
				if(_reCreate) //重复创建     
				{
					_texture=TextureHelper.Instance.getTexture(bitmapData);     
//					_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);

					_reCreate=false;                       
				}                  
			}                            
			return _texture;          
			
//			if(_texture&&_reCreate==false)
//			{
//				return _texture;
//			}
//			return null;
		}
		
		
		
//		public function createTexture():void
//		{
//			if(_texture==null)                                              
//			{
//				_texture=TextureHelper.Instance.getTexture(bitmapData);     
//				//				_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);
//				_reCreate=false;                       
//			}  
//			else 
//			{
//				if(_reCreate) //重复创建     
//				{
//					_texture=TextureHelper.Instance.getTexture(bitmapData);     
//					//					_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);
//					
//					_reCreate=false;                       
//				}                  
//			}                            
//		} 
		
		
		/**立马生存 texure 
		 */
//		public function createTextureRightNow():void
//		{
//			if(_texture==null)                                              
//			{
//				_texture=TextureHelper.Instance.getTexture(bitmapData);     
//				//				_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);
//				_reCreate=false;                       
//			}  
//			else 
//			{
//				if(_reCreate) //重复创建     
//				{
//					_texture=TextureHelper.Instance.getTexture(bitmapData);     
//					//					_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeIt,null);
//					
//					_reCreate=false;                       
//				}                  
//			}                            
//		} 
		
//		private function completeTexture(texture:Texture,obj:Object):void
//		{
//			_texture=texture;
//			obj.call(_texture,obj.obj);
//		}
		/**
		 * @param completeIt  completeIt是  completeIt(texture,obj);
		 */		
//		public function createTextureAsync(completeIt:Function,obj:Object):void
//		{
//			if(_texture==null)                                              
//			{
//			//	_texture=TextureHelper.Instance.getTexture(bitmapData);     
//				_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeTexture,{call:completeIt,obj:obj});
//				_reCreate=false;                       
//			}  
//			else 
//			{
//				if(_reCreate) //重复创建     
//				{
////					_texture=TextureHelper.Instance.getTexture(bitmapData);     
//					_texture=TextureHelper.Instance.getTextureBitmapData(bitmapData,completeTexture,{call:completeIt,obj:obj});
//
//					_reCreate=false;                       
//				}                  
//			}                            
//		} 
		
		
		/**释放内存
		 */		
		public function disposeTexture():void
		{
			if(_texture)
			{
				_texture.dispose();
			}
			_texture=null;   
		}
		public function dispose():void
		{
			removeEvents();
			disposeTexture();
			bitmapData.dispose();
			dataArr=null;
			_isDispose=true;
			_reCreate=false;
		}
	}
}