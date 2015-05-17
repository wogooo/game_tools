package com.YFFramework.core.ui.res
{
	import com.YFFramework.core.ui.movie.data.ActionData;
	import com.YFFramework.core.ui.movie.data.BitmapDataEx;
	import com.YFFramework.core.ui.yfComponent.controls.YFCDData;
	import com.YFFramework.core.utils.common.ClassInstance;
	import com.YFFramework.core.utils.image.Cast;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	
	import flash.display.BitmapData;
	import flash.display.MovieClip;

	/** 资源链接类名
	 * @author yefeng
	 *2012-6-24下午3:29:24
	 */
	public class CommonFla
	{
		public static const Shadow:String="Shadow";
		/**show 阴影 数据
		 */		
		public static var  ShadowBitmapDataEx:BitmapDataEx;
		/** 鼠标点击场景产生的效果数据
		 */		
		public static var ClickEffectActionData:ActionData;
		/** 人物 替代皮肤  也就是人物皮肤没有下载完全时显示的皮肤  这里是鸡蛋图片
		 */		
		public static var RoleFakeSkin:BitmapDataEx;
		
		/**掉落物品的默认皮肤
		 */ 
		public static var DropGoodsFakeSkin:BitmapDataEx;
		public function CommonFla()
		{
		}
		/** 初始化 common fla文件的各个元件 
		 */		
		public static function initUI():void
		{
			////影子
			var shodowData:BitmapData=ClassInstance.getInstance(Shadow) as BitmapData;
			ShadowBitmapDataEx=new BitmapDataEx();
			ShadowBitmapDataEx.bitmapData=shodowData;
			ShadowBitmapDataEx.x=-shodowData.width*0.5;
			ShadowBitmapDataEx.y=-shodowData.height*0.5;
			
			
			var mc:MovieClip=ClassInstance.getInstance("ClickEffectMc") as MovieClip;
			ClickEffectActionData=Cast.MCToActionData(mc,30);
			mc.stop();
			mc=null;
			///初始化CD数据
			YFCDData.iniCD();  ////防止游戏进行中创建造成卡   因为他里面有 像素draw的过程  所以需要预先处理
			////初始化文本数字
			ImageTextManager.Instance; ////防止游戏进行中创建造成卡 因为他里面有 像素draw的过程  所以需要预先处理
			
			////创建  人物没有下载完时的替代皮肤 鸡蛋
			var roleFakeData:BitmapData=ClassInstance.getInstance("roleFakeSkin") as BitmapData;
			RoleFakeSkin=new BitmapDataEx();
			RoleFakeSkin.bitmapData=roleFakeData;
			RoleFakeSkin.x=-roleFakeData.width*0.5;
			RoleFakeSkin.y=-roleFakeData.height+10;
			
			///掉落物品的替代皮肤 
			var dropGoodsData:BitmapData=ClassInstance.getInstance("dropGoodsFakeSkin") as BitmapData;
			DropGoodsFakeSkin=new BitmapDataEx();
			DropGoodsFakeSkin.bitmapData=dropGoodsData;
			DropGoodsFakeSkin.x=-dropGoodsData.width*0.5;
			DropGoodsFakeSkin.y=-dropGoodsData.height*0.5;
		}
	}
}