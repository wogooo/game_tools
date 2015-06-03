package com.YFFramework.game.ui.yf2d.view.avatar
{
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.movie.data.TypeDirection;
	import com.YFFramework.core.ui.yf2d.data.ATFMovieData;
	import com.YFFramework.core.world.movie.player.utils.DirectionUtil;

	/** 场景 建筑特效播放类
	 * @author yefeng
	 * 2013 2013-5-8 下午2:28:43 
	 */
	public class BuildingEffect2DView extends ThingEffect2DView
	{
		
		/** 动画数据是否已经创建
		 */		
		public var dataInit:Boolean;
		
		/**建筑特效资源地址
		 */
		public var buldingUrl:String;
		/**改变坐标后的回调
		 */		
		public var callBack:Function;
		
		/**是否水平翻转 ， 有的特效 需要水平翻转 
		 */
		public var oppsiteX:int=1;
		public function BuildingEffect2DView()
		{
			super();
			dataInit=false;
		}
		
		override protected function updatePostion(e:YFEvent=null):void
		{
			super.updatePostion(e);
			callBack(this);
		}
		
		override public function disposeToPool():void
		{
			super.disposeToPool();
			callBack=null;
			dataInit=false;
			buldingUrl=null;
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			if(!_isDispose)
			{
				super.dispose(childrenDispose);
			}
		}
		
		override public function playDefault(loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=true):void
		{
			if(actionData)
			{
				var action:int=actionData.getActionArr()[0];
				var direction:int=actionData.getDirectionArr(action)[0];
				playIt(action,direction,loop,completeFunc,completeParam);
//				if(oppsiteX>0)
//				{
//				}
//				else 
//				{
//					playIt(action,direction,loop,completeFunc,completeParam);
//				}
			}
			else 
			{
				if(completeFunc!=null)	completeFunc(completeParam);
			}

		}
		
		private function playIt(action:int,direction:int=-1,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null):void
		{
			_completeFunc=completeFunc;
			_completeParam=completeParam;
			var movieData:ATFMovieData;
			if(action<=5&&actionData)  //普通  动作   包含普通攻击动作
			{
				if(actionData.dataDict[action])
				{
					movieData=actionData.dataDict[action][direction];
					if(movieData)
					{
						///设置像素源
						_movie.setAtlas(movieData.bitmapData);
						///设置贴图
						_movie.setFlashTexture(movieData.getTexture());
						playInit(movieData,oppsiteX,loop,actionData.getLoopTime());
					}
				}
			}
		}
		
		
		
		
		
	}
}