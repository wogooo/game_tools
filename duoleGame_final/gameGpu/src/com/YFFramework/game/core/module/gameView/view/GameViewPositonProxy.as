package com.YFFramework.game.core.module.gameView.view
{
	import com.YFFramework.core.proxy.StageProxy;
	
	import flash.geom.Point;

	/**存储  UI 部位的坐标
	 * @author yefeng
	 * 2013 2013-8-29 下午3:45:56 
	 */
	public class GameViewPositonProxy
	{
		private static var _pivot:Point=new Point();
		/**背包 按钮坐标
		 */		
		public static var BagX:Number;
		public static var BagY:Number;
		
		
		/**宠物按钮坐标
		 */
		public static var PetX:Number;
		public static var PetY:Number;
		
		
		
		/**技能x 
		 */
		public static var SKillX:Number;
		/**技能Y 
		 */		
		public static var SkillY:Number;
		
		/**好友坐标 x
		 */		
		public static var FriendX:Number;
		/**好友坐标y 
		 */
		public static var FriendY:Number;
		
		
		/**翅膀坐标 x
		 */		
		public static var WingX:Number;
		/**翅膀坐标y 
		 */
		public static var WingY:Number;

		
		
		/**坐骑坐标 x
		 */		
		public static var MountX:Number;
		/**坐骑坐标y 
		 */
		public static var MountY:Number;
		
		
		/**商城x 坐标
		 */
		public static var MallX:Number;
		
		/**商城y坐标
		 */
		public static var MallY:Number;
		
		/**组队 x y 
		 */
		public static var TeamX:Number;
		public static var TeamY:Number;
		
		/**市场 x   y 
		 */		
		public static var MarketX:Number;
		public static var MarketY:Number;

		/**工会 x y 
		 */
		public static var GuildX:Number;
		public static var GuildY:Number;
		
		
		/**锻造面板x 
		 */
		public static var ForageX:Number;
		/**锻造面板y
		 */
		public static var ForageY:Number;

		
		
		/** x方向偏移量   与舞台中央的偏移
		 */
		private static const OffsetX:int=200;
		/**  y方向偏移量与舞台中央的偏移
		 */
		private static const OffsetY:int=120;
		
		
		
		/**获取移动轴点吗用于奖励道具 飞行到的目标点
		 */
		public static function getMovePivot():Point
		{
			_pivot.x=StageProxy.Instance.getWidth()*0.5+OffsetX;
			_pivot.y=StageProxy.Instance.getHeight()*0.5+OffsetY;
			if(_pivot.x>=StageProxy.Instance.getWidth())_pivot.x=StageProxy.Instance.getWidth()*0.5;
			if(_pivot.y>=StageProxy.Instance.getHeight())_pivot.y=StageProxy.Instance.getHeight()*0.5;
			return _pivot
		}
		
		public function GameViewPositonProxy()
		{
		}
	}
}
