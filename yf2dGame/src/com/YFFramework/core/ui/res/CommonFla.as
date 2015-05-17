package com.YFFramework.core.ui.res
{
	import com.YFFramework.core.ui.yf2d.data.YF2dActionData;
	import com.YFFramework.core.ui.yfComponent.controls.YFCDData;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.Texture;
	
	import yf2d.textures.TextureHelper;
	import yf2d.textures.sprite2D.SimpleTexture2D;
	

	/** 资源链接类名
	 * @author yefeng
	 *2012-6-24下午3:29:24
	 */
	public class CommonFla
	{
		public static const Shadow:String="Shadow";
		/**show 阴影 数据
		 */		
		public static var  ShadowTexture:ResSimpleTexture;
		
		/** 人物 替代皮肤  也就是人物皮肤没有下载完全时显示的皮肤  这里是鸡蛋图片
		 */		
		public static var RoleFakeSkin:ResSimpleTexture;

		/**掉落物品的默认皮肤
		 */ 
		public static var DropGoodsFakeSkin:ResSimpleTexture;

		/**人物血条框
		 */		
		public static var BloodFrameSkin:ResSimpleTexture;
		/**人物血条进度
		 */
		public static var BloodProgressSKin:ResSimpleTexture;
		
		
		
		
		
		
		/** 鼠标点击场景产生的效果数据
		 */		
//		public static var ClickEffectActionData:YF2dActionData;

		public function CommonFla()
		{
		}
		/** 初始化 common fla文件的各个元件 
		 */		
		public static function initUI():void
		{
			////影子
//			var shodowData:BitmapData=ClassInstance.getInstance(Shadow) as BitmapData;
//			ShadowFrameData=new BitmapFrameData();
//			ShadowFrameData.x=-shodowData.width*0.5;
//			ShadowFrameData.y=-shodowData.height*0.5;
//			ShadowFrameData.textureData=new MovieTextureData(); 
			
				
			////创建  人物没有下载完时的替代皮肤 鸡蛋
//			var roleFakeData:BitmapData=ClassInstance.getInstance("roleFakeSkin") as BitmapData;
//			RoleFakeSkin=new BitmapDataEx();
//			RoleFakeSkin.bitmapData=roleFakeData;
//			RoleFakeSkin.x=-roleFakeData.width*0.5;
//			RoleFakeSkin.y=-roleFakeData.height+10;
//			
//			///掉落物品的替代皮肤 
//			var dropGoodsData:BitmapData=ClassInstance.getInstance("dropGoodsFakeSkin") as BitmapData;
//			DropGoodsFakeSkin=new BitmapDataEx();
//			DropGoodsFakeSkin.bitmapData=dropGoodsData;
//			DropGoodsFakeSkin.x=-dropGoodsData.width*0.5;
//			DropGoodsFakeSkin.y=-dropGoodsData.height*0.5;
			
			
//			var mc:MovieClip=ClassInstance.getInstance("ClickEffectMc") as MovieClip;
//			ClickEffectActionData=Cast.MCToActionData(mc,30);
//			mc.stop();
//			mc=null;
			
			
			///初始化CD数据
			YFCDData.iniCD();  ////防止游戏进行中创建造成卡   因为他里面有 像素draw的过程  所以需要预先处理
			////初始化文本数字
			ImageTextManager.Instance; ////防止游戏进行中创建造成卡 因为他里面有 像素draw的过程  所以需要预先处理
			

		}

		/**出来加载进来的res文件 进行解析成游戏需要的  阴影  以及人物替代图片
		 */		
		public static function initRes(data:Object):void
		{
			var head:Object=data.head;  ///  {x   y   w    h  信息 }
			var bitmapData:BitmapData=data.bitmapData;
			var texture:Texture=TextureHelper.Instance.getTexture(bitmapData);
			///创建 阴影
			var shodowObj:Object=head["shadowSkin"];
			ShadowTexture=new ResSimpleTexture();
			ShadowTexture.setTextureRect(shodowObj.x,shodowObj.y,shodowObj.w,shodowObj.h);
			ShadowTexture.setUVData(Vector.<Number>([shodowObj.x/bitmapData.width,shodowObj.y/bitmapData.height,shodowObj.w/bitmapData.width,shodowObj.h/bitmapData.height]));
			ShadowTexture.x=-shodowObj.w*0.5;
			ShadowTexture.y=-shodowObj.h*0.5;
			ShadowTexture.atlasData=bitmapData;
			ShadowTexture.flashTexture=texture;
			///创建 人物替代物品
			var roleSKin:Object=head["roleSkin"];
			RoleFakeSkin=new ResSimpleTexture();
			RoleFakeSkin.setTextureRect(roleSKin.x,roleSKin.y,roleSKin.w,roleSKin.h);
			RoleFakeSkin.setUVData(Vector.<Number>([roleSKin.x/bitmapData.width,roleSKin.y/bitmapData.height,roleSKin.w/bitmapData.width,roleSKin.h/bitmapData.height]));
//			RoleFakeSkin.x=-roleSKin.w*0.5;
//			RoleFakeSkin.y=-roleSKin.h+10;
			
			RoleFakeSkin.x=0;
			RoleFakeSkin.y=-roleSKin.h*0.5-10;
			RoleFakeSkin.atlasData=bitmapData;
			RoleFakeSkin.flashTexture=texture;
			///创建  掉落替代物品
			var dropObj:Object=head["dropSkin"];
			DropGoodsFakeSkin=new ResSimpleTexture();
			DropGoodsFakeSkin.setTextureRect(dropObj.x,dropObj.y,dropObj.w,dropObj.h);
			DropGoodsFakeSkin.setUVData(Vector.<Number>([dropObj.x/bitmapData.width,dropObj.y/bitmapData.height,dropObj.w/bitmapData.width,dropObj.h/bitmapData.height]));
//			DropGoodsFakeSkin.x=-dropObj.w*0.5
//			DropGoodsFakeSkin.y=-dropObj.h*0.5;
			DropGoodsFakeSkin.atlasData=bitmapData;
			DropGoodsFakeSkin.flashTexture=texture;
			////创建人物血条框
			var bloodFrameObj:Object=head["bloodFrame"];
			BloodFrameSkin=new ResSimpleTexture();
			BloodFrameSkin.setTextureRect(bloodFrameObj.x,bloodFrameObj.y,bloodFrameObj.w,bloodFrameObj.h);
			BloodFrameSkin.setUVData(Vector.<Number>([bloodFrameObj.x/bitmapData.width,bloodFrameObj.y/bitmapData.height,bloodFrameObj.w/bitmapData.width,bloodFrameObj.h/bitmapData.height]));
			BloodFrameSkin.x=0;
			BloodFrameSkin.y=0;
			BloodFrameSkin.atlasData=bitmapData;
			BloodFrameSkin.flashTexture=texture;
			///创建人物血条 进度条
			var bloodProgress:Object=head["bloodProgress"];
			BloodProgressSKin=new ResSimpleTexture();
			BloodProgressSKin.setTextureRect(bloodProgress.x,bloodProgress.y,bloodProgress.w,bloodProgress.h);
			BloodProgressSKin.setUVData(Vector.<Number>([bloodProgress.x/bitmapData.width,bloodProgress.y/bitmapData.height,bloodProgress.w/bitmapData.width,bloodProgress.h/bitmapData.height]));
			BloodProgressSKin.x=0;
			BloodProgressSKin.y=0;
			BloodProgressSKin.atlasData=bitmapData;
			BloodProgressSKin.flashTexture=texture;
			
			///创建人物聊天 冒泡
		//	ChatArrowL
			
//			var chatArrrowL_LTObj:Object=head["chatArrowL_LT"];
//			var chatArrrowL_LTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_LTTexture.setTextureRect(chatArrrowL_LTObj.x,chatArrrowL_LTObj.y,chatArrrowL_LTObj.w,chatArrrowL_LTObj.h);
//			
//			var chatArrrowL_LCObj:Object=head["chatArrowL_LC"];
//			var chatArrrowL_LCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_LCTexture.setTextureRect(chatArrrowL_LCObj.x,chatArrrowL_LCObj.y,chatArrrowL_LCObj.w,chatArrrowL_LCObj.h);
//
//			var chatArrrowL_LBObj:Object=head["chatArrowL_LB"];
//			var chatArrrowL_LBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_LBTexture.setTextureRect(chatArrrowL_LBObj.x,chatArrrowL_LBObj.y,chatArrrowL_LBObj.w,chatArrrowL_LBObj.h);
//			
//			var chatArrrowL_CTObj:Object=head["chatArrowL_CT"];
//			var chatArrrowL_CTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_CTTexture.setTextureRect(chatArrrowL_CTObj.x,chatArrrowL_CTObj.y,chatArrrowL_CTObj.w,chatArrrowL_CTObj.h);
//			
//			var chatArrrowL_CCObj:Object=head["chatArrowL_CC"];
//			var chatArrrowL_CCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_CCTexture.setTextureRect(chatArrrowL_CCObj.x,chatArrrowL_CCObj.y,chatArrrowL_CCObj.w,chatArrrowL_CCObj.h);
//			
//			var chatArrrowL_CBObj:Object=head["chatArrowL_CB"];
//			var chatArrrowL_CBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_CBTexture.setTextureRect(chatArrrowL_CBObj.x,chatArrrowL_CBObj.y,chatArrrowL_CBObj.w,chatArrrowL_CBObj.h);
//			
//			var chatArrrowL_RTObj:Object=head["chatArrowL_RT"];
//			var chatArrrowL_RTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_RTTexture.setTextureRect(chatArrrowL_RTObj.x,chatArrrowL_RTObj.y,chatArrrowL_RTObj.w,chatArrrowL_RTObj.h);
//			
//			var chatArrrowL_RCObj:Object=head["chatArrowL_RC"];
//			var chatArrrowL_RCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_RCTexture.setTextureRect(chatArrrowL_RCObj.x,chatArrrowL_RCObj.y,chatArrrowL_RCObj.w,chatArrrowL_RCObj.h);
//			
//			var chatArrrowL_RBObj:Object=head["chatArrowL_RB"];
//			var chatArrrowL_RBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowL_RBTexture.setTextureRect(chatArrrowL_RBObj.x,chatArrrowL_RBObj.y,chatArrrowL_RBObj.w,chatArrrowL_RBObj.h);
//
//			///chatArrowR
//			var chatArrrowR_LTObj:Object=head["chatArrowR_LT"];
//			var chatArrrowR_LTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_LTTexture.setTextureRect(chatArrrowR_LTObj.x,chatArrrowR_LTObj.y,chatArrrowR_LTObj.w,chatArrrowR_LTObj.h);
//			
//			var chatArrrowR_LCObj:Object=head["chatArrowR_LC"];
//			var chatArrrowR_LCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_LCTexture.setTextureRect(chatArrrowR_LCObj.x,chatArrrowR_LCObj.y,chatArrrowR_LCObj.w,chatArrrowR_LCObj.h);
//			
//			var chatArrrowR_LBObj:Object=head["chatArrowR_LB"];
//			var chatArrrowR_LBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_LBTexture.setTextureRect(chatArrrowR_LBObj.x,chatArrrowR_LBObj.y,chatArrrowR_LBObj.w,chatArrrowR_LBObj.h);
//			
//			var chatArrrowR_CTObj:Object=head["chatArrowR_CT"];
//			var chatArrrowR_CTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_CTTexture.setTextureRect(chatArrrowR_CTObj.x,chatArrrowR_CTObj.y,chatArrrowR_CTObj.w,chatArrrowR_CTObj.h);
//			
//			var chatArrrowR_CCObj:Object=head["chatArrowR_CC"];
//			var chatArrrowR_CCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_CCTexture.setTextureRect(chatArrrowR_CCObj.x,chatArrrowR_CCObj.y,chatArrrowR_CCObj.w,chatArrrowR_CCObj.h);
//			
//			var chatArrrowR_CBObj:Object=head["chatArrowR_CB"];
//			var chatArrrowR_CBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_CBTexture.setTextureRect(chatArrrowR_CBObj.x,chatArrrowR_CBObj.y,chatArrrowR_CBObj.w,chatArrrowR_CBObj.h);
//			
//			var chatArrrowR_RTObj:Object=head["chatArrowR_RT"];
//			var chatArrrowR_RTTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_RTTexture.setTextureRect(chatArrrowR_RTObj.x,chatArrrowR_RTObj.y,chatArrrowR_RTObj.w,chatArrrowR_RTObj.h);
//			
//			var chatArrrowR_RCObj:Object=head["chatArrowR_RC"];
//			var chatArrrowR_RCTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_RCTexture.setTextureRect(chatArrrowR_RCObj.x,chatArrrowR_RCObj.y,chatArrrowR_RCObj.w,chatArrrowR_RCObj.h);
//			
//			var chatArrrowR_RBObj:Object=head["chatArrowR_RB"];
//			var chatArrrowR_RBTexture:SimpleTexture2D=new SimpleTexture2D();
//			chatArrrowR_RBTexture.setTextureRect(chatArrrowR_RBObj.x,chatArrrowR_RBObj.y,chatArrrowR_RBObj.w,chatArrrowR_RBObj.h);
			
			
			
		}
		
		
		
	}
}