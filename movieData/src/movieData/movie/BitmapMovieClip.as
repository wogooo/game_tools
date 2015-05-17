package movieData.movie
{
	/**
	 *  @author yefeng
	 *   @time:2012-4-6下午07:39:05
	 */
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	import movieData.manager.update.UpdateManager;
	import movieData.movie.data.ActionData;
	import movieData.movie.data.BitmapDataEx;
	import movieData.movie.util.TweenPlay;
	import movieData.ui.abs.AbsView;
	
	
	public class BitmapMovieClip extends AbsView
	{
		
		public var actionData:ActionData;
		protected var playImage:Bitmap;
		protected var playTween:TweenPlay;
		protected var completeFunc:Function;
		public function BitmapMovieClip(autoRemove:Boolean=true)
		{
			super(autoRemove);
			mouseChildren=false;
			cacheAsBitmap=true;
		}
		override protected function initUI():void
		{
			playImage=new Bitmap();
			addChild(playImage);
			playTween=new TweenPlay();
		}
		public function initData(actionData:ActionData):void
		{
			this.actionData=actionData;
		}
		private function updateRole(data:BitmapDataEx):void
		{
			playImage.bitmapData=data.bitmapData;
			playImage.x=data.x;
			playImage.y=data.y;
		}
		
		override protected function addEvents():void
		{
			super.addEvents();
			playTween.addEventListener(Event.COMPLETE,onPlayComplete);
		}
		override protected function removeEvents():void
		{
			super.removeEvents();
			playTween.removeEventListener(Event.COMPLETE,onPlayComplete);
		}
		///一个动作做完之后触发
		protected function onPlayComplete(e:Event):void
		{
			if(completeFunc!=null)completeFunc();
		}
		protected function playInit(playArr:Vector.<BitmapDataEx>,frameRate:int,loop:Boolean=true):void
		{
			playTween.initData(updateRole,playArr,frameRate,loop);
			playTween.start();
		}
		
		/**  播放方向
		 */
		public function play(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null):void
		{
			this.completeFunc=completeFunc;
			var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
			playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
		}
		override public function dispose(e:Event=null):void
		{
			super.dispose();
			UpdateManager.Instance.framePer.delFunc(playTween.update);
			playTween.dispose();
			playTween=null;
			actionData=null;
			completeFunc=null;
			removeChild(playImage);
			playImage=null;
		}
		/**调用 stop方法后 需要调用 start方法 重新启动后才能使用play方法
		 */		
		public function start():void
		{
			UpdateManager.Instance.framePer.regFunc(playTween.update);
		}
		/**再次启用需要调用start方法
		 */		
		public function stop():void
		{
			playTween.stop();
			UpdateManager.Instance.framePer.delFunc(playTween.update);
		}
				
	}
}