package movieData.movie
{
	import movieData.movie.data.BitmapDataEx;
	
	import flash.events.Event;

	/**@author yefeng
	 *2012-4-22下午9:28:26
	 */
	public class RoleBaseView extends BitmapMovieClip
	{
		private var activeAction:int=-1;
		private var activeDirection:int=-1;
		public function RoleBaseView(autoRemove:Boolean=true)
		{
			super(autoRemove);
		}
		
		override protected function onPlayComplete(e:Event):void
		{
			// TODO Auto Generated method stub
			activeAction=-1;
			super.onPlayComplete(e);
		}
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null):void
		{
			if(action!=activeAction||direction!=activeDirection)
			{
				this.completeFunc=completeFunc;
				if(direction==-1) direction=activeDirection;
				activeAction=action;
				activeDirection=direction;
				var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
				playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
			}
		}
		
	}
}