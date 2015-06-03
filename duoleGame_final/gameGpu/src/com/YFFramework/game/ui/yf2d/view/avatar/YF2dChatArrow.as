package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.ui.yf2d.view.Abs2dView;
	import com.YFFramework.core.ui.yfComponent.controls.YFChatArrow;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	import flash.geom.Matrix;
	
	import com.YFFramework.core.yf2d.display.sprite2D.Sprite2D;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.SimpleTexture2D;
	import com.YFFramework.core.yf2d.utils.getTwoPower;

	/**聊天冒泡汽  直接以YF2dChatArrow为原型进行拷贝即可
	 * 2012-11-22 下午2:25:01
	 *@author yefeng
	 */
	public class YF2dChatArrow extends Abs2dView
	{
		
		private var _chatArrow:YFChatArrow;
		
		private var _sprite2D:Sprite2D;
		private var _flashTexture:Texture;
		private var _skinId:int;
		
		public var debug:BitmapData;
		public function YF2dChatArrow(skinId:int=1)
		{
			_skinId=skinId;
			mouseChildren=mouseEnabled=false;
			super();
		}
		override protected function initUI():void
		{
			_chatArrow=new YFChatArrow(_skinId);
			_sprite2D=new Sprite2D();
			addChild(_sprite2D);
		}
		/**设置文本
		 */		
		public function set text(txt:String):void
		{
			_chatArrow.text=txt;
			var w:int=getTwoPower(_chatArrow.width);
			var h:int=getTwoPower(_chatArrow.height);
			var bitmapData:BitmapData=new BitmapData(w,h,true,0xFFFF00);
			///创建矩阵
			var mat:Matrix=new Matrix();
			if(_skinId==2)//向右
			{
				mat.tx=12;
				mat.ty=_chatArrow.height+20;
			}
			else if(_skinId==1)  //向左冒泡
			{
				mat.tx=_chatArrow.width-30;
				mat.ty=_chatArrow.height+20;
			}
			bitmapData.draw(_chatArrow,mat);
			///释放上一次 Texture
			disposeFlashTexture();
			_flashTexture=TextureHelper.Instance.getTexture(bitmapData);
			//创建 simpleTexure 设置 uv 和 宽 高
			var simpleTexture:SimpleTexture2D=new SimpleTexture2D();
			simpleTexture.setTextureRect(0,0,_chatArrow.width,_chatArrow.height);
			simpleTexture.setUVData(Vector.<Number>([0,0,_chatArrow.width/w,_chatArrow.height/h]));
			_sprite2D.setTextureData(simpleTexture);
			_sprite2D.setFlashTexture(_flashTexture);
	//		bitmapData.dispose();
			debug=bitmapData;
		}
		/**
		 */	
		private function disposeFlashTexture():void
		{
			if(_flashTexture)
			{
				_flashTexture.dispose();
				_flashTexture=null;				
			}
		}
			
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			disposeFlashTexture();
			_chatArrow.dispose();
			_chatArrow=null;
			_sprite2D=null;
		}
		
	}
}