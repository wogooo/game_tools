package
{
	/**@author yefeng
	 * 2013 2013-5-3 下午5:36:49 
	 */
	import com.YFFramework.core.net.loader.image_swf.UISLoader;
	import com.YFFramework.core.proxy.StageProxy;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.display.sprite2D.YF2dGameNameLabel;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	public class Test extends Sprite
	{
		public function Test()
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
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_First_CREATE,onContext3dCreate);
			var yf2dLabel:YF2dGameNameLabel=new YF2dGameNameLabel();
			yf2dLabel.setText("我是测试啊");
			yf2dLabel.x=200;
			yf2dLabel.y=200
			YF2d.Instance.scence.addChild(yf2dLabel);
			
			var loader:UISLoader=new UISLoader();
			var arr:Vector.<Object>=new Vector.<Object>();
			arr.push({url:"http://1.s.com/common/loading/不要的/uiSkin.swf"},{url:"http://1.s.com/common/loading/fightUI.swf"},{url:"http://1.s.com/common/loading/不要的/face.swf"},{url:"http://1.s.com/common/loading/cursorUI.swf?"+getTimer()+Math.random()});
			loader.load(arr)
			loader.loadCompleteCallBack=complete

			
			
			
			
			
			
			 
			var myStr:String="[1,2,3]";
			var myAA:Array=JSON.parse(myStr) as Array;
			
			
			
			
		}
		
		private function onFrame(e:Event):void
		{
			YF2d.Instance.render();
		}

		
		private function complete(data:Object):void
		{
			
			
			
		}

		
		
	}
}