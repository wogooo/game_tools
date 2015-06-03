package com.YFFramework.core.yf2d.textures
{
	import com.YFFramework.core.FlashConfig;
	import com.YFFramework.core.center.manager.update.QueenTimeOut;
	import com.YFFramework.core.center.update.UpdateTT;
	import com.YFFramework.core.yf2d.core.TextureNumManager;
	
	import flash.display.BitmapData;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;
	import flash.display3D.textures.Texture;
	import flash.display3D.textures.TextureBase;
	import flash.events.Event;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getTimer;

	/**材质生成器
	 * author :夜枫
	 * 时间 ：2011-12-6 下午01:03:06
	 */
	public final class TextureHelper 
	{
		private static var _instance:TextureHelper;
		private var context3d:Context3D;
		
		public static const BGRA:String=Context3DTextureFormat.BGRA;
		
		//  fp 11.7
//		public static const BGRA_PACKED:String="bgraPacked4444";//Context3DTextureFormat.BGRA_PACKED;

		/** texture的格式
		 */
		private var _format:String=BGRA;
		
		
		private var _dict:Dictionary;
		
		/** atf材质 创建  保证 1帧 只创建 1 个
		 */
//		private var _atfDict:Vector.<TextureData>;
//		private var _atfSize:int;
		
		
		public function TextureHelper()
		{
//			if(FlashConfig.Instance.getFlashVersion()>=11.7)
//			{
//				_format=BGRA_PACKED;
//			}
//			else _format=BGRA;
			_dict=new Dictionary();
//			_atfDict=new Vector.<TextureData>();
//			_atfSize=0;
		//	UpdateManager.Instance.framePer.regFunc(update);
		}
		public function initData(context3d:Context3D):void{	this.context3d=context3d;			}
		
		public static  function get Instance():TextureHelper
		{
			if(!_instance) _instance=new TextureHelper();
			return _instance;
		} 
		
		public function getTexture(atlasData:BitmapData):TextureBase
		{
			if(context3d.driverInfo!="Disposed")
			{
				////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
//				var texture:Texture=context3d.createTexture(atlasData.width,atlasData.height,Context3DTextureFormat.BGRA,falseT);
				
//				var t:Number=getTimer();
				var texture:Texture=context3d.createTexture(atlasData.width,atlasData.height,_format,false);
				texture.uploadFromBitmapData(atlasData,0);
				UpdateTT.AnalysseIt =UpdateTT.DefaultValue;
				TextureNumManager.increase();
//				trace("bitmapData解码消耗时间",getTimer()-t);
//				print(this,"宽度",atlasData.width,"高度:",atlasData.height,"时间:",getTimer()-t);
				return texture;
			}
			return null;
		}     
		
		
		private static var _preTime:Number=0;
		/**
		 * @param atlasData
		 * @param completeCall 回调   completeCall(texture,param);
		 * @param param
		 * @return 
		 */		
		public function getTextureBitmapData(atlasData:BitmapData,completeCall:Function,param:Object):TextureBase
		{
			if(context3d.driverInfo!="Disposed")
			{
				var texture:Texture=context3d.createTexture(atlasData.width,atlasData.height,_format,false);
				TextureNumManager.increase();
				if(getTimer()-_preTime>=50)
				{
					_preTime=getTimer();
					texture.uploadFromBitmapData(atlasData,0);
					UpdateTT.AnalysseIt =UpdateTT.DefaultValue;
					completeCall(texture,param);
					return texture;
				}
				else 
				{
					var t:QueenTimeOut=new QueenTimeOut(50,completeCallIt,{param:param,texture:texture,call:completeCall,atlasData:atlasData});
					t.start();
				}
			} 
			return null;
		}      
		private function completeCallIt(parm:Object):void
		{
			var texture:Texture=parm.texture as Texture;
			texture.uploadFromBitmapData(parm.atlasData as BitmapData,0);
			UpdateTT.AnalysseIt =UpdateTT.DefaultValue;
			parm.call(texture,parm.param);
		}

		
		
		
		
//		public function getTextureFromATF2(atfBytes:ByteArray,width:int,height:int):Texture
//		{
//			if(context3d.driverInfo!="Disposed")
//			{
//				//				var t:Number=getTimer();
//				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
//				texture.uploadCompressedTextureFromByteArray(atfBytes,0,true);
//				//				trace("atf::",getTimer()-t);
//				return texture;
//			}
//			return null;
//		}
		
//		public function getTextureFromATF3(atfBytes:ByteArray,width:int,height:int):Texture
//		{
//			if(context3d.driverInfo!="Disposed")
//			{
//				//				var t:Number=getTimer();
//				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, false);
//				texture.uploadCompressedTextureFromByteArray(atfBytes,0,true);
//				//				trace("atf::",getTimer()-t);
//				return texture;
//			}
//			return null;
//		}


		
		/**atfBytes ATF  字节数据
		 */		
		public function getTextureFromATF(atfBytes:ByteArray,width:int,height:int,callBack:Function,param:Object=null):void
		{
			////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
			if(context3d.driverInfo!="Disposed")
			{
//				var t:Number=getTimer();
				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
				TextureNumManager.increase();
				texture.addEventListener("textureReady",onRendy);
				_dict[texture]={call:callBack,param:param};
				texture.uploadCompressedTextureFromByteArray(atfBytes,0,true);
//				trace("atf::",getTimer()-t);
//				return texture;
			}
//			return null; 
		}
		public function getTextureFromATFAlpha(atfBytes:ByteArray,width:int,height:int):Texture
		{
			////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
			if(context3d.driverInfo!="Disposed")
			{
				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, false);
//				var texture:Texture = context3d.createTexture(width, height, _format, false);
				texture.uploadCompressedTextureFromByteArray(atfBytes,0,true);
				TextureNumManager.increase();
				
				if(UpdateTT.AnalysseIt<=3)UpdateTT.AnalysseIt++;
				return texture;
			}
			return null; 
		}
		
		
		/**只用于地图生成
		 */		
		public function getTextureFromATFAlphaMap(atfBytes:ByteArray,width:int,height:int):Texture
		{
			////流式 处理  先加载低像素 图片生成   Texture 等高像素图片生成后在加载高像素图片生成Texture  马赛克处理手法和常规一模一样 地图也是一块一块的拼接起来的的
			if(context3d.driverInfo!="Disposed")
			{
//				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.BGRA, false);
				var texture:Texture = context3d.createTexture(width, height, Context3DTextureFormat.COMPRESSED, false);
				
				texture.uploadCompressedTextureFromByteArray(atfBytes,0,true);
				TextureNumManager.increase();
//				if(UpdateTT.AnalysseIt<=4)UpdateTT.AnalysseIt++;
				return texture;
			}
			return null; 
		}
		
//		public function update():void
//		{
//			if(_atfSize>0)
//			{
//				_atfSize--;
//				var textureData:TextureData=_atfDict.pop(); 
//				textureData.handle();
//				TextureData.toTextureDataPool(textureData);
//			}
//		}
		
		
		
		private function onRendy(e:Event):void
		{
			 var target:Texture=e.currentTarget as Texture;
			 target.removeEventListener("textureReady",onRendy);
			 var obj:Object=_dict[target];
			 if(obj)
			 {
				 obj.call(target,obj.param); //回调
				 
			 }
			 delete _dict[target];
		}
		
		
		
	}
}