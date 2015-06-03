package com.YFFramework.game.core.module.mapScence.world.view.player
{
	/**物品掉落
	 * @author yefeng
	 *2012-10-30下午9:43:47
	 */
	import com.YFFramework.core.event.YFEvent;
	import com.YFFramework.core.ui.yf2d.data.ATFActionData;
	import com.YFFramework.core.utils.net.SourceCache;
	import com.YFFramework.core.yf2d.core.YF2d;
	import com.YFFramework.core.yf2d.events.YF2dEvent;
	import com.YFFramework.core.yf2d.textures.TextureHelper;
	import com.YFFramework.core.yf2d.textures.sprite2D.ResSimpleTexture;
	import com.YFFramework.game.core.global.MouseManager;
	import com.YFFramework.game.core.global.MouseStyle;
	import com.YFFramework.game.core.global.manager.CommonEffectURLManager;
	import com.YFFramework.game.core.module.mapScence.world.model.RoleDyVo;
	import com.YFFramework.game.core.module.system.data.SystemConfigManager;
	import com.YFFramework.game.ui.res.CommonFla;
	
	import flash.display.BitmapData;
	import flash.geom.Point;
	
	public class DropGoodsPlayer extends NPCPlayer
	{
		/**简单材质   物品图标
		 */		
		private var _resSimpleTexture:ResSimpleTexture;
		
		private var _bitmapData:BitmapData;
		public function DropGoodsPlayer(roleDyVo:RoleDyVo=null)
		{
			super(roleDyVo);
			addDropEffect();
//			SelectNameColorTransform=new ColorTransform(0.75, 0.75, 0.75, 1);
			addContextChangeEvent();
		}
		/** 重新创建材质
		 */		
		private function addContextChangeEvent():void
		{
			YF2d.Instance.scence.addEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onContextCreate);
		}
		
		private function removeContextChangeEvent():void
		{
			YF2d.Instance.scence.removeEventListener(YF2dEvent.CONTEXT_Re_CREATE_InitMovieClip,onContextCreate);
		}
		/**创建材质
		 */		
		private function onContextCreate(e:YF2dEvent):void
		{
			if(_resSimpleTexture)
			{
//				if(_resSimpleTexture.flashTexture)_resSimpleTexture.flashTexture.dispose();   
//				_resSimpleTexture.flashTexture=TextureHelper.Instance.getTexture(_resSimpleTexture.atlasData);
				initGoodsSkin(_resSimpleTexture);
			}
			
		}
		override public function resetSkin():void
		{
			///设置默认物品皮肤
			initGoodsSkin(CommonFla.DropGoodsFakeSkin);
			_bitmapData=CommonFla.dropGoodsBitmapData;
//			_cloth.initData(null);
			_cloth.playTweenStop();
		}
		
		/**设置字体颜色
		 */
		override public function updateName():void
		{
			_nameItem1.setText(roleDyVo.roleName,0xFFFF00);
			reLocateNamePosition();
		}

		
		override protected function initNameLayer():void
		{
			super.initNameLayer();
//			_nameItem1.setY(_cloth.mainClip.y-40);
			_nameLayer.y=_cloth.mainClip.y-40;
		}
		/**初始化手势
		 */		
		override protected function initMouseCursor(select:Boolean):void
		{
			if(select)
			{
				MouseManager.changeMouse(MouseStyle.Pick);
				scaleX=1.1;
				scaleY=1.1;
			}
			else 
			{
				MouseManager.resetToDefaultMouse();
				scaleX=1;
				scaleY=1;
			}
		}

		/**初始化皮肤
		 */		
		public function initGoodsSkin(resSimpleTexture:ResSimpleTexture):void
		{
			if(!_isDispose)	
			{
				_cloth.setBitmapFrame(resSimpleTexture,resSimpleTexture.flashTexture,resSimpleTexture.atlasData);////设置  默认皮肤
				_resSimpleTexture=resSimpleTexture;
				if(_resSimpleTexture)_bitmapData=_resSimpleTexture.atlasData;
			}
		}

		private function addDropEffect(quality:int=1):void
		{
			var url:String=CommonEffectURLManager.DropGoodsEffectNormal;
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			if(actionData)
			{
				addFrontEffect(actionData,[0],true);
			}
			else 
			{
				SourceCache.Instance.addEventListener(url,dropEffectComplete);
				SourceCache.Instance.loadRes(url,this);
			}
			
		}
		
		override protected function updatePostion(e:YFEvent=null):void
		{
			_roleDyVo.mapX=int(_mapX);
			_roleDyVo.mapY=int(_mapY);
//			x =CameraProxy.Instance.x+_roleDyVo.mapX-CameraProxy.Instance.mapX;
//			y=CameraProxy.Instance.y+_roleDyVo.mapY-CameraProxy.Instance.mapY;
			setXY(CameraProxy.Instance.x+_roleDyVo.mapX-CameraProxy.Instance.mapX,CameraProxy.Instance.y+_roleDyVo.mapY-CameraProxy.Instance.mapY);
			updateOtherPostion();
		}
		
		private function dropEffectComplete(e:YFEvent):void
		{
			var url:String=e.type;
			SourceCache.Instance.removeEventListener(url,dropEffectComplete);
			var actionData:ATFActionData=SourceCache.Instance.getRes2(url) as ATFActionData;
			var goodsVect:Vector.<Object>=e.param as Vector.<Object>;
			for each(var dropGoodsPlayer:DropGoodsPlayer in goodsVect)
			{
				if(!dropGoodsPlayer.isDispose)	dropGoodsPlayer.addFrontEffect(actionData,[0],true);
			}
		}
		/**物品掉落表现
		 */		
		public function drop():void
		{
			var path:Array=[];
			var pt:Point=new Point(roleDyVo.mapX,roleDyVo.mapY-30);
			path.push(pt);
			pt=new Point(roleDyVo.mapX,roleDyVo.mapY+20);
			path.push(pt);
			pt=new Point(roleDyVo.mapX,roleDyVo.mapY);
			path.push(pt);
			setMapXY(roleDyVo.mapX,roleDyVo.mapY-30);
			sMoveTo(path,8);
		}
		
		override public function dispose(childrenDispose:Boolean=true):void
		{
			super.dispose(childrenDispose);
			removeContextChangeEvent();
			_resSimpleTexture=null;
		}
		
		/**更新统设置
		 */		
		override public function updateSystemConfig():void
		{
			_nameItem1.visible=SystemConfigManager.showAllItemName;
		}
		public function getBitmapData():BitmapData
		{
		//	return _resSimpleTexture.atlasData;
			return _bitmapData;
		}
	}
}