package com.YFFramework.core.ui.yf2d.graphic
{
	import com.YFFramework.core.event.YFEvent;

	/**@author yefeng
	 * 2013 2013-5-14 下午3:19:23 
	 */
	public class ShapePartView extends ShapeMovieClip
	{
		public function ShapePartView()
		{
			super();
		}
		
		
//		override protected function onPlayComplete(e:YFEvent):void
//		{
//			// TODO Auto Generated method stub
//			_activeAction=-1;
//			super.onPlayComplete(e);
//		}
		/**
		 * 
		 * @param resetPlay    表示重复播放 如果为false表示不进行重复播放   true表示进行重复播放 
		 * 
		 */
//		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void
//		{
//			var realDirection:int;
//			if(direction==-1) direction=_activeDirection;
//			realDirection=direction;
//			if(resetPlay) super.play(action,direction,loop,completeFunc,completeParam,resetPlay);
//			else  // 在播放相同动作时不在进行重复播放
//			{
//				if(action!=_activeAction||direction!=_activeDirection)
//				{
//					_completeFunc=completeFunc;
//					_completeParam=completeParam;
//					if(direction>5)
//					{
//						scaleX=-1;
//						switch(direction)
//						{
//							case TypeDirection.LeftDown:
//								direction=TypeDirection.RightDown
//								break;
//							case TypeDirection.Left:
//								direction=TypeDirection.Right;
//								break;
//							case TypeDirection.LeftUp:
//								direction=TypeDirection.RightUp;
//								break;
//						}
//					}
//					else if(direction>0)
//					{
//						scaleX=1;
//					}
//					if(actionData.dataDict[action])
//					{
//						var movieData:MovieData=actionData.dataDict[action][direction];
//						if(movieData)
//						{
//							///设置像素源
//							_sourceBitmapData=movieData.bitmapData;
//							playInit(movieData,scaleX,loop);
//						}
//					}
//				}
//			}
//			_activeAction=action;
//			_activeDirection=realDirection;
//		}
//		
	}
}