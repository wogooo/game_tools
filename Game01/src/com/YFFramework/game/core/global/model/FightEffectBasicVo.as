package com.YFFramework.game.core.global.model
{
	/**  特效表fightEffect.json 的数据结构
	 * 2012-9-3 下午5:05:52
	 *@author yefeng
	 */
	public class FightEffectBasicVo
	{
		/**  技能id 
		 */	
		public var  id :int;
		/** 攻击者动作播放   时间轴     为的是多次受击  产生打击感
		 */ 
		public var atkTimeArr:Array;

		/**播放攻击动作的总时间 指的是 人物动画的播放
		 */ 
		public var atkTotalTimes:int;
		
		/**  攻击者上层特效id
		 */		
		public var atkFrontId :int;
		
		/**攻击者的上层特效技能是否具有方向 类型  在TypeSKill里面    1  表示 有方向  2 表示没方向
		 */ 
		public var atkFrontDirection:int;
		/**攻击者上层特效时间轴 
		 */		
		public var atkFrontTimeArr:Array;
		/**攻击者上层特效的总时间
		 */		
	//	public var atkFrontTotalTimes :int;
		/** 攻击者下层特效id
		 */
		public var atkBackId :int;
		/**攻击者下层特效播放时间轴
		 */
		public var atkBackTimeArr:Array;
		/** 攻击者下层特效总时间
		 */
	//	public var atkBackTotalTimes :int;

		
		/**受击者上层动画 的 皮肤id 
		 */		
		public var uAtkFrontId :int;

		/** 受击者动画时间轴     为的是多次受击  产生打击感
		 */
		public var uAtkTimeArr:Array;

		/**受击者上层动画时间轴
		 */		
		public var uAtkFrontTimeArr:Array;
		/**受击者上层动画播放的总时间
		 */
//		public var uAtkFrontTotalTimes :int;
		/**下层动画的资源id 
		 */
		public var uAtkBackId  :int;
		/**下层动画的播放时间轴
		 */
		public var uAtkBackTimeArr:Array;
		/**下层动画播放的总时间
		 */
	//	public var uAtkBackTotalTimes :int;

		/**天空层动画特效id 
		 */				
		public var skyId  :int;
		/** 天空层动画播放时间轴 
		 */		
		public var skyTimeArr:Array;
		/**天空层播放动画 的总时间
		 */		
	//	public var skyTotalTimes :int;
		/**坐标参照对象 值在TypeSKill里面  1 表示 以 攻击者为参照对象2 为被攻击者为参照对象   来进行 定位  参照对象坐标 加上   skyOffset偏移量
		 */ 
		public var skyPositionType:int
		/**坐标偏移量  x=[0] y=[1]  和 skyPositionType 配合使用 来确定 y 坐标 
		 */
		public var skyOffset:Array;
		/**地面层特效id 
		 */		
		public var floorId  :int;

		/**地面层动画播放时间轴
		 */		
		public var floorTimeArr:Array;
		/**地面动画播放的总时间
		 */
//		public var floorTotalTimes :int;
		/**坐标参照对象 值在TypeSKill里面  1 表示 以 攻击者为参照对象2 为被攻击者为参照对象   来进行 定位  参照对象坐标 加上   floorOffset偏移量
		 */		
		public var floorPositionType:int
		/**坐标偏移量  x=[0] y=[1]  和 floorPositionType 配合使用 来确定 y 坐标 
		 */		
		public var floorOffset:Array;

		public function FightEffectBasicVo()
		{
		}
	}
}