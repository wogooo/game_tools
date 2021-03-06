package data
{
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.TextureBase;
	import flash.utils.ByteArray;

	public class ATFMovieData
	{
		/**序列帧数据源 
		 */		
		public var dataArr:Vector.<ATFBitmapFrame>;
		
		/**大贴图源像素
		 */ 
		public var bitmapData:BitmapData;
		/**和该BitmapData相关联的的Texture  Texture不用时 需要及时dispose 需要时在通过bitmapData生成即可 因为Texture有大小限制必须这样 
		 */		
		private var _texture:TextureBase;
		private var _isDispose:Boolean;
		
		public var atfByte:ByteArray; 
		public var width:int;
		public var height:int;
		/**是否为重新创建
		 */		
		private var _reCreate:Boolean;
		public function ATFMovieData()
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
				_texture=TextureHelper.Instance.getTextureFromATFAlpha(atfByte,width,height);           
				_reCreate=false;                       
			}  
			else 
			{
				if(_reCreate) //重复创建     
				{
					//					_texture.dispose();     
					_texture=TextureHelper.Instance.getTextureFromATFAlpha(atfByte,width,height);                                
					_reCreate=false;                       
				}                  
			}                            
			return _texture;                        
		}
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
			if(bitmapData)bitmapData.dispose();
			if(atfByte)atfByte.clear();
			atfByte=null;
			bitmapData=null;
			dataArr=null;
			_isDispose=true;
			_reCreate=false;
		}	}
}