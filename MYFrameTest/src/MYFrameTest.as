package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.Stats;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**2012-7-25 上午10:36:53
	 *@author yefeng
	 */
	[SWF(frameRate="30")]
	public class MYFrameTest extends Sprite
	{
		public function MYFrameTest()
		{
			addEventListener(Event.ENTER_FRAME,onFrame);
			addChild(new Stats());

		}
		
		private function onFrame(e:Event):void
		{
			UpdateManager.Instance.update();
		}
			
	}
}