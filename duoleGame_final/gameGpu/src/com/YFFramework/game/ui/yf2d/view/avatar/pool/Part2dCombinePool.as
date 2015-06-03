package com.YFFramework.game.ui.yf2d.view.avatar.pool
{
	import com.YFFramework.core.yf2d.extension.MountHeadPart;
	import com.YFFramework.core.yf2d.extension.RolePart2DView;
	import com.YFFramework.core.yf2d.extension.RolePartEffect2DView;
	import com.YFFramework.game.core.module.mapScence.world.view.player.AbsAnimatorView;
	import com.YFFramework.game.ui.yf2d.view.avatar.Part2DCombine;
	import com.YFFramework.game.ui.yf2d.view.avatar.reflection.FlexbleReflection;
	import com.YFFramework.game.ui.yf2d.view.avatar.reflection.SingleReflection;

	/**@author yefeng
	 * 2013 2013-7-5 下午6:42:09 
	 */
	public class Part2dCombinePool
	{
		//对象池 个数不过大要不然会影响应用程序
		
		
		/**    怪物 衣服
		 */		
		private static var _part2DCombineSimpleArr:Part2dCombineArray=new Part2dCombineArray(60);//    50   
		/**复杂的 带Y 坐标偏移的 部位类 只有翅膀使用
		 */		
		private static var _part2DCombineWingArr:Part2dCombineArray=new Part2dCombineArray(50);//100
		/**坐骑部位的 对象池
		 */		
		private static var _part2dCombineMountHeadArr:Part2dCombineArray=new Part2dCombineArray(30);//50
		/**人物  衣服
		 * 
		 */		
		private static var _part2DCombineClothArr:Part2dCombineArray=new Part2dCombineArray(60);//100
		
		/**人物武器 
		 */
		private static var _part2DCombineWeaponArr:Part2dCombineArray=new Part2dCombineArray(60);//100


		public function Part2dCombinePool()
		{
		}
		/**  影子 不会产生Y 坐标偏移的对象
		 */		
		public static function getPart2dCombineSimple(player:AbsAnimatorView):Part2DCombine
		{
			var cloth:Part2DCombine;
			if(_part2DCombineSimpleArr.length>0)
			{
				cloth=_part2DCombineSimpleArr.pop();
				cloth.initFromPool();
				cloth.initPlayer(player);
				cloth.initShadow();
				SingleReflection(cloth.reflectionClip).initReflection();
				 
			}
			else 
			{
				cloth=new Part2DCombine(player);
				cloth.mainClip=new RolePart2DView();
				cloth.reflectionClip=new SingleReflection();
			}
			return cloth;
		}
		/**影子 支持产生Y 坐标偏移的对象  只 对翅膀使用 
		 */		
		public static function getPart2dCombineWing(player:AbsAnimatorView):Part2DCombine
		{
			var part2DCombine:Part2DCombine;
			if(_part2DCombineWingArr.length>0)
			{
				part2DCombine=_part2DCombineWingArr.pop();
				part2DCombine.initFromPool();
				part2DCombine.initPlayer(player);
				part2DCombine.initShadow();
			}
			else 
			{
				part2DCombine=new Part2DCombine(player);
				part2DCombine.mainClip=new RolePart2DView();
				part2DCombine.reflectionClip=new FlexbleReflection();
			}
			return part2DCombine;
		}
		
		/**影子 支持产生Y 坐标偏移的对象   模型部位带有光效  对人物 衣服起作用
		 */		
		public static function getPart2dCombineCloth(player:AbsAnimatorView):Part2DCombine
		{
			var part2DCombine:Part2DCombine;
			if(_part2DCombineClothArr.length>0)
			{
				part2DCombine=_part2DCombineClothArr.pop();
				part2DCombine.initFromPool();
				part2DCombine.initPlayer(player);
				part2DCombine.initShadow();
			}
			else 
			{
				part2DCombine=new Part2DCombine(player);
				part2DCombine.mainClip=new RolePartEffect2DView();
				part2DCombine.reflectionClip=new FlexbleReflection();
			}
			return part2DCombine;
		}
		
		/**影子  对武器  
		 */		
		public static function getPart2dCombineWeapon(player:AbsAnimatorView):Part2DCombine
		{
			var part2DCombine:Part2DCombine;
			if(_part2DCombineWeaponArr.length>0)
			{
				part2DCombine=_part2DCombineWeaponArr.pop();
				part2DCombine.initFromPool();
				part2DCombine.initPlayer(player);
				part2DCombine.initShadow();
			}
			else 
			{
				part2DCombine=new Part2DCombine(player);
				part2DCombine.mainClip=new RolePartEffect2DView();
				part2DCombine.reflectionClip=new SingleReflection();
			}
			return part2DCombine;
		}
		
		/** 引导 body的 方法
		 * @param guideBodyContainer
		 */		
		public static function getPart2dCombineMountHead(player:AbsAnimatorView,guideBodyContainer:Function):Part2DCombine
		{
			var mountHead:Part2DCombine;
			if(_part2dCombineMountHeadArr.length>0)
			{
				mountHead=_part2dCombineMountHeadArr.pop();
				mountHead.initFromPool();
				MountHeadPart(mountHead.mainClip).initUpdateFunc(guideBodyContainer);
				mountHead.initPlayer(player);
				mountHead.initShadow();
				SingleReflection(mountHead.reflectionClip).initReflection();
			}
			else 
			{
				mountHead=new Part2DCombine(player);
				mountHead.mainClip=new MountHeadPart(guideBodyContainer);
				mountHead.reflectionClip=new SingleReflection();
			}
			return mountHead;
		}
		/** 简单
		 */		
		public static function toPart2dCombineSimplePool(part2dCombine:Part2DCombine):void
		{
			if(_part2DCombineSimpleArr.canPush())
			{
				part2dCombine.disposeToPool();//释放其为对象池状态
				_part2DCombineSimpleArr.push(part2dCombine);
			}
			else part2dCombine.dispose();
		}
		
		/**复杂
		 */
		public static function toPart2dCombineWingPool(part2dCombine:Part2DCombine):void
		{
			if(_part2DCombineWingArr.canPush())
			{
				part2dCombine.disposeToPool();//释放其为对象池状态
				_part2DCombineWingArr.push(part2dCombine);
			}
			else part2dCombine.dispose();
		}
		
		/**衣服 
		 */
		public static function toPart2dCombineClothPool(part2dCombine:Part2DCombine):void
		{
			if(_part2DCombineClothArr.canPush())
			{
				part2dCombine.disposeToPool();//释放其为对象池状态
				_part2DCombineClothArr.push(part2dCombine);
			}
			else part2dCombine.dispose();
		}

		
		/**武器
		 */
		public static function toPart2dCombineWeaponPool(part2dCombine:Part2DCombine):void
		{
			if(_part2DCombineWeaponArr.canPush())
			{
				part2dCombine.disposeToPool();//释放其为对象池状态
				_part2DCombineWeaponArr.push(part2dCombine);
			}
			else part2dCombine.dispose();
		}
		
		/** 坐骑头部
		 */		
		public static function toPart2dCombineMountHeadPool(part2dCombine:Part2DCombine):void
		{
			if(_part2dCombineMountHeadArr.canPush())
			{
				part2dCombine.disposeToPool();//释放其为对象池状态
				_part2dCombineMountHeadArr.push(part2dCombine);
			}
			else part2dCombine.dispose();
		}
		
		
		
		
		
		
		
		
		////填满对象池
		
		/**填满对象池
		 */		
		private static function fillPart2DCombineSimplePool():void
		{
			
			///simpleArr
			var cloth:Part2DCombine;
			for(var i:int=0;i!=_part2DCombineSimpleArr.length;++i)
			{
				cloth=new Part2DCombine(null);
				cloth.mainClip=new RolePart2DView();
				cloth.reflectionClip=new SingleReflection();
				cloth.disposeToPool();
				_part2DCombineSimpleArr.push(cloth);
			}
		}
		
		private static function fillPart2DCombineWingPool():void
		{
			///flex
			var part2DCombine:Part2DCombine;
			for(var i:int=0;i!=_part2DCombineWingArr.length;++i)
			{
				part2DCombine=new Part2DCombine(null);
				part2DCombine.mainClip=new RolePart2DView();
				part2DCombine.reflectionClip=new FlexbleReflection();
				part2DCombine.disposeToPool();
				_part2DCombineWingArr.push(part2DCombine);
			}
		}
		/**衣服 
		 * 
		 */		
		private static function fillPart2DCombineClothPool():void
		{
			///flex
			var part2DCombine:Part2DCombine;
			for(var i:int=0;i!=_part2DCombineClothArr.length;++i)
			{
				part2DCombine=new Part2DCombine(null);
				part2DCombine.mainClip=new RolePartEffect2DView();
				part2DCombine.reflectionClip=new FlexbleReflection();
				part2DCombine.disposeToPool();
				_part2DCombineClothArr.push(part2DCombine);
			}
		}
		
		/**武器
		 */
		private static function fillPart2DCombineWeaponPool():void
		{
			///flex
			var part2DCombine:Part2DCombine;
			for(var i:int=0;i!=_part2DCombineWeaponArr.length;++i)
			{
				part2DCombine=new Part2DCombine(null);
				part2DCombine.mainClip=new RolePartEffect2DView();
				part2DCombine.reflectionClip=new SingleReflection();
				part2DCombine.disposeToPool();
				_part2DCombineWeaponArr.push(part2DCombine);
			}
		}
		
		/**坐骑
		 */		
		private static function fillPart2DCombineMountHeadPool():void
		{
			///flex
			var mountHead:Part2DCombine;
			for(var i:int=0;i!=_part2dCombineMountHeadArr.length;++i)
			{
				mountHead=new Part2DCombine(null);
				mountHead.mainClip=new MountHeadPart(null);
				mountHead.reflectionClip=new SingleReflection();
				mountHead.disposeToPool();
				_part2dCombineMountHeadArr.push(mountHead);
			}
		}
		
		
		
		/**初始化part2dPool对象池
		 */		
		public static function FillPart2dDCombinePool():void
		{
			fillPart2DCombineSimplePool();
			fillPart2DCombineWingPool();
			fillPart2DCombineClothPool();
			fillPart2DCombineWeaponPool();
			fillPart2DCombineMountHeadPool();
		}
		
	}
}