package com.YFFramework.core.world.model
{
	import com.YFFramework.core.world.model.type.TypeRole;

	/** 怪物 vo  不同的角色类型      bigCatergory是不一样的
	 * 012-7-25 下午7:58:30
	 *@author yefeng
	 */
	public class MonsterDyVo extends EffectMovieVo
	{
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
		
		public function MonsterDyVo()
		{
			super();
			bigCatergory=TypeRole.BigCategory_Monster;
		}
		
			
	}
}