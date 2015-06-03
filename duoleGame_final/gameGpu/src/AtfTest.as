package
{
	/**@author yefeng
	 * 2013 2013-10-28 上午10:35:22 
	 */
	import com.YFFramework.core.net.loader.map.MapLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	
	import flash.display.Sprite;
	import flash.display3D.textures.Texture;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	public class AtfTest extends Sprite
	{
		public function AtfTest()
		{
			if(stage)
			{ 
				StageProxy.Instance.configure(stage);
				YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_First_CREATE,onContext3dCreate);
				YF2d.Instance.initData(stage,0x000000);
				addEventListener(Event.ENTER_FRAME,onFrame);
			}
		}
		private function onContext3dCreate(e:YF2dEvent=null):void
		{
			var loader:MapLoader=new MapLoader();
			loader.loadCompleteCallBack=call;
			loader.load("atfTest1.atf");
		}
		private function call(bytes:ByteArray,data:Object):void
		{
			var t:Number=getTimer(); 
			for(var i:int=0;i!=1;++i)
			{
				var texture:Texture=TextureHelper.Instance.getTextureFromATFAlpha(bytes,2048,2048);

			}
			trace(getTimer()-t);
			
		}
		
		
		
		private function onFrame(e:Event):void
		{
			YF2d.Instance.render();
		}

		
		
	}
}