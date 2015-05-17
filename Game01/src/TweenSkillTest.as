package
{
	import com.YFFramework.core.center.manager.update.UpdateManager;
	import com.YFFramework.core.debug.print;
	import com.YFFramework.core.utils.tween.game.TweenSkill;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**2012-10-11 上午9:18:15
	 *@author yefeng
	 */
	public class TweenSkillTest extends Sprite
	{
		public function TweenSkillTest()
		{
			super();
			addEventListener(Event.ENTER_FRAME,update);
			TweenSkill.WaitToExcute(1500,func,"ok");
		}
		
		private function update(e:Event):void
		{
			UpdateManager.Instance.update();
		}
		private function func(obj:Object):void
		{
			print(this,"执行");
		}
	}
}