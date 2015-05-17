
package com.YFFramework.core.utils.tween.game
{
	import com.YFFramework.core.center.pool.PoolCenter;
	
	import flash.geom.Point;

	/**贝塞尔行走   给出指定的路径进行直线运动
	 * @author yefeng
	 *2012-7-12下午10:36:49
	 */
	public class TweenBezier
	{
		private var _tweenLine:TweenTimeLine;
		private var _path:Array;
		private var _playLen:int;
		public function TweenBezier()
		{
			_tweenLine=new TweenTimeLine();
		}
		
		/**
		 * @param display  作用对象性
		 * @param propX  属性 x 
		 * @param propY  s属性y
		 * @param path   运动路径  格式  [Pt(x,y),Pt(x,y)]
		 * @param speed  速度
		 * @param updateFunc   更新函数
		 * @param updateFuncParam  更新函数参数   不能为空
		 * @param completeFunc 完成函数
		 * @param completeFuncParam  完成函数参数
		 * @param forceUpdate 强制渲染开始帧  表示 是否 一调用 就立刻开始 渲染 改变位置  
		 * 在 觉开始移动时 将其设置为false 角色在移动中调用该函数 需要强制渲染一帧  也就是其他玩家强制渲染一帧
		 *  以达到尽量与其他玩家同步     S_OtherRoleBeginMovePath 设置为false   S_otherRoleMoving 时 设置为true
		 */
		public function to(display:Object,propX:String,propY:String,path:Array,speed:Number=4,updateFunc:Function=null,completeFunc:Function=null,completeFuncParam:Object=null,forceUpdate:Boolean=false):void
		{
			_path=path;
			_playLen=_path.length;
			_tweenLine.identify();
			_tweenLine.completeFunc=completeFunc;
			_tweenLine.completeParam=completeFuncParam;
			var simple:TweenSimple;
			for each (var obj:Point in path )
			{
				simple=PoolCenter.Instance.getFromPool(TweenSimple) as TweenSimple;//new TweenSimple();
				simple.tweenTo(display,propX,propY,obj.x,obj.y,speed,null,null,updateFunc,obj,forceUpdate);
				_tweenLine.addTween(simple);
			}
			_tweenLine.start();
		}
		public function updateSpeed(speed:Number):void
		{
			_tweenLine.updateSpeed(speed);
		}

		/**摧毁数据
		 */ 
		public function destroy():void
		{
			if(_tweenLine)	_tweenLine.dispose();
		//	_tweenLine=null;
			_path=null;
		}
		
		public function dispose():void
		{
			destroy();
			_tweenLine=null;
		}
		
		
		/**返回当前正在播放的索引
		 */ 
		public function get playIndex():int
		{
			return _tweenLine.playIndex;
		}
		
		public function get path():Array
		{
			return _path;
		}
		
		public function get playLen():int
		{
			return _playLen;
		}
		
		/**
		 *获取将要播放的数组 
		 */
		public function getPlayPath(len:int=3):Array
		{
			var  arr:Array=[];
			var lastIndex:int=playIndex+len>playLen-1?playLen-1:playIndex+len;
			for (var i:int=playIndex;i<=lastIndex;++i)
			{
				arr.push(path[i]);
			}
			return arr;
		}
		
		/**开始
		 */		
		public function start():void
		{
			_tweenLine.start();
		}
		/**停止
		 */		
		public function stop():void
		{
			_tweenLine.stop();
		}
		
	}
}