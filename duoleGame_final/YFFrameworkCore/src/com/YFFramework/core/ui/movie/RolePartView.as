package com.YFFramework.core.ui.movie
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.movie.data.TypeDirection;

	/**@author yefeng   角色部位
	 *2012-4-22下午9:28:26
	 */
	public class RolePartView extends BitmapMovieClip
	{
		protected var _activeAction:int=-1;
		protected var _activeDirection:int=-1;
		public function RolePartView()
		{
			super();
		}
		
		override protected function onPlayComplete(e:YFEvent):void
		{
			// TODO Auto Generated method stub
			_activeAction=-1;
			super.onPlayComplete(e);
		}
		/**
		 * 
		 * @param resetPlay    表示重复播放 如果为false表示不进行重复播放   true表示进行重复播放 
		 * 
		 */
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
		{
			var realDirection:int;
			if(direction==-1) direction=_activeDirection;
			realDirection=direction;
			if(resetPlay) super.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			else  // 在播放相同动作时不在进行重复播放
			{
				if(action!=_activeAction||direction!=_activeDirection)
				{
					_completeFunc=completeFunc;
					_completeParam=completeParam;
					if(direction>5)
					{
						scaleX=-1;
						switch(direction)
						{
							case TypeDirection.LeftDown:
								direction=TypeDirection.RightDown
								break;
							case TypeDirection.Left:
								direction=TypeDirection.Right;
								break;
							case TypeDirection.LeftUp:
								direction=TypeDirection.RightUp;
								break;
						}
					}
					else if(direction>0)
					{
						scaleX=1;
					}
					if(actionData.dataDict[action])
					{
						var arr:Vector.<BitmapDataEx>=	actionData.dataDict[action][direction];
						playInit(arr,int(actionData.headerData[action]["frameRate"]),loop);
					}
				}
			}
			_activeAction=action;
			_activeDirection=realDirection;
		}
	}
}