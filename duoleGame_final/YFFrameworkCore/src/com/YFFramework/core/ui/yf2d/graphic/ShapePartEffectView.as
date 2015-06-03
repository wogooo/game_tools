package com.YFFramework.core.ui.yf2d.graphic
{
	/**@author yefeng
	 * 2013 2013-8-17 下午6:07:24 
	 */
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.movie.data.ActionData;
	
	public class ShapePartEffectView extends AbsView implements IGraphicPlayer
	{
		
		/** actionData  part 数据
		 */
		public var actionData:ActionData;
		
		/**光效数据
		 */
		public var effectActionData:ActionData;
		
		private var _part:ShapeMovieClip;
		private var _effect:ShapeMovieClip;
		public function ShapePartEffectView()
		{
			super(false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_part=new ShapeMovieClip();
			addChild(_part);
			_effect=new ShapeMovieClip();
			addChild(_effect);
		}
		
		/**更新  模型
		 */		
		public function initData(actionData:ActionData):void
		{
			_part.initData(actionData);
			this.actionData=actionData;
		}
		
		/**更新特效
		 */		
		public function initEffectActionData(actionData:ActionData):void
		{
			effectActionData=actionData;
			if(actionData)	
			{
				_effect.initData(actionData);
			}
			else  //null
			{
				_effect.initData(null);
				_effect.clear();
			} 
		}
		
		
		public function start():void
		{
			_part.start();
			_effect.start();
		}
		
		public function stop():void
		{
			_part.stop(); 
			_effect.stop();
		}
		
		public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false):void
		{
			if(_part.actionData)_part.play(action,direction,loop,completeFunc,completeParam,resetPlay);
			if(_effect.actionData)
			{
				_effect.start();
				_effect.play(action,direction,loop,null,null,resetPlay);
			}
			else 
			{
				_effect.stop();
				_effect.graphics.clear();
			}
		}
		
		public function clear():void
		{
			_part.clear();
			_effect.clear();
		}
		
	}
}