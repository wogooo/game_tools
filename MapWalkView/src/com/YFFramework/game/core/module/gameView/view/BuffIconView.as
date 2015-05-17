package com.YFFramework.game.core.module.gameView.view
{
	/**人物图像下面显示   buff图标
	 * @author yefeng
	 * 2013 2013-3-28 下午5:31:29 
	 */
	import com.YFFramework.core.net.loader.image_swf.IconLoader;
	import com.YFFramework.core.ui.abs.AbsView;
	import com.YFFramework.core.ui.container.HContainer;
	import com.YFFramework.game.core.global.manager.BuffBasicManager;
	import com.YFFramework.game.core.global.model.BuffBasicVo;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	public class BuffIconView extends HContainer
	{
		private var _dict:Dictionary;
		public function BuffIconView()
		{
			super(5,false);
		}
		override protected function initUI():void
		{
			super.initUI();
			_dict=new Dictionary();
		}
		/**添加buff图标
		 */		
		public function addBuffIcon(buffId:int):void
		{
			var url:String=BuffBasicManager.Instance.getBuffIconURL(buffId);
			if(_dict[url]==null)
			{
				var sp:AbsView=new AbsView(false);
				_dict[url]=sp;
				addChild(sp);
				var loader:IconLoader=new IconLoader();
				loader.initData(url,sp,url);
				loader.loadCompleteCallback=completeCallback;
			}
		}
		public function completeCallback(bitmap:Bitmap,obj:Object):void
		{
			updateView();
		}

		/**删除buff图标
		 */
		public function deleteBuffIcon(buffId:int):void
		{
			var url:String=BuffBasicManager.Instance.getBuffIconURL(buffId);
			var sp:AbsView=_dict[url] as AbsView;
			if(sp)
			{
				if(contains(sp)) removeChild(sp);
				sp.dispose();
			}
			_dict[url]=null;
			delete _dict[url];
		}
		
	}
}