package com.YFFramework.game.ui.yf2d.view.avatar.reflection
{
	import com.YFFramework.core.ui.movie.data.TypeAction;
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;
	import com.YFFramework.core.yf2d.extension.face.IReflection;
	import com.YFFramework.core.yf2d.extension.ShadowClip;

	/** 倒影类 该 倒影类 用于怪物 NPC     也就是 只具有一个部位的对象    该对象  一般不进行x  y 设置  
	 * @author yefeng
	 * 2013 2013-6-20 下午12:57:46 
	 */
	public class SingleReflection extends ShadowClip implements IReflection
	{
		/** 不能 设置 x  y 属性
		 */		
		public function SingleReflection()
		{
			initReflection();
		}
		override public function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null, completeParam:Object=null, resetPlay:Boolean=false):void
		{
			if(!_isDispose)
			{
				if(action==TypeAction.Dead)	action=TypeAction.Injure;  //怪物不 包含死亡动作
				super.play(action, direction, loop, completeFunc, completeParam, resetPlay);
			}
		}
		/**创建影子矩阵
		 */		
		public function initReflection():void
		{
			//设置  参数 
			alpha=0.4;
			localModelMatrix=Part2DCombine.ReflectionMatrix.clone();
			uvScaleY=-1;
		}
		
	}
}