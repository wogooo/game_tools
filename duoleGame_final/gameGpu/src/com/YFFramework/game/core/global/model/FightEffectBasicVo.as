package com.YFFramework.game.core.global.model
{
	import com.YFFramework.core.ui.movie.data.TypeDirection;

	public class FightEffectBasicVo
	{

		public var effect_id:int;
		/** 技能类型  
		 */
		public var effect_type:int;

		public var atkFrontDirection:int;
		public var atkFloorId:int;
		public var atkSkyRotate:int;
		public var atkSkyTimeArr:Array;
		/** 天空层偏移量  只有作为飞行道具的时候才有用  atkSkyOffset[0]==x   atkSkyOffset[y]==y
		 */		
		public var atkSkyOffset:Array;
		/**飞行道具长度
		 */		
		public var atkSkySkillLen:int;
		
		public var atkFloorTimeArr:Array;
		public var atkBackId:int;
		public var atkBackTimeArr:Array;
		public var atkSkyId:int;
		public var atkTotalTimes:int;
		public var atkFrontId:int;
		public var atkTimeArr:Array;
		public var atkFrontTimeArr:Array;


		public var uAtkBackTimeArr:Array;
		public var uAtkSkyId:int;
		public var uAtkFloorId:int;
		public var uAtkTimeArr:Array;
		public var uAtkFrontTimeArr:Array;
		public var speed:int;
		public var uAtkFrontId:int;
		public var uAtkFloorTimeArr:Array;
		public var uAtkSkyTimeArr:Array;
		public var uAtkBackId:int;
//		/**血量是否拆分   1 表示拆分 2 表示不拆分   具体的值在TypeSkill.Blood_
//		 */		
//		public var bloodSplit:int;

		/**弹血数组
		 */
		public var bloodArr:Array;
		
		/** 背景 地面层特效 用于对点技能
		 */
		public var bgFloorId:int;
		
		/**地面层数组
		 */
		public var bgFloorTimeArr:Array;

		
		private var _skyOffesetArr:Array;
		
		
		/**粒子特效id 
		 */
		public var particle_id:int;
		
		public function FightEffectBasicVo()
		{
			_skyOffesetArr=[];
		}
		
		/**获取天空层 飞行道具的便宜量
		 */		
		public function getSkyOffset(direction:int):Array
		{
			return _skyOffesetArr[direction];
		}
		/**顺时针方向
		 */		
		public function initSkyOffset():void
		{
			_skyOffesetArr[TypeDirection.Up]=[atkSkyOffset[0],atkSkyOffset[1]];
			_skyOffesetArr[TypeDirection.RightUp]=[atkSkyOffset[2],atkSkyOffset[3]];
			_skyOffesetArr[TypeDirection.Right]=[atkSkyOffset[4],atkSkyOffset[5]];
			_skyOffesetArr[TypeDirection.RightDown]=[atkSkyOffset[6],atkSkyOffset[7]];
			_skyOffesetArr[TypeDirection.Down]=[atkSkyOffset[8],atkSkyOffset[9]];
			_skyOffesetArr[TypeDirection.LeftDown]=[-atkSkyOffset[6],atkSkyOffset[7]];
			_skyOffesetArr[TypeDirection.Left]=[-atkSkyOffset[4],atkSkyOffset[5]];
			_skyOffesetArr[TypeDirection.LeftUp]=[-atkSkyOffset[2],atkSkyOffset[3]];
			
		}
		
		
	}
}