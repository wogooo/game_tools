package com.YFFramework.core.world.movie.face
{
	import flash.geom.Point;

	/** 游戏中能进行移动的对象必须要实现的接口      实现这个接口的类 有   AnimatorView  ThingEffectView  
	 * 2012-7-20 下午3:17:29
	 *@author yefeng
	 */
	public interface IMoving
	{
		/**   按照指定的路径进行移动
		 * @param path
		 * @param speed
		 * @param completeFunc
		 * @param completeParam
		 */
		function sMoveTo(path:Array,speed:Number=5,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void;
		/** 移动到目标点 mapX  mapY 
		 * @param mapX
		 * @param mapY
		 * @param speed
		 * @param completeFunc
		 * @param completeParam
		 * @param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置
		 * 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		 *  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true
		 * 
		 * @param breakFunc 该函数中断后 执行的方法 也就是 completeFunc没有执行  就终止了 时 执行 breakFunc方法
		 * @pamra breakParam参数
		 */
		  
		function moveTo(mapX:int,mapY:int,speed:Number=4,completeFunc:Function=null,completeParam:Object=null,forceUpdate:Boolean=false):void;
		/**  设置 地图坐标
		 * @param mapX
		 * @param mapY
		 * 
		 */
		function setMapXY(mapX:int,mapY:int):void;
	}
}