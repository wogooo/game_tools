package com.YFFramework.game.core.global.model
{
	/**   保存的是skin表的数据模型
	 * 2012-8-15 下午3:06:51
	 *@author yefeng
	 */
	public class SkinVo
	{
		/**资源 id  唯一标志 id
		 */
		public var resId:int;
		/**物品 图标id  根据 id 可以在相应的目录拿到对应的资源
		 */
		public var iconId:int;
		/** 正常状态下的 皮肤 id  比如衣服正常状态下 的id   或者技能的 资源 id 
		 */
		public var normalSkinId:int;
		/**  坐骑状态下的皮肤id 
		 */
		public var mountSkinId:int;
		/**打坐状态下的皮肤
		 */		
		public var sitSkinId:int;
		
		/**掉落物品的皮肤id  该物品在场景中显示的皮肤
		 */ 
		public var dropGoodsSkinId:int;
		
		/** 资源类型 默认的 为1 
		 *  技能资源需要判断是否分方向
		 */		
		public function SkinVo()
		{
		}
	}
}