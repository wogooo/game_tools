package com.YFFramework.game.core.module.mapScence.world.model
{
	import com.YFFramework.game.core.module.mapScence.world.model.type.TypeRole;

	/** 角色vo    也就是场景对象上活动对象vo 
	 * @author yefeng
	 *2012-4-22上午11:09:54
	 */
	public class RoleDyVo 
	{
		
		/// monsterDyVo  数据 
		
		/**角色名称
		 */
		public var roleName:String;
		
		/**动态id 所有 的动态 id都是字符串类型 
		 */
		public var dyId:uint;
		
		/**静态id 
		 */ 
		public var basicId:int;
		/**血量
		 */
		public var hp:int;	//宠物不要用这个访问
		/**最大 hp
		 */
		public var maxHp:int;
		/**魔法值 
		 */		
		public var mp:int;
		/**最大魔法值
		 */		
		public var maxMp:int;
		/**等级 
		 */		
		public var level:int;
		
		/**已经装备的部位 长度固定           没有装备的部位的值为 0  装备了的部位的值为其具体的id 值.
		 *  怪物类型的 的 equipedArr 长度为  1      人物角色的为  TypeModel.ModelLen  
		 */
		
		/**  角色大的类型     角色大类型    值在TypeRole里面  
		 */
		public var bigCatergory:int;
		/**角色移动的速度  每帧频率的移动速度
		 */
		public var speed:Number;

		///effectMovieVo
		/** 角色 地图 x坐标
		 */
		public var mapX:int=0;
		/** 角色的地图y坐标
		 */
		public var mapY:int=0;
		
		////
		/**是否在坐骑上 值为 TypeRole.Player__里面  三种状态 正常  坐骑  打坐 三种状态
		 */
		public var state:int;
		/**人物性别 
		 */
		public var sex:int;
		
		/**职业
		 */
		public var career:int;
		/**为 物品道具时 需要一个itemType  值 在TypeProps   ITEM_TYPE_EQUIP
		 */		
		public var itemType:int;
		/**处于切磋状态 的切磋对象id 
		 */		
		public var competeId:int;
		/**名字  颜色   值为  TypeRole.  NameColor_White
		 */		
		public var nameColor:int;
		
		/**假如为宠物 ，则 该id 为该宠物的主人的id 
		 */		
		public var ownId:int;
		
		/**玩家    衣服静态id 
		 */		
		public var clothBasicId:int;
		/** 武器静态 id
		 */		
		public var weaponBasicId:int;
		/**翅膀静态id 
		 */		
		public var wingBasicId:int;
		
		/** 衣服强化等级
		 */
		public var clothEnhanceLevel:int;
		/** 武器强化等级
		 */
		public var weaponEnhanceLevel:int;
		
		/**称号id 
		 */
		public var tittleId:int;
		
		
		/**阵营  ，无阵营 则值为  0   要想取阵营 则其值必须大于0   阵营信息, 阵营是0时没有该字段，1、2玩家阵营，3-敌对怪物阵营，4-中立阵营
		 * 值在typeRole.Camp_
		 */
		public var camp:int;
		
		
		/** vip等级
		 */		
		public var vipLevel:int;
		/**值在TypeRole.VipType_ 下 ,两个值：0-非年会vip；1-普通年费vip；2-年费vip
		 */
		public var vipType:int;
		
		
		/**游戏内部vip 
		 */
		public var gameVip:int;

		public function RoleDyVo()
		{
			bigCatergory=TypeRole.BigCategory_Player;
			competeId=-1;
		}
		
	}
}