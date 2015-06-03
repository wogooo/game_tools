package com.YFFramework.game.ui.imageText.scrollNum
{
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	import com.YFFramework.game.ui.imageText.TypeImageText;
	
	import flash.display.BitmapData;

	/**生成滚动文本
	 * @author yefeng
	 * 2013 2013-7-18 上午10:26:34 
	 */
	public class NumTextFactory
	{
		public function NumTextFactory()
		{
		}
		
		/**获取 numTextPlayer
		 */		
		public static function getNumTextPlayer():NumTextPlayer
		{
			var numTextPlayer:NumTextPlayer=new NumTextPlayer();
			var arr:Vector.<BitmapData>=ImageTextManager.Instance.getNumArr(TypeImageText.ACTIVITY_NUM_BIG);
			numTextPlayer.initData(arr,arr[0].width,arr[1].height);
//			numTextPlayer.x=600;
//			numTextPlayer.y=750;
//			numTextPlayer.completeCall=completeCall
//			numTextPlayer.completeParam=[numTextPlayer]
//			numTextPlayer.playTo(0,153,1);
			return numTextPlayer;
		}
		
		
	}
}