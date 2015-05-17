package
{
	/**  2012-6-18
	 *	@author yefeng
	 */
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	
	import movieData.manager.update.UpdateManager;
	import movieData.movie.BitmapMovieClip;
	import movieData.movie.data.ActionData;
	import movieData.movie.net.HswfLoader;
	
	public class movieDataTest extends Sprite
	{
		
		private var role:BitmapMovieClip;
		public function movieDataTest()
		{
			role=new BitmapMovieClip(); ///下面游戏用了一个注册了的
			addChild(role);
			role.x=role.y=200;
			var url:String="套装01.chitu";
			loadRole(url);
			addEventListener(Event.ENTER_FRAME,onFrame);
		}
		private function onFrame(e:Event):void
		{
			
			UpdateManager.Instance.update();
		}
		
		private function loadRole(url:String):void
		{
			var loader:HswfLoader=new HswfLoader();
			loader.loadCompleteCallback=loadComplete;
			loader.load(url);
		}
		private function loadComplete(loader:HswfLoader):void
		{
			var data:ActionData=loader.actionData;
			role.initData(data);
			role.start();
			var action:int=role.actionData.getActionArr()[0];
			role.play(action,role.actionData.getDirectionArr(action)[0]);
		}
	}
}