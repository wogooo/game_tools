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
		public var dyId:String;
		
		/**静态id 
		 */ 
		public var basicId:int;
		/**血量
		 */
		public var hp:int;
		
		/**已经装备的部位 长度固定           没有装备的部位的值为 0  装备了的部位的值为其具体的id 值.
		 *  怪物类型的 的 equipedArr 长度为  1      人物角色的为  TypeModel.ModelLen  
		 */
		public var equipedArr:Vector.<String>;
		
		/**  角色大的类型     角色大类型    值在TypeRole里面  
		 */
		public var bigCatergory:int;
		/**角色移动的速度
		 */
		public var speed:int;
		
		public function MonsterDyVo()
		{
			super();
			bigCatergory=TypeRole.BigCategory_Monster;
			initData();
		}
		
		protected function initData():void
		{
			equipedArr=new Vector.<String>(1,true);
		}
			
	}
}