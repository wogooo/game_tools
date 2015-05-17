package com.YFFramework.game.core.global.util
{
	import com.YFFramework.core.ui.layer.LayerManager;

	/**@author yefeng
	 * 2013 2013-3-21 上午9:46:17 
	 * 所有的文字提示 调用累
	 */
	public class NoticeUtil
	{
		public function NoticeUtil()
		{
		}
		
		/**操作 成功 或者失败的文字提示 
		 */
		public static function setOperatorNotice(str:String):void
		{
			LayerManager.NoticeLayer.setOperatorNotice(str);
		}
	}
}