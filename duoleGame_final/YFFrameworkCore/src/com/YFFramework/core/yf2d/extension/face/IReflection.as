package com.YFFramework.core.yf2d.extension.face
{
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.ui.yf2d.data.ATFBitmapFrame;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	
	/**倒影类 接口  有两个实现者  一个 是FlexbleReflection  用于 怪物  的 倒影 
	 *  一个是SingleReflection  用于  玩家的倒影
	 * @author yefeng
	 * 2013 2013-6-20 下午12:46:30 
	 */

	public interface IReflection
	{
		function initActionDataStandWalk(data:ATFActionData):void;	
		
		function initActionDataFight(data:ATFActionData):void;	

		function initActionDataInjureDead(data:ATFActionData):void;	
  
		
		/**特殊攻击动作1
		 */		
		function initActionDataAtk_1(data:ATFActionData):void;
		/**战斗待机
		 */		
		function initActionDataFightStand(data:ATFActionData):void;
		
		function setBitmapFrame(bitmapFrameData:ATFBitmapFrame,texture:TextureBase,atlasData:BitmapData,scaleX:Number=1):void;
		function play(action:int, direction:int=-1, loop:Boolean=true, completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=false):void;
		
		function start():void;
		function stop():void;
		function playDefault(loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void;
		function playDefaultAction(direction:int,loop:Boolean=true,completeFunc:Function=null,completeParam:Object=null,resetPlay:Boolean=true):void;
		function pureStop():void;
		
		function gotoAndStop(index:int,action:int,direction:int):void;
		function resetData():void;
		
		function get x():Number;
		
		function get y():Number;
		
		function setXY(mX:Number,mY:Number):void;
//		function set x(value:Number):void;
//		function set y(value:Number):void;

		
		
		/**释放成对象池状态
		 */		
		function disposeToPool():void;
		/**  从对象池状态初始化
		 */		
		function initFromPool():void;
	}
}