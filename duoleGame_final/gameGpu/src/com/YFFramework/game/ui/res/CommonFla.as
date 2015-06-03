package com.YFFramework.game.ui.res
{
	import com.YFFramework.core.ui.yfComponent.controls.YFCDData;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.ResSimpleTexture;
	import com.YFFramework.game.ui.imageText.ImageTextManager;
	
	import flash.display.BitmapData;
	import flash.display3D.textures.TextureBase;
	import flash.geom.Matrix;
	

	/** 资源链接类名
	 * @author yefeng
	 *2012-6-24下午3:29:24
	 */
	public class CommonFla
	{
		
		/**物品掉落皮肤
		 */
		public static var dropGoodsBitmapData:BitmapData
		private static var _isSet:Boolean=false
		
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
	
		private static var resData:Object;
		public function CommonFla()
		{
		}
		/** 初始化 common fla文件的各个元件 
		 */		
		public static function initUI():void
		{
			////影子
			///初始化CD数据
			YFCDData.iniCD();  ////防止游戏进行中创建造成卡   因为他里面有 像素draw的过程  所以需要预先处理
			////初始化文本数字
			ImageTextManager.Instance; ////防止游戏进行中创建造成卡 因为他里面有 像素draw的过程  所以需要预先处理
			
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitActionData,onDataComplete);
		}
		private static function onDataComplete(e:YF2dEvent):void
		{
			if(RoleFakeSkin.flashTexture)RoleFakeSkin.flashTexture.dispose();
			var bitmapData:BitmapData=resData.bitmapData;
			var texture:TextureBase=TextureHelper.Instance.getTexture(bitmapData);
			RoleFakeSkin.flashTexture=texture
			DropGoodsFakeSkin.flashTexture=texture;
			BloodFrameSkin.flashTexture=texture;
			BloodProgressSKin.flashTexture=texture;
		}
		/**重新初始化Texture
		 */
		public static function initTexture():void
		{
			var head:Object=resData.head;  ///  {x   y   w    h  信息 }
			var bitmapData:BitmapData=resData.bitmapData;
			var texture:TextureBase=TextureHelper.Instance.getTexture(bitmapData);
			///创建 阴影
//			var shodowObj:Object=head["shadowSkin"];
//			ShadowTexture=new ResSimpleTexture();
//			ShadowTexture.setTextureRect(shodowObj.x,shodowObj.y,shodowObj.w,shodowObj.h);
//			ShadowTexture.setUVData(Vector.<Number>([shodowObj.x/bitmapData.width,shodowObj.y/bitmapData.height,shodowObj.w/bitmapData.width,shodowObj.h/bitmapData.height]));
//			ShadowTexture.x=-shodowObj.w*0.5;
//			ShadowTexture.y=-shodowObj.h*0.5;
//			ShadowTexture.atlasData=bitmapData;
//			ShadowTexture.flashTexture=texture;
			///创建 人物替代物品
			var roleSKin:Object=head["roleSkin"];
			RoleFakeSkin=new ResSimpleTexture(false);
			RoleFakeSkin.setTextureRect(roleSKin.x,roleSKin.y,roleSKin.w,roleSKin.h);
//			RoleFakeSkin.setTextureRect(roleSKin.w,roleSKin.h);
			RoleFakeSkin.setUVData(Vector.<Number>([roleSKin.x/bitmapData.width,roleSKin.y/bitmapData.height,roleSKin.w/bitmapData.width,roleSKin.h/bitmapData.height]));
			
			RoleFakeSkin.x=0;
			RoleFakeSkin.y=-roleSKin.h*0.5-10;
			RoleFakeSkin.atlasData=bitmapData;
			RoleFakeSkin.flashTexture=texture;
			
//			TextureProxy.Instance.flashTexture=texture;
//			TextureProxy.Instance.x=0;
//			TextureProxy.Instance.y=-roleSKin.h*0.5-10;
//			TextureProxy.Instance.setTextureRect(roleSKin.x,roleSKin.y,roleSKin.w,roleSKin.h);
//			TextureProxy.Instance.setUVData(Vector.<Number>([roleSKin.x/bitmapData.width,roleSKin.y/bitmapData.height,roleSKin.w/bitmapData.width,roleSKin.h/bitmapData.height]));
			
			
			///创建  掉落替代物品
			var dropObj:Object=head["dropSkin"];
			DropGoodsFakeSkin=new ResSimpleTexture(false);
			DropGoodsFakeSkin.setTextureRect(dropObj.x,dropObj.y,dropObj.w,dropObj.h);
//			DropGoodsFakeSkin.setTextureRect(dropObj.w,dropObj.h);
			DropGoodsFakeSkin.setUVData(Vector.<Number>([dropObj.x/bitmapData.width,dropObj.y/bitmapData.height,dropObj.w/bitmapData.width,dropObj.h/bitmapData.height]));
			DropGoodsFakeSkin.atlasData=bitmapData;
			DropGoodsFakeSkin.flashTexture=texture;
			if(!dropGoodsBitmapData)
			{
				dropGoodsBitmapData=new BitmapData(dropObj.w,dropObj.h,true,0xFFFFFF);
				var mat:Matrix=new Matrix();
				mat.tx=-dropObj.x;
				mat.ty=-dropObj.y;
				dropGoodsBitmapData.draw(bitmapData,mat);
			}
			
			////创建人物血条框
			var bloodFrameObj:Object=head["bloodFrame"];
			BloodFrameSkin=new ResSimpleTexture(false);
			BloodFrameSkin.setTextureRect(bloodFrameObj.x,bloodFrameObj.y,bloodFrameObj.w,bloodFrameObj.h);
//			BloodFrameSkin.setTextureRect(bloodFrameObj.w,bloodFrameObj.h);
			BloodFrameSkin.setUVData(Vector.<Number>([bloodFrameObj.x/bitmapData.width,bloodFrameObj.y/bitmapData.height,bloodFrameObj.w/bitmapData.width,bloodFrameObj.h/bitmapData.height]));
			BloodFrameSkin.x=0;
			BloodFrameSkin.y=0;
			BloodFrameSkin.atlasData=bitmapData;
			BloodFrameSkin.flashTexture=texture;
			///创建人物血条 进度条
			var bloodProgress:Object=head["bloodProgress"];
			BloodProgressSKin=new ResSimpleTexture(false);
			BloodProgressSKin.setTextureRect(bloodProgress.x,bloodProgress.y,bloodProgress.w,bloodProgress.h);
//			BloodProgressSKin.setTextureRect(bloodProgress.w,bloodProgress.h);
			BloodProgressSKin.setUVData(Vector.<Number>([bloodProgress.x/bitmapData.width,bloodProgress.y/bitmapData.height,bloodProgress.w/bitmapData.width,bloodProgress.h/bitmapData.height]));
			BloodProgressSKin.x=0;
			BloodProgressSKin.y=0;
			BloodProgressSKin.atlasData=bitmapData;
			BloodProgressSKin.flashTexture=texture;
		}
		/**出来加载进来的res文件 进行解析成游戏需要的  阴影  以及人物替代图片
		 */		
		public static function initRes(data:Object):void
		{
			resData=data;
		}
		
		
		
	}
}