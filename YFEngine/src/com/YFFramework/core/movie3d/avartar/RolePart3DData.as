package com.YFFramework.core.movie3d.avartar
{
	import away3d.entities.Mesh;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import yf2d.textures.TextureHelper;

	/**@author yefeng
	 *2013-4-14下午9:06:31
	 */
	public class RolePart3DData
	{
		public var mesh:Mesh;
		
		public var rotationY:Number;
		/**   x  y   z 偏移量
		 */		
		public var x:Number;
		public var y:Number;
		public var z:Number;
		/***缩放银子
		 */ 
		public var scale:Number;
		/**动作列表
		 */		 		
		public var actionArr:Array;
		
		public var bitmapData:BitmapData;
		
		private var _flashTexture:Texture;
		public function RolePart3DData()
		{
		}
		
		public function dispose():void
		{
			mesh.dispose();
			actionArr=null;
		}
		
		public function getFlashTexture():Texture
		{
			if(_flashTexture==null)
			{
				_flashTexture=TextureHelper.Instance.getTexture(bitmapData);
			}
			return _flashTexture;
		}
	}
}